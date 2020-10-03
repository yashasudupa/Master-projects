
# coding: utf-8

# In[2]:


import matplotlib.pyplot as plt
import numpy as np
import nest
import nest.voltage_trace
import nest.raster_plot
import math


# In[3]:


# create a neuron with the givevn parameters

neuron = nest.Create("iaf_psc_alpha")
nest.SetStatus(neuron, "C_m",1000.0)
nest.SetStatus(neuron, "V_th",-45.0)
nest.SetStatus(neuron, "V_reset",-80.0)
nest.SetStatus(neuron, "E_L", -65.0)
nest.SetStatus(neuron, "t_ref", 5.0)
#nest.GetStatus(neuron)


# In[4]:


#inject a current with the given amplitude

dc_generator = nest.Create("dc_generator")
nest.SetStatus(dc_generator, [{"amplitude": 3000.0}])
nest.Connect(dc_generator,neuron)
#nest.GetStatus(dc_generator)


# In[5]:


#inject a current with the given parameters

noise_generator = nest.Create("noise_generator")
nest.SetStatus(noise_generator, 'mean',0.0)
nest.SetStatus(noise_generator, 'dt',1000.0)
nest.GetStatus(noise_generator)
nest.Connect(noise_generator,neuron)


# In[6]:


#record spikes from the neuron

voltmeter = nest.Create("voltmeter")
nest.SetStatus(voltmeter, {"withtime" :True,"withgid" :True,"record_from" :["V_m"]})
spikedetector = nest.Create("spike_detector", params={"withgid": True, "withtime": True})
nest.Connect(voltmeter, neuron)
nest.Connect(neuron, spikedetector)


# In[7]:


#simulate

nest.Simulate(20000.0)  #Simulate for 200ms to observe spikes more accurately


# In[8]:


dmm = nest.GetStatus(voltmeter)[0]
Vms = dmm["events"]["V_m"]
ts = dmm["events"]["times"]
plt.figure(1)
plt.plot(ts, Vms)
plt.show()


# In[9]:


nest.raster_plot.from_device(spikedetector,hist=True)
plt.title('spike interval')
plt.show()


# In[10]:


spikes = nest.GetStatus(spikedetector,keys="events")[0]
#nest.GetStatus(spikedetector)



# In[11]:


#extract the spike times, calculate the interspike intervals

spike_times = spikes['times']  
print(spike_times)

value = 0
for i in range(0 , len(mean_spike) - 1 ):
    value = value + mean_spike[i+1] - mean_spike[i]
mean_spike_interval = value/(len(mean_spike) - 1)
print(mean_spike_interval)


# In[12]:


#calculate the predicted spike interval

delta_abs = 5
Rm = 0.03
Cm = 1000
I = 3000
Vth = -45

T  =   delta_abs + Rm*Cm*(math.log((Rm*I)/(Rm*I - Vth)) / math.log(2.713))

#Seems to be not correct the math so still TODO

