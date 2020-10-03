#!/usr/bin/env python3

from joblib import Parallel, delayed
import matplotlib.pyplot as plt
import multiprocessing as mp
import nest
import numpy as np
import os
import os.path
from os.path import join

def poisson_generator(rate, t_lim, unit_ms=False):
    """
    Draw events from a Poisson point process.

    Note: the implementation assumes at t=t_lim[0], although this spike is not
    included in the spike list.

    inputs:
    :param rate: the rate of the discharge in Hz
    :param t_lim: tuple containing start and end time of the spike
    :param unit_ms: use ms as unit for times in t_lim and resulting events
    :returns: numpy array containing spike times in s (or ms, if unit_ms is set)
    """

    assert len(t_lim) == 2

    if unit_ms:
        t_lim = (t_lim[0]/1000., t_lim[1]/1000.)

    if rate > 0.:
        events_ = [t_lim[0]]

        while events_[-1] < t_lim[1]:
            T = t_lim[1] - events_[-1]

            # expected number of events
            num_expected = T * rate

            # number of events to generate
            num_generate = np.ceil(num_expected+3*np.sqrt(num_expected))
            num_generate = int(max(num_generate, 1000))

            beta = 1. / rate
            isi_ = np.random.exponential(beta, size=num_generate)
            newevents_ = np.cumsum(isi_) + events_[-1]
            events_ = np.append(events_, newevents_)

        lastind = np.searchsorted(events_, t_lim[1])
        events_ = events_[1:lastind]  # drop ghost spike at start

        if unit_ms:
            events_ *= 1000.

    elif rate == 0.:
        events_ = np.asarray([])

    else:
        raise ValueError('requested negative rate.')

    return events_

def generate_stimulus(t_sim, rate, event_rate, jitter=0., sequence=False, num_neurons=200, num_event_neurons=100):
    """
    Generate the target spikes for the experiments: a list containing a list of
    spikes for each input neuron. The first 100 neurons are subject to events
    (synchronous input) with optional jitter or firing in a sequence.

    :param t_sim: simulation time
    :param rate: background firing rate of all neurons in Hz
    :param event_rate: rate of synchronized firing events in Hz
    :param jitter: standard deviation of jitter added to synchronous firing events in ms
    :param sequence: bool indicating whether neurons firing in a sequence
    :param num_neurons: number of input neurons
    :param num_event_neurons: number of input neurons which are subject to synchronized events
    :returns: list containing a list of spike times for each of the input neurons
    """

    # generate background spikes
    spikes_ = [poisson_generator(rate, (.1, t_sim), unit_ms=True) for n in range(num_neurons)]

    # generate event spikes
    if event_rate > 0.:
        events_ = poisson_generator(event_rate, (0., t_sim), unit_ms=True)

        for n in range(num_event_neurons):
            # add sequence offset
            offs1 = n if sequence else 0.

            # add jitter
            offs2 = jitter * np.random.randn(*events_.shape) if jitter > 0. else 0.

            spikes_[n] = np.sort(np.append(spikes_[n], events_ + offs1 + offs2))

        # round to .1 ms (NEST time step)
        spikes_ = [np.round(10.*spikes)/10. for spikes in spikes_]

        # clip negative values (may occur due to jitter)
        spikes_ = [np.clip(spikes, .1, None) for spikes in spikes_]

    return spikes_

def correlate_sets(spikes1_, spikes2_, binsize, corr_range, num_pairs=None, allow_same_indices=True, use_mp=True):
    """
    Computed a binned correlation between two groups of units where a sets of
    events is given for each unit.

    :param spikes1_: list containing lists of events for units in group 1
    :param spikes2_: list containing lists of events for units in group 2
    :param binsize: size of bins for correlation
    :param corr_range: tuple containing min and max offset for correlation
    :param num_pairs: number of pairs to use for correlation, if None, all pairs are used
    :param allow_same_indices: whether to allow computing correlations for the same index for both sets
    :param use_mp: whether to use multiprocessing
    """

    if num_pairs is None:
        ind1_ = np.arange(len(spikes1_))
        ind2_ = np.arange(len(spikes2_))
        pairs = np.asarray(np.meshgrid(ind1_, ind2_)).T.reshape(-1, 2).T
    else:
        ind1_ = np.random.randint(len(spikes1_), size=num_pairs)
        ind2_ = np.random.randint(len(spikes2_), size=num_pairs)
        pairs = np.vstack((ind1_, ind2_))

    if not allow_same_indices:
        for k, (x, y) in enumerate(zip(pairs[0,:], pairs[1,:])):
            if x == y:
                pairs[1,k] = (y + 1) % len(spikes2_)

    x_ = [spikes1_[k] for k in pairs[0,:]]
    y_ = [spikes2_[k] for k in pairs[1,:]]
    bs_ = [binsize] * len(x_)
    cr_ = [corr_range] * len(y_)

    if use_mp:
        r_ = Parallel(n_jobs=mp.cpu_count())(delayed(binned_correlation)(x, y, bs, cr) for x, y, bs, cr in zip(x_, y_, bs_, cr_))
    else:
        r_ = [binned_correlation(x, y, bs, cr) for x, y, bs, cr in zip(x_, y_, bs_, cr_)]

    t_, corr_ = zip(*r_)
    t_ = t_[0]

    return t_, np.sum(corr_, axis=0)

