#!/usr/bin/env python3

import matplotlib.pyplot as plt
import nest
import numpy as np
import pickle as pkl

with open('measurement_data.pkl', 'rb') as f:
  t_, I_, V_, t_spike_ = pkl.load(f)


# ----------------------------------------------------------------------
# discard values following spikes

# ...

mask = np.ones_like(t_).astype(np.bool)
for spike in t_spike_:
  spike_timestamp = int(spike.round(decimals=0))
  interval = int(spike) + 5
  for i in range(spike_timestamp, interval + 1):
    mask[i] = False

t_ = t_[np.array(mask)]
I_ = I_[np.array(mask)]
V_ = V_[np.array(mask)]

dV = [V_[i + 1] - V_[i] for i in range(0, len(V_) - 1)]
dV_tmp, I_tmp, V_tmp, t_tmp = [], [], [], []

for i in range(0, len(dV)):
  if dV[i] >= -30:
    dV_tmp.append(dV[i])
    I_tmp.append(I_[i])
    V_tmp.append(V_[i])
    t_tmp.append(t_[i])

dV = dV_tmp
I_ = I_tmp
V_ = V_tmp
t_ = t_tmp

t_ = [int(e.round(decimals=0)) for e in t_]

F_time_dep = [dV[i] + (- 1.0 / 920) * I_[i] for i in range(0, len(dV))]

# ----------------------------------------------------------------------
# I-V curve

# ...

F_ = np.array(F_time_dep)
V_ = np.array(V_)

# ----------------------------------------------------------------------
# scatter values

plt.figure(figsize=(6., 4.))
plt.title(r'$\hat{F}(V, t)$')
plt.scatter(V_, F_)
plt.xlabel(r'$V$')
plt.ylabel(r'$F(V,t)$')
plt.xlim(-80., -25.)
plt.grid()
plt.locator_params(nbins=4)
plt.tight_layout()
#plt.show()

# ----------------------------------------------------------------------
# mean of I-V curve

# ...
V_tmp, F_tmp = [], []
for i in range(0, len(V_)):
  if -80 <= V_[i] <= -25:
    V_tmp.append(V_[i])
    F_tmp.append(F_[i])

V_ = np.array(V_tmp)
F_ = np.array(F_tmp)
V_bin_ = np.linspace(-80, -25, 56)

digitized = np.digitize(V_, V_bin_)
F_mean_ = [F_[digitized == i].mean() for i in range(1, len(V_bin_))]

plt.plot(V_bin_[1:], F_mean_, lw=2, c='C1', label='mean')

eq_points = np.where(np.abs(F_mean_) < 1e-1)[0]
eq_points_values = [F_mean_[b] for b in eq_points]
print("Points < 1e-1 Indices: %s " % str(eq_points))
print("Points < 1e-1 Values: %s " % str(eq_points_values))
print("V_bin_[16], V_bin_[48]: %f, %f" % (V_bin_[16], V_bin_[48]))

plt.plot(V_bin_[16], 0, marker='o', ls='', label='stable point', c='k')
plt.plot(V_bin_[48], 0, marker='o', ls='', label='unstable point', markeredgecolor='k', markerfacecolor='None')
plt.legend(loc='best')

plt.show()


# ----------------------------------------------------------------------
# estimate parameters

# ...
E_l = V_bin_[16]
gamma_rh = V_bin_[48]


gLs = []
for i in range(0, len(F_mean_)):
  FV = F_mean_[i]
  V = -80 + i

  if V > -50 and V < -40:
    gL = -(920.0 * FV) / (V + 64)
    gLs.append(gL)
  else:
    pass

print("g_L: %f" % np.mean(gLs))

# ----------------------------------------------------------------------
# create model and run

nest.ResetKernel()
params = {"C_m": 920.0,
          "t_ref": 2.0,
          "V_reset": -80.0,
          "E_L": -71.0,
          "g_L": 37.0,  #np.mean(gLs),
          "a": 0.0,
          "b": 0.0,
          "Delta_T": 5.0
          }
neuron = nest.Create('aeif_cond_exp', params=params)
dc_generator = nest.Create('step_current_generator', params={'amplitude_times': np.array(t_).astype(float),
                                                             'amplitude_values': I_})
nest.Connect(dc_generator, neuron)
voltmeter = nest.Create('voltmeter')
nest.Connect(voltmeter, neuron)
spike_detector = nest.Create('spike_detector')
nest.Connect(neuron, spike_detector)
nest.Simulate(500)

voltmeter_events = nest.GetStatus(voltmeter, 'events')[0]
voltmeter_times, voltmeter_values = voltmeter_events['times'], voltmeter_events['V_m']

spike_events = nest.GetStatus(spike_detector, 'events')[0]
spike_times = spike_events['times']


# ----------------------------------------------------------------------
# plot comparison


plt.rc('font', size=20)
plt.figure(figsize=(12., 6.))
plt.subplot(2, 1, 1)
plt.plot(voltmeter_times, voltmeter_values, lw=2, label='$V_m$')
plt.plot(voltmeter_times, V_[0:499], lw=2, label='$V\_$')
for k, t in enumerate(spike_times):
    l = 'spikes'if k == 0 else None
    plt.axvline(x=t, lw=2, c='C3', label=l)
plt.axhline(y=nest.GetStatus(neuron, 'V_th')[0], lw=2, c='C2', ls='--', label="$V_\mathrm{th}$")
plt.xlabel('$t$ / ms')
plt.ylabel('$V_m$ / mV')
plt.legend(loc='right')
plt.tight_layout()

curr_ = np.zeros(voltmeter_times.shape)
at_ = nest.GetStatus(dc_generator, 'amplitude_times')[0]
av_ = nest.GetStatus(dc_generator, 'amplitude_values')[0]
for at, av in zip(at_, av_):
    curr_[voltmeter_times >= at] = av

plt.subplot(2, 1, 2, sharex=plt.gca())
plt.plot(voltmeter_times, curr_, c='C1', lw=2)
plt.xlabel('$t$ / ms')
plt.ylabel('$I$ / pA')
plt.tight_layout()

plt.show()


