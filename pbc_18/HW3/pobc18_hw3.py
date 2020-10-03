#!/usr/bin/env python

import matplotlib.pyplot as plt
import multiprocessing
import nest
import numpy as np

def robustmean(x):
  return np.sum(x) / (np.maximum(len(x), 1))


def population_rate(spike_times, N, t_start, t_end, bin_width, bin_spacing):
  """
  Compute the population rate (in Hz).

  :param spike_times: vector of spike times (in ms)
  :param N: population size
  :param t_start: first time for rate computation (in ms)
  :param t_end: last time for rate computation (in ms)
  :param bin_width: width of a bin for a single rate value (in ms)
  :param bin_spacing: time difference between rate values (in ms)
  :returns: vector of times, vector of rates
  """
  bins = [(t_start, t_start + bin_width )]
  s = t_start
  while s + bin_width <= t_end:
    s += bin_spacing * bin_width
    e = s + bin_width
    bins.append((s, e))

  bin_values = [[] for _ in bins]
  for s in spike_times:
    for b in bins:
      if b[0] <= s < b[1]:
        bin_values[bins.index(b)].append(s)
        break

  rate = (np.asarray([(1 / bin_width) * (len(bin) / N) for bin in bin_values]))
  rate *= 1000 # convert to N-spikes per second

  times = [s + (e - s) / 2 for (s, e) in bins]

  return times, rate


def experiment(trials, rate_in, U, D, F):
  """
  Perform experiments with dynamical synapses and return the population rate
  average averaged over trials.

  :param trials: number of trials to perform
  :param rate_in: firing rate of input neurons (unit: Hz)
  :param U: efficacy increment for dynamical synapses (unit: 1)
  :param D: depression time constant for dynamical synapses (unit: s)
  :param F: facilitation time constant for dynamical synapses (unit: s)
  :returns: vector of times, vector of rates
  """
  rates_ = []

  for n in range(trials):
    nest.ResetKernel()

    print("================================")
    print("TRIAL: %d" % (n + 1))
    print("================================")

    # use multiprocessing
    num_cpu = multiprocessing.cpu_count()

    #nest.SetKernelStatus({'local_num_threads': num_cpu})
    #print(nest.GetKernelStatus({'local_num_threads'}))

    # set NEST random seeds
    seeds = np.random.choice(10000, size=num_cpu + 1)
    #nest.SetKernelStatus({'grng_seed': seeds[0], 'rng_seeds': seeds[1:].tolist()})
    nest.SetKernelStatus({'grng_seed': seeds[0]})

    poisson_gen = nest.Create('poisson_generator', params={'rate': float(rate_in),
                                                           'origin': 0.0,
                                                           'start': 0.0,
                                                           'stop': 2000.0})
    parrot_neurons = nest.Create('parrot_neuron', 500)
    nest.Connect(poisson_gen, parrot_neurons)

    nest.SetDefaults('tsodyks2_synapse', params={'U': U,
                                                 'u': 0.0,
                                                 'tau_rec': D * 1000,
                                                 'tau_fac': F * 1000})

    rule_dict = {'rule': 'fixed_indegree', 'indegree': 100}
    syn_spec = {'model': 'tsodyks2_synapse', 'weight': 100 / rate_in, 'delay': {'distribution': 'uniform',
                                                                                'low': 1.0,
                                                                                'high': 10.0}}
    lif_neurons = nest.Create('iaf_psc_delta', 1000, params={'E_L': -65.0,
                                                             'C_m': 2000.0,
                                                             'tau_m': 0.01 * 2000.0,
                                                             't_ref': 0.0,
                                                             'V_th': -50.0,
                                                             'V_reset': -80.0})

    nest.Connect(parrot_neurons, lif_neurons, rule_dict, syn_spec)

    spike_detector = nest.Create('spike_detector')
    nest.Connect(lif_neurons, spike_detector)

    nest.Simulate(2000)

    population_spike_t = nest.GetStatus(spike_detector, 'events')[0]['times']


    rate_times, rates = population_rate(spike_times=population_spike_t, N=1000, t_start=population_spike_t[0],
                                        t_end=population_spike_t[-1], bin_width=20, bin_spacing=0.5)
    rates_ += [rates]

  mean_rates = np.asarray(rates_).mean(axis=0)

  return rate_times, mean_rates


if __name__ == '__main__':
  print('TODO')
  # call experiment() function with given parameters for each task, plot
  # results, perform calculations, etc.

  # Task 3a
  print("========================")
  print("Task 3a")
  print("========================")
  times_1, rates_1 = experiment(trials=10, rate_in=20, U=0.16, D=0.045, F=0.376)
  times_2, rates_2 = experiment(trials=10, rate_in=20, U=0.16, D=0.045, F=0.1)
  print("[T3a, E1] Mean population rate of last 1000 ms: %f" % np.mean(rates_1[int(len(rates_1) / 2):]))
  print("[T3a, E2] Mean population rate of last 1000 ms: %f" % np.mean(rates_2[int(len(rates_2) / 2):]))

  plt.plot(times_1, rates_1, color='red', label='$F$: 0.376 s')
  plt.plot(times_2, rates_2, color='green', label='$F$: 0.1 s')
  plt.xlabel('$t$ / ms')
  plt.ylabel('population rate in Hz')
  plt.legend(loc='best')
  plt.tight_layout()
  plt.show()

  # Task 3b
  print("========================")
  print("Task 3b")
  print("========================")
  times_1, rates_1 = experiment(trials=10, rate_in=10, U=0.25, D=0.706, F=0.021)
  times_2, rates_2 = experiment(trials=10, rate_in=20, U=0.25, D=0.706, F=0.021)
  print("[T3b, E1] Mean population rate of last 1000 ms: %f" % np.mean(rates_1[int(len(rates_1) / 2):]))
  print("[T3b, E2] Mean population rate of last 1000 ms: %f" % np.mean(rates_2[int(len(rates_2) / 2):]))

  plt.plot(times_1, rates_1, color='red', label='$r_{input}$: 10 Hz')
  plt.plot(times_2, rates_2, color='green', label='$r_{input}$: 20 Hz')
  plt.xlabel('$t$ / ms')
  plt.ylabel('population rate in Hz')
  plt.legend(loc='best')
  plt.tight_layout()
  plt.show()

  # Task 3c
  print("========================")
  print("Task 3c")
  print("========================")
  times_1, rates_1 = experiment(trials=10, rate_in=20, U=0.16, D=0.045, F=0.376)
  times_2, rates_2 = experiment(trials=10, rate_in=40, U=0.16, D=0.045, F=0.376)
  print("[T3c, E1] Mean population rate of last 1000 ms: %f" % np.mean(rates_1[int(len(rates_1) / 2):]))
  print("[T3c, E2] Mean population rate of last 1000 ms: %f" % np.mean(rates_2[int(len(rates_2) / 2):]))

  plt.plot(times_1, rates_1, color='red', label='$r_{input}$: 20 Hz')
  plt.plot(times_2, rates_2, color='green', label='$r_{input}$: 40 Hz')
  plt.xlabel('$t$ / ms')
  plt.ylabel('population rate in Hz')
  plt.legend(loc='best')
  plt.tight_layout()
  plt.show()