def binned_correlation(t1_, t2_, binsize, corr_range):
    """
    Computed a binned correlation between two sets of events.

    :param t1_: times of events in set 1
    :param t2_: times of events in set 2
    :param binsize: size of bins for correlation
    :param corr_range: tuple containing min and max offset for correlation
    """
    assert len(corr_range) == 2

    dt_low, dt_high = corr_range
    t_ = np.arange(dt_low, dt_high+binsize, binsize)
    N_bins = len(t_)
    bin0 = int(np.round(N_bins/2.))

    corr_ = np.zeros_like(t_)

    for t2 in t2_:
        ind_low = np.searchsorted(t1_, t2+dt_low)
        ind_high = np.searchsorted(t1_, t2+dt_high)

        for t1 in t1_[ind_low:ind_high]:
            ind = int(np.round((t2-t1)/binsize)) + bin0
            corr_[ind] += 1

    return t_, corr_

def experiment(sequence=False, jitter=0., alpha=1.1, outdir=None, title=''):
    """
    Perform a single STDP experiment.

    :param sequence: whether first 100 neurons should fired sequentially when events occur
    :param jitter: std of jitter for synchronized events in ms
    :param alpha: relative shape of negative part of STDP
    :param outdir: output directory for saving plots
    :param title: base name for saving plots
    """

    # setup NEST

    nest.ResetKernel()

    num_cpu = mp.cpu_count()
    nest.SetKernelStatus({'local_num_threads': num_cpu})

    seeds = np.random.choice(10000, size=num_cpu+1)
    #nest.SetKernelStatus({'grng_seed': seeds[0], 'rng_seeds': seeds[1:].tolist()})
    nest.SetKernelStatus({'grng_seed': seeds[0]})

    # create input spikes
    t_sim = 200000.

    target_spikes = generate_stimulus(t_sim, 8., 2., jitter, sequence)
    N_inputs = len(target_spikes)

    # ----------------------------------------------------------------------
    # TODO beginning: setup network: create units, wire network, setup spike
    # detectors for input neurons and the LIF neuron
    #
    # some variable names are required:

    lif_neuron = nest.Create('iaf_psc_exp', 1, params={'E_L': -65.0, 'C_m': 20000.0, 'tau_syn_ex': 10.0,
                                                       't_ref': 2.0, 'V_th': -45.0, 'V_reset': -65.0,
                                                       'tau_m': 0.001 * 20000.0, 'tau_minus': 40.0})

    nest.SetDefaults('stdp_synapse', params={'tau_plus': 40.0, 'lambda': 0.005, 'mu_plus': 0.0, 'mu_minus': 0.0,
                                             'Wmax': 2000.0 * 2.0, 'alpha': alpha})

    input_neurons = nest.Create('parrot_neuron', 200)
    for i in range(N_inputs):
      spike_generator = nest.Create('spike_generator', 1, params={'spike_times': target_spikes[i]})
      nest.Connect(spike_generator, (input_neurons[i], ))

    rule_dict = {'rule': 'all_to_all'}
    syn_spec = {'model': 'stdp_synapse', 'weight': 2000.0}
    nest.Connect(input_neurons, lif_neuron, rule_dict, syn_spec)

    spike_detector = nest.Create('spike_detector')
    nest.Connect(lif_neuron, spike_detector)
    spike_detector_input = nest.Create('spike_detector')
    nest.Connect(input_neurons, spike_detector_input)

    # save connections between input neurons and lif neuron
    conns = nest.GetConnections(source=input_neurons, target=lif_neuron)

    # TODO end
    # ----------------------------------------------------------------------

    # simulate

    t_step = 1000.
    t_ = np.arange(0., t_sim, t_step)
    weights = np.zeros((N_inputs, len(t_)))

    for k in range(len(t_)):
        weights[:,k] = np.asarray(nest.GetStatus(conns, 'weight'))
        nest.Simulate(1000.)

    # analysis

    neuron_spikes = nest.GetStatus(spike_detector, 'events')[0]['times']
    print('num neuron spikes:', len(neuron_spikes))

    # spike sorting
    input_spike_events = nest.GetStatus(spike_detector_input, 'events')[0]
    input_spikes = []
    for n in range(min(input_neurons), max(input_neurons)+1):
        mask = (input_spike_events['senders'] == n)
        input_spikes += [input_spike_events['times'][mask]]

    # weight statistics
    w_ev_mean = weights[:100,:].mean(axis=0)
    w_ev_std = weights[:100,:].std(axis=0)
    w_noev_mean = weights[100:,:].mean(axis=0)
    w_noev_std = weights[100:,:].std(axis=0)

    # crop spike times in order to save time during convolution
    t_max_spikes = 25000.
    neuron_spikes = neuron_spikes[neuron_spikes<t_max_spikes]
    for k in range(len(input_spikes)):
        input_spikes[k] = input_spikes[k][input_spikes[k]<t_max_spikes]

    spikes_ev, spikes_noev = input_spikes[:100], input_spikes[100:]
    num_pairs = 200
    binsize = 5.
    corr_range = (-100., 100.)

    t_corr_, ii_corr_ev = correlate_sets(
            spikes_ev,
            spikes_ev,
            binsize=binsize,
            corr_range=corr_range,
            num_pairs=num_pairs,
            allow_same_indices=False)
    t_corr_, ii_corr_noev = correlate_sets(
            spikes_noev,
            spikes_noev,
            binsize=binsize,
            corr_range=corr_range,
            num_pairs=num_pairs,
            allow_same_indices=False)
    t_corr_, io_corr_ev = correlate_sets(
            spikes_ev,
            [neuron_spikes],
            binsize=binsize,
            corr_range=corr_range)
    t_corr_, io_corr_noev = correlate_sets(
            spikes_noev,
            [neuron_spikes],
            binsize=binsize,
            corr_range=corr_range)

    # plot

    t_max_plot = 5000.

    plt.figure(figsize=(10.5, 5.5))

    for n, spikes in enumerate(input_spikes):
        c = 'C0' if n < 100 else 'C1'
        plt.scatter(spikes, n*np.ones_like(spikes), c=c, marker='.', s=1.)
    plt.xlim(0., t_max_plot)
    plt.ylim(0, len(input_spikes))
    plt.xlabel(r'$t$ / ms')
    plt.ylabel(r'input neuron')
    plt.locator_params(nbins=3)

    if title:
        plt.savefig(join(outdir, title+'_input_spikes.pdf'))

    plt.figure(figsize=(12, 6.))

    plt.subplot(1, 2, 1)
    plt.imshow(weights, aspect='auto')
    plt.colorbar()
    plt.ylim(0, 200)
    plt.xlabel(r'$t$ / s')
    plt.ylabel(r'input neuron')
    plt.text(-.19, 1.07, 'A', fontsize='large', transform=plt.gca().transAxes)

    plt.subplot(1, 2, 2)
    plt.plot(t_/1000., w_ev_mean, c='C0', lw=2., label='group 1')
    plt.plot(t_/1000., w_noev_mean, c='C1', lw=2., label='group 2')
    plt.errorbar(t_[::25]/1000., w_ev_mean[::25], w_ev_std[::25], c='C0', fmt='.', capsize=5.)
    plt.errorbar(t_[::25]/1000., w_noev_mean[::25], w_noev_std[::25], c='C1', fmt='.', capsize=5.)
    plt.autoscale(axis='x', tight=True)
    plt.xlabel(r'$t$ / s')
    plt.ylabel(r'$\langle w \rangle$')
    plt.text(-.19, 1.07, 'B', fontsize='large', transform=plt.gca().transAxes)
    plt.legend(loc='best')

    #plt.tight_layout(w_pad=4., rect=(0., 0., 1., .96))

    if title:
        plt.savefig(join(outdir, title+'_weights.pdf'))

    plt.figure(figsize=(12., 12.))

    plt.subplot(2, 2, 1)
    plt.axvline(0., c='k', ls='--', alpha=.5)
    plt.plot(t_corr_, ii_corr_ev, marker = 'o', c='C0')
    plt.autoscale(axis='x', tight=True)
    plt.xlabel(r'$\Delta t$ / ms')
    plt.ylabel('count')
    plt.title('i/i corr. group 1')
    plt.text(-0.19, 1.07, 'A', fontsize='large', transform=plt.gca().transAxes)
    plt.locator_params(nbins=4)

    plt.subplot(2, 2, 2)
    plt.axvline(0., c='k', ls='--', alpha=.5)
    plt.plot(t_corr_, ii_corr_noev, marker = 'o', c='C1')
    plt.autoscale(axis='x', tight=True)
    plt.xlabel(r'$\Delta t$ / ms')
    plt.ylabel('count')
    plt.xlabel(r'$\Delta t$ / ms')
    plt.title('i/i corr. group 2')
    plt.text(-0.19, 1.07, 'B', fontsize='large', transform=plt.gca().transAxes)
    plt.locator_params(nbins=4)

    plt.subplot(2, 2, 3)
    plt.axvline(0., c='k', ls='--', alpha=.5)
    plt.plot(t_corr_, io_corr_ev, marker = 'o', c='C0')
    plt.autoscale(axis='x', tight=True)
    plt.xlabel(r'$\Delta t$ / ms')
    plt.ylabel('count')
    plt.title('i/o corr. group 1')
    plt.text(-0.19, 1.07, 'C', fontsize='large', transform=plt.gca().transAxes)
    plt.locator_params(nbins=4)

    plt.subplot(2, 2, 4)
    plt.axvline(0., c='k', ls='--', alpha=.5)
    plt.plot(t_corr_, io_corr_noev, marker = 'o', c='C1')
    plt.autoscale(axis='x', tight=True)
    plt.xlabel(r'$\Delta t$ / ms')
    plt.ylabel('count')
    plt.title('i/o corr. group 2')
    plt.xlabel(r'$\Delta t$ / ms')
    plt.text(-0.19, 1.07, 'D', fontsize='large', transform=plt.gca().transAxes)
    plt.locator_params(nbins=4)

    #plt.tight_layout(h_pad=4., w_pad=4., rect=(0., 0., 1., .96))

    if title:
        plt.savefig(join(outdir, title+'_correlations.pdf'))

