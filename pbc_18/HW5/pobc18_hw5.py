#!/usr/bin/env python

from joblib import Parallel, delayed
import matplotlib.pyplot as plt
import multiprocessing as mp
import nest
import numpy as np
import os
import os.path
from os.path import join
import pickle as pkl
from sklearn.model_selection import train_test_split


def poisson_generator(rate, t_lim, unit_ms=False):
  """
  Draw events from a Poisson point process.

  Note: the implementation assumes at t=t_lim[0], although this spike is not
  included in the spike list.

  :param rate: the rate of the discharge in Hz
  :param t_lim: tuple containing start and end time of the spike
  :param unit_ms: use ms as unit for times in t_lim and resulting events
  :returns: numpy array containing spike times in s (or ms, if unit_ms is set)
  """

  assert len(t_lim) == 2

  if unit_ms:
    t_lim = (t_lim[0] / 1000., t_lim[1] / 1000.)

  if rate > 0.:
    events_ = [t_lim[0]]

    while events_[-1] < t_lim[1]:
      T = t_lim[1] - events_[-1]

      # expected number of events
      num_expected = T * rate

      # number of events to generate
      num_generate = np.ceil(num_expected + 3 * np.sqrt(num_expected))
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


def generate_stimulus(num_sig, sim_time, stim_len, stim_dt, rate=200.):
  """
  Generate input spikes.

  :param num_sig: number of input signals (i.e. number of input neurons)
  :param sim_time: total time for stimulus generation
  :param stim_len: duration of each stimulus
  :param stim_dt: stimulus spacing
  :param rate: firing rate of active neurons
  :returns: list contain a list of spike times for each input neuron
  """

  num_stim = int(np.floor(sim_time / stim_dt) - 1)
  in_ = np.random.randint(2, size=(num_stim, num_sig))

  t_stim_ = stim_dt * np.arange(1, num_stim + 1)
  assert len(t_stim_) == in_.shape[0]

  spikes = [np.array([]) for n in range(num_sig)]

  for n in range(num_sig):
    for t, bit in zip(t_stim_, in_[:, n]):
      if bit == 1:
        spikes[n] = np.append(spikes[n], poisson_generator(rate, t_lim=(t, t + stim_len), unit_ms=True))

    # round to simulation precision
    spikes[n] = spikes[n].round(1)

  return in_, spikes


def get_spike_times_by_id(input, pop, unit_s=False):
  """
  Separate the spike times per neuron.

  :param input: list of length 2 containing times and senders
  :param pop: list of nest neuron ids
  :param unit_s: return spike times in s instead of in ms, default: False
  :returns: list containing a list of spike times for each neuron
  """

  times, senders = input

  if len(senders) == 0:
    return [], []

  spikes_per_id = []
  scale = 1000. if unit_s else 1.

  for id in pop:
    m = (senders == id)
    spikes_per_id += [times[m] / scale]

  return spikes_per_id


def __get_liquid_states_worker(neuron_spikes_, times_, tau):
  t_window = 3. * tau
  states_ = np.zeros_like(times_)

  for nt, t in list(enumerate(times_))[::-1]:
    # advance mask
    neuron_spikes_ = neuron_spikes_[neuron_spikes_ < t]

    # only use spikes within window
    spikes_cur_ = neuron_spikes_[neuron_spikes_ >= t - t_window]
    states_[nt] = np.exp(-(t - spikes_cur_) / tau).sum()

  return states_


def get_liquid_states(spikes_, times_, tau, use_mp=True):
  """
  Compute liquid states for given spikes of multiple neurons.

  :param spikes_: list of lists containing spike times for a neuron
  :param times_: times at which to extract liquid states
  :param tau: exponential decay time constant
  :param use_mp: whether to use mulitprocessing, default: True
  :returns: list containing liquid states at each requested time
  """

  N_neuron = len(spikes_)
  N_times = len(times_)
  states_ = np.zeros((N_times, N_neuron))

  if not use_mp:
    ret_ = [__get_liquid_states_worker(ns_, times_, tau) for ns_ in spikes_]

  else:
    delayed_ = (delayed(__get_liquid_states_worker)(ns_, times_, tau) for ns_ in spikes_)
    ret_ = Parallel(n_jobs=mp.cpu_count())(delayed_)

  states_ = np.asarray(ret_).T
  assert states_.shape == (N_times, N_neuron)

  return states_


