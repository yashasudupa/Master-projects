#!/usr/bin/env python3
import sys
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
import nest
import numpy as np

print('\n'.join(sys.path))

nest.ResetKernel()

# create a neuron with the given parameters
params = {'C_m': 1000.0,
          'E_L': -65.0,
          'V_reset': -80.0,
          'V_th': -45.0,
          't_ref': 5.0,
          'tau_m': 0.03*1000}

neuron = nest.Create('iaf_psc_delta', params=params)

# inject a current with the given amplitude
dc_generator = nest.Create('dc_generator', params={'amplitude': 3000.0})
nest.Connect(dc_generator, neuron)

# inject a current with the given parameters
noise_generator = nest.Create('noise_generator', params={'mean': 0.0, 'std': 1000.0})
nest.Connect(noise_generator, neuron)

# record spikes from the neuron
spike_detector = nest.Create('spike_detector')
nest.Connect(neuron, spike_detector)

# simulate
nest.Simulate(20000)

# extract the spike times, calculate the interspike intervals
spike_events = nest.GetStatus(spike_detector, 'events')[0]
spike_times = spike_events['times']

spike_times_diffs = np.ediff1d(spike_times)
mean_interspike_interval = np.mean(spike_times_diffs)
print(len(spike_times_diffs))

# calculate the predicted interspike interval
predicted_interspike_interval = 5 - 0.03 * 1000 * np.log((0.03 * 3000) / (0.03 * 3000 + 45))

print('interspike interval:')
print('  prediction: {0:.3f}'.format(predicted_interspike_interval))
print('  mean from simulation: {0:.3f}'.format(mean_interspike_interval))


# plot a histogram of the interspike intervals
# don't forget to label your axes, etc.

n, bins, patches = plt.hist(spike_times_diffs, bins=25, normed=True, facecolor='green', alpha=0.75,
                            edgecolor='black', linewidth=0.5, label='interspike intervals')
plt.xlabel("interspike inverval [ms]")
plt.ylabel("# observations [percentage]")
plt.title("interspike interval histogram")
gaussian = mlab.normpdf(bins, mean_interspike_interval, np.std(spike_times_diffs))
plt.plot(bins, gaussian, 'darkgreen', linestyle='-.', linewidth=1.5, label='fitted normal distribution')
plt.axvline(predicted_interspike_interval, color='firebrick', linestyle='dotted', linewidth=1.5, label='expected interspike interval')
plt.axvline(mean_interspike_interval.mean(), color='red', linestyle='dashed', linewidth=1.5, label='observed interspike interval')

plt.legend(loc='best')
plt.tight_layout()
plt.show()