def learning_window(**kwargs):
  params = dict()
  for key in kwargs:
    params[key] = kwargs[key]

  w0 = 2000.0
  w = w0
  delta_w_list = []
  times = [t for t in range(-200, 201)]
  for delta_t in times:
    if delta_t >= 0.0:
      delta_w = params['eta'] * (1 - w) ** params['mu_plus'] * np.exp(-abs(delta_t) / params['tau_plus'])
    else:
      delta_w = -params['eta'] * params['alpha'] * w ** params['mu_minus'] * np.exp(-abs(delta_t) / params['tau_minus'])
    delta_w_list.append(delta_w)

  plt.plot(times, delta_w_list, color='green')
  plt.axhline(y=0,linewidth=1, color='gray')
  plt.xlabel(r'$(t_{post} - t_{pre})$ / ms')
  plt.ylabel(r'$\Delta w$')
  plt.yticks([0])
  plt.tight_layout()
  plt.savefig('plots/4a_learning_window.pdf')

def explanation_4d():
  times = np.arange(0, 200)
  input_neurons = np.arange(0, 200)

  plt.figure()
  plt.scatter(times, input_neurons, s=1, label='presynaptic spikes', color='green')
  plt.axvline(x=25, c='grey', linestyle='--', linewidth=1, label='postsynaptic spike')
  plt.xticks([0, 25, 50, 75, 100, 125, 150, 175, 200])
  plt.yticks([0, 25, 50, 75, 100, 125, 150, 175, 200])
  plt.xlabel(r'$t$ / ms')
  plt.ylabel('input neuron group 1')

  plt.fill_between(x=[0, 25], y1=[205, 205], y2=[210, 210], color='red', alpha=0.15, label=r'$t_{post} \geq t_{pre}$')
  plt.fill_between(x=[25, 200], y1=[205, 205], y2=[210, 210], color='red', alpha=0.35, label=r'$t_{post} < t_{pre}$')

  plt.legend(loc='best')
  plt.tight_layout()
  plt.savefig('plots/4d_explanation.pdf')


if __name__ == '__main__':
    # setup output directory

    outdir = 'plots'
    outdir = os.path.join(os.path.dirname(__file__), outdir)

    if not os.path.exists(outdir):
        os.makedirs(outdir)

    # plot the learning window for task 4a
    # 4a
    learning_window(tau_plus=40.0, tau_minus=40.0, mu_plus=0.0, mu_minus=0.0, eta=0.005, alpha=1.1)

    # call experiment() for tasks 4b-e
    # e.g.

    # 4b
    experiment(sequence=False, jitter=0.0, alpha=1.1, outdir=outdir, title='4b')

    # 4c
    experiment(sequence=False, jitter=5.0, alpha=1.1, outdir=outdir, title='4c1')
    experiment(sequence=False, jitter=15.0, alpha=1.1, outdir=outdir, title='4c2')

    # 4d
    experiment(sequence=True, jitter=0.0, alpha=1.1, outdir=outdir, title='4d')
    explanation_4d()

    # 4e
    experiment(sequence=False, jitter=50.0, alpha=0.0, outdir=outdir, title='4e')

    plt.show()