def train_readout(X, y, Xt, yt, reg_fact=0):
  """
  Train and test a readout. Assumes labels are integers (0., ..., N_classes-1).

  :param X: training data
  :param y: training labels
  :param Xt: test data
  :param yt: test labels
  :param reg_fact: regularization constant, default: 0
  :returns: tuple of training and test error
  """

  # add constant component to states for bias
  X = np.hstack((np.ones((len(X), 1)), X))
  Xt = np.hstack((np.ones((len(Xt), 1)), Xt))

  # train
  if reg_fact == 0:
    w = np.linalg.lstsq(X, y)[0]
  else:
    I = np.eye(X.shape[1])
    w = np.linalg.inv(np.dot(X.T, X) + reg_fact * I).dot(X.T).dot(y)

  # compute predictions
  max_label = y.max()
  y_train = np.clip(np.dot(X, w).round(), 0., max_label).astype(int)
  y_test = np.clip(np.dot(Xt, w).round(), 0., max_label).astype(int)

  # compute errors
  train_err = (y_train != y).sum() / len(y)
  test_err = (y_test != yt).sum() / len(yt)

  return train_err, test_err


def experiment(task, reg_fact=0., simulate=True, outdir=None, title=''):
  """
  Perform an LSM experiment.

  :param task: target task for learning
  :param reg_fact: regularization parameter for readout training, default: 0
  :param simulate: whether SNN should be simulated, otherwise load data from pickle
  :param outdir: output directory for plots
  :param title: title for plots
  """

  pklfile = 'data.pkl'  # file name for data
  if simulate:
    # setup nest

    nest.ResetKernel()

    num_cpu = mp.cpu_count()
    nest.SetKernelStatus({'local_num_threads': num_cpu, 'print_time': True})
    seeds = np.random.choice(10000, size=num_cpu + 1)
    #nest.SetKernelStatus({'grng_seed': seeds[0], 'rng_seeds': seeds[1:].tolist()})
    nest.SetKernelStatus({'grng_seed': seeds[0]})

    # parameters

    sim_time = 500e3  # simulation time
    N_rec = 500  # number of neurons from which we will extract liquid states

    # ----------------------------------------------------------------------
    # create recurrent network nodes

    # TODO: create excitatory and inhibitory neurons, a noise generator,
    # and spike detectors using the parameters in the assignment sheet

    E_population = nest.Create('iaf_psc_exp', 1000, params={'C_m': 30.0, 'tau_m': 30.0, 'E_L': 0.0, 'V_th': 15.0,
                                                            'V_reset': 13.8, 'tau_syn_ex': 3.0, 'tau_syn_in': 2.0,
                                                            'I_e': 14.5})

    I_population = nest.Create('iaf_psc_exp', 250, params={'C_m': 30.0, 'tau_m': 30.0, 'E_L': 0.0, 'V_th': 15.0,
                                                           'V_reset': 13.8, 'tau_syn_ex': 3.0, 'tau_syn_in': 2.0,
                                                           'I_e': 14.5})

    population = E_population + I_population

    noise_generator = nest.Create('poisson_generator', params={'rate': 25.0})
    parrot_neuron = nest.Create('parrot_neuron')
    nest.Connect(noise_generator, parrot_neuron)

    E_spike_detector = nest.Create('spike_detector')
    nest.Connect(E_population, E_spike_detector)
    I_spike_detector = nest.Create('spike_detector')
    nest.Connect(I_population, I_spike_detector)

    # ----------------------------------------------------------------------
    # create stimulus and input nodes

    # create input generators
    num_sig = 3
    stim_len = 50.
    stim_dt = 500.

    # inputs: holds the actual inputs (3 bits per stimulus)
    # input_spikes: holds the spike times of 3 input neurons
    inputs, input_spikes = generate_stimulus(num_sig, sim_time, stim_len, stim_dt)

    # create spike generators

    # TODO: create spike_generators and set spike times as given in input_spikes
    input_neurons = nest.Create('parrot_neuron', 3)
    for i in range(3):
      spike_generator = nest.Create('spike_generator', 1, params={'spike_times': input_spikes[i]})
      nest.Connect(spike_generator, (input_neurons[i], ))

    in_spike_detector = nest.Create('spike_detector')
    nest.Connect(input_neurons, in_spike_detector)

    # ----------------------------------------------------------------------
    # connect nodes

    # TODO: connect nodes with given statistics

    delay_params = {'distribution': 'normal_clipped', 'low': 3.0, 'high': 200.0, 'mu': 10.0, 'sigma': 20.0}

    syn_spec_EE = {
      'model': 'tsodyks_synapse',
      'weight': 50.0,
      'delay': delay_params,
      'tau_psc': 2.,
      'tau_fac': 1.,
      'tau_rec': 813.,
      'U': .59,
      'u': .59,
      'x': 0.}

    syn_spec_EI = {
      'model': 'tsodyks_synapse',
      'weight': 250.0,
      'delay': delay_params,
      'tau_psc': 2.,
      'tau_fac': 1790.,
      'tau_rec': 399.,
      'U': .049,
      'u': .049,
      'x': 0.}

    syn_spec_IE = {
      'model': 'tsodyks_synapse',
      'weight': -200.0,
      'delay': delay_params,
      'tau_psc': 2.,
      'tau_fac': 376.,
      'tau_rec': 45.,
      'U': .016,
      'u': .016,
      'x': 0.}

    syn_spec_II = {
      'model': 'tsodyks_synapse',
      'weight': -200.0,
      'delay': delay_params,
      'tau_psc': 2.,
      'tau_fac': 21.,
      'tau_rec': 706.,
      'U': .25,
      'u': .25,
      'x': 0.}

    J = (0.5 * 50.0 + 1.5 * 50.0) / 2.0
    syn_spec_inp = {
      'model': 'static_synapse',
      'weight': {'distribution': 'normal_clipped', 'low': 0.5 * 50.0, 'high': 1.5 * 50.0, 'mu': J,'sigma': 0.7},
      'delay': delay_params}

    syn_spec_noise = {
      'weight': 5.0,
      'delay': delay_params}

    nest.Connect(parrot_neuron, population,
                 {'rule': 'all_to_all'},
                 syn_spec_noise)
    nest.Connect(E_population, E_population,
                 {'rule': 'fixed_indegree', 'indegree': 2},
                 syn_spec_EE)
    nest.Connect(I_population, I_population,
                 {'rule': 'fixed_indegree', 'indegree': 1},
                 syn_spec_II)
    nest.Connect(I_population, E_population,
                 {'rule': 'fixed_indegree', 'indegree': 1},
                 syn_spec_IE)
    nest.Connect(E_population, I_population,
                 {'rule': 'fixed_indegree', 'indegree': 2},
                 syn_spec_EI)

    nest.Connect(input_neurons, E_population,
                 {'rule': 'fixed_outdegree', 'outdegree': 100},
                 syn_spec_inp)


    # ----------------------------------------------------------------------
    # simulate

    nest.Simulate(sim_time)

    # ----------------------------------------------------------------------
    # analysis

    stat_X = nest.GetStatus(in_spike_detector, 'events')[0]
    stat_E = nest.GetStatus(E_spike_detector, 'events')[0]
    stat_I = nest.GetStatus(I_spike_detector, 'events')[0]

    spikes_X = stat_X['times'], stat_X['senders']
    spikes_E = stat_E['times'], stat_E['senders']
    spikes_I = stat_I['times'], stat_I['senders']

    # compute mean firing rates

    # TODO: compute rates
    rate_ex = ((len(spikes_E[0]) / 1000) / sim_time) * 1000
    rate_in = ((len(spikes_I[0]) / 250) / sim_time) * 1000

    # plot network activity
    # TODO: plot
    t_max_plot = sim_time

    fig, [ax1, ax2, ax3] = plt.subplots(3, 1, sharex=True)
    plt.locator_params(nbins=6)

    ax1.scatter(spikes_X[0] / 1000, spikes_X[1], c='red', marker='.', s=1.)
    ax1.set_xlim(0., t_max_plot / 1000)
    ax1.set_yticks([])
    ax1.set_ylabel(r'X')

    E_samples = np.random.choice(E_population, size=100, replace=False)
    I_samples = np.random.choice(I_population, size=100, replace=False)

    E_sample_spike_t, E_sample_neurons = [], []
    for i in range(len(spikes_E[0])):
      n = spikes_E[1][i]
      if n in E_samples:
        E_sample_spike_t.append(spikes_E[0][i] / 1000)
        E_sample_neurons.append(spikes_E[1][i])

    I_sample_spike_t, I_sample_neurons = [], []
    for i in range(len(spikes_I[0])):
      n = spikes_I[1][i]
      if n in I_samples:
        I_sample_spike_t.append(spikes_I[0][i] / 1000)
        I_sample_neurons.append(spikes_I[1][i])

    ax2.scatter(E_sample_spike_t, E_sample_neurons, c='green', marker='.', s=1.)
    ax2.set_xlim(0., t_max_plot / 1000)
    ax2.set_yticks([])
    ax2.set_ylabel(r'E')

    ax3.scatter(I_sample_spike_t, I_sample_neurons, c='blue', marker='.', s=1.)
    ax3.set_xlim(0., t_max_plot / 1000)
    ax3.set_yticks([])
    ax3.set_xlabel(r'$t$ / s')
    ax3.set_ylabel(r'I')

    if outdir and title:
      plt.savefig(join(outdir, title + '_spikes.pdf'))

    # extract spike times in an array per neuron
    spike_times = get_spike_times_by_id(spikes_E, E_population)

    if len(spike_times) == 0:
      print('no spikes, cannot extract liquid states')
      return

    with open(pklfile, 'wb') as f:
      pkl.dump([num_sig, inputs, spike_times, stim_dt, stim_len, N_rec, sim_time, rate_ex, rate_in], f)

  else:
    with open(pklfile, 'rb') as f:
      num_sig, inputs, spike_times, stim_dt, stim_len, N_rec, sim_time, rate_ex, rate_in = pkl.load(f)

  print('mean excitatory rate: {0:.2f} Hz'.format(rate_ex))
  print('mean inhibitory rate: {0:.2f} Hz'.format(rate_in))

  # generate targets
  if task == 'none':
    targets = None

  elif task == 'sum':
    targets = np.sum(inputs, axis=1)  # TODO: define targets using inputs

  elif task == 'xor':
    targets = np.logical_xor(inputs[:, 0], inputs[:, 1])  # TODO: define targets using inputs

  elif task == 'mem1':
    targets = inputs[:, 0]  # TODO: define targets using inputs

  elif task == 'memall':
    targets = inputs  # TODO: define targets using inputs

  else:
    raise ValueError()

  assert task == 'none' or len(targets) == inputs.shape[0]

  # ----------------------------------------------------------------------
  # train readouts

  # drop initial responses to allow dynamics to settle
  num_discard = 5

  # number of classifiers to train
  num_trained_classifiers = 20

  # liquid state: time constant for filtering spikes
  tau_lsm = 20.  # ms

  if task == 'none':
    pass

  elif task == 'xor' or task == 'sum':
    readout_delay = 20.  # ms
    rec_time_start = stim_dt + stim_len + readout_delay  # time of first liquid state
    times = np.arange(rec_time_start, sim_time, stim_dt)  # all times

    # extract liquid states at given times
    states = get_liquid_states(spike_times[:N_rec], times, tau_lsm)

    # discard first few states
    states = states[num_discard:, :]
    targets = targets[num_discard:]

    print('training readouts using regularization = {0:e}'.format(reg_fact))

    train_err_, test_err_ = [], []

    for i in range(num_trained_classifiers):
      states_train, states_test, targets_train, targets_test = train_test_split(
        states, targets, train_size=.8, test_size=.2)

      train_err, test_err = train_readout(
        states_train, targets_train, states_test, targets_test, reg_fact=reg_fact)

      train_err_ += [train_err]
      test_err_ += [test_err]

    train_mean, train_std = np.mean(train_err_), np.std(train_err_)
    test_mean, test_std = np.mean(test_err_), np.std(test_err_)

    print('  train error mean: {0:.3f}, std: {1:.3f}'.format(train_mean, train_std))
    print('  test error mean: {0:.3f}, std: {1:.3f}'.format(test_mean, test_std))

  elif task == 'mem1' or task == 'memall':
    readout_delays = np.arange(10., stim_dt - stim_len, 20.)

    # TODO: for each readout delay, extract the hidden states using a time
    # constant of tau_lsm, discard the first num_discard states, train
    # num_trained_classifiers classifiers on the states, and add the mean
    # errors to the lists

    targets_orig = targets
    train_mean_list, train_std_list, test_mean_list, test_std_list = [], [], [], []

    for readout_delay in readout_delays:
      rec_time_start = stim_dt + stim_len + readout_delay
      times = np.arange(rec_time_start, sim_time, stim_dt)
      states = get_liquid_states(spike_times[:N_rec], times, tau_lsm)

      states = states[num_discard:, :]
      targets = targets_orig[num_discard:]
      print('training readouts using regularization = {0:e}'.format(reg_fact))

      train_err_, test_err_ = [], []
      for i in range(num_trained_classifiers):
        states_train, states_test, targets_train, targets_test = train_test_split(
          states, targets, train_size=.8, test_size=.2)

        train_err, test_err = train_readout(
          states_train, targets_train, states_test, targets_test, reg_fact=reg_fact)

        train_err_ += [train_err]
        test_err_ += [test_err]

      train_mean, train_std = np.mean(train_err_), np.std(train_err_)
      test_mean, test_std = np.mean(test_err_), np.std(test_err_)

      print("readout delay %d" % readout_delay)
      print('  train error mean: {0:.3f}, std: {1:.3f}'.format(train_mean, train_std))
      print('  test error mean: {0:.3f}, std: {1:.3f}'.format(test_mean, test_std))
      print()

      train_mean_list.append(train_mean)
      train_std_list.append(train_std)
      test_mean_list.append(test_mean)
      test_std_list.append(test_std)

    # plot results

    assert len(readout_delays) == len(train_mean_list)
    assert len(readout_delays) == len(test_mean_list)

    plt.figure(figsize=(12., 4.))

    plt.subplot(1, 2, 1)
    plt.errorbar(readout_delays, train_mean_list, train_std_list)
    plt.xlabel('$\Delta t$')
    plt.ylabel('train error')
    plt.tight_layout()

    plt.subplot(1, 2, 2)
    plt.errorbar(readout_delays, test_mean_list, test_std_list)
    plt.xlabel('$\Delta t$')
    plt.ylabel('test error')
    plt.tight_layout()

    if outdir and title:
      plt.savefig(join(outdir, title + '_errors.pdf'))


# ----------------------------------------------------------------------
# main

if __name__ == '__main__':
  # setup output directory

  outdir = 'plots'
  outdir = join(os.path.dirname(__file__), outdir)

  if not os.path.exists(outdir):
    os.makedirs(outdir)

  # call experiment() for all tasks

  task = 'sum'
  #task = 'xor'
  #task = 'mem1'
  #task = 'memall'

  experiment(task=task, simulate=False, reg_fact=0., outdir=outdir, title='test_memall')

  plt.show()
