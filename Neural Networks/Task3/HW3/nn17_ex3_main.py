#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import pickle as pkl
import tensorflow as tf
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.cross_validation import train_test_split

# plt.close('all')  # if you like


# load dataset

with open('isolet_crop_train.pkl', 'rb') as f:
    train_data = pkl.load(f)

with open('isolet_crop_test.pkl', 'rb') as f:
    test_data = pkl.load(f)

X_train, y_train = train_data
X_test, y_test = test_data

#One hot encoding
n_samples,n_inputs = np.shape(X_train)
y_train = y_train.reshape((n_samples,1))
onehot_encoder = OneHotEncoder(sparse=False)
y_coded = onehot_encoder.fit_transform(y_train)

# normalize the data and check the results
#X_train_norm = (X_train - X_train.mean(axis = 0))/X_train.var(axis = 0)
scaler = StandardScaler()
X_train = scaler.fit_transform(X_train)
X_test = scaler.fit_transform(X_test)

# ...

print(X_train.mean(axis=0))
print(X_train.var(axis=0))


# split the data sets, etc.
X_train_sub, X_val_earl, y_train_sub, y_val_earl = train_test_split(X_train, y_coded, test_size=0.3) 
print(np.shape(X_train_sub))
print(np.shape(X_val_earl))

X_val,X_earl,y_val,y_earl = train_test_split(X_val_earl, y_val_earl, test_size=0.5)
print(np.shape(X_val))
print(np.shape(X_earl))
# ...

#Best algorithm
n_classes = y_coded.shape[1]
W = tf.Variable(np.random.randn(n_inputs,n_classes), trainable=True)
b = tf.Variable(np.random.randn(n_classes), trainable=True)
x = tf.placeholder(shape=(None,n_inputs), dtype=tf.float64)
y = tf.nn.softmax(tf.matmul(x, W) + b)
y_true = tf.placeholder(shape=(None,n_classes),dtype=tf.float64)
y_clipped = tf.clip_by_value(y, 1e-10, 0.9999999)
cross_entropy = tf.reduce_mean(-tf.reduce_sum(y_true * tf.log(y_clipped), reduction_indices=[1]))


train_step_grad = tf.train.GradientDescentOptimizer(0.5).minimize(cross_entropy)
train_step_rms = tf.train.RMSPropOptimizer(0.5).minimize(cross_entropy)
train_step_adam = tf.train.AdamOptimizer(0.5).minimize(cross_entropy)

init = tf.global_variables_initializer() 
sess = tf.Session()
sess.run(init)

train_error_list_grad = []
test_error_list_grad = []
ear_stop_list_grad = []

train_error_list_rms = []
test_error_list_rms = []
ear_stop_list_rms = []

train_error_list_adam = []
test_error_list_adam = []
ear_stop_list_adam = []


#Create minibatches to train faster
k_batch = 40
X_batch_list = np.array_split(X_train_sub, k_batch)
labels_batch_list = np.array_split(y_train_sub, k_batch)


for i in range(20):
    for x_minibatch, labels_minibatch in zip(X_batch_list, labels_batch_list):
        sess.run(train_step_grad, feed_dict={x: x_minibatch, y_true: labels_minibatch})
    
    train_err_grad = sess.run(cross_entropy, feed_dict={x: X_train_sub, y_true: y_train_sub})
    test_err_grad = sess.run(cross_entropy, feed_dict={x: X_val, y_true: y_val})
    error_earl_grad = sess.run(cross_entropy, feed_dict={x: X_earl, y_true: y_earl})
    ear_stop_list_grad.append(error_earl_grad)
    if ear_stop_list_grad[i] > ear_stop_list_grad[i-1]:
        break
    test_error_list_grad.append(test_err_grad)
    train_error_list_grad.append(train_err_grad) 
    
for j in range(20):
    for x_minibatch, labels_minibatch in zip(X_batch_list, labels_batch_list):
        sess.run(train_step_rms, feed_dict={x: x_minibatch, y_true: labels_minibatch})
    
    train_err_rms = sess.run(cross_entropy, feed_dict={x: X_train_sub, y_true: y_train_sub})
    test_err_rms = sess.run(cross_entropy, feed_dict={x: X_val, y_true: y_val})
    error_earl_rms = sess.run(cross_entropy, feed_dict={x: X_earl, y_true: y_earl})
    ear_stop_list_rms.append(error_earl_rms)
    if ear_stop_list_rms[j] > ear_stop_list_rms[j-1]:
        break
    test_error_list_rms.append(test_err_rms)
    train_error_list_rms.append(train_err_rms)
    
for k in range(20):
    for x_minibatch, labels_minibatch in zip(X_batch_list, labels_batch_list):
        sess.run(train_step_adam, feed_dict={x: x_minibatch, y_true: labels_minibatch})
    
    train_err_adam = sess.run(cross_entropy, feed_dict={x: X_train_sub, y_true: y_train_sub})
    test_err_adam = sess.run(cross_entropy, feed_dict={x: X_val, y_true: y_val})
    error_earl_adam = sess.run(cross_entropy, feed_dict={x: X_earl, y_true: y_earl})
    ear_stop_list_adam.append(error_earl_adam)
    if ear_stop_list_adam[k] > ear_stop_list_adam[k-1]:
        break
    test_error_list_adam.append(test_err_adam)
    train_error_list_adam.append(train_err_adam)  
    
    
## Finding best activation function     
# number of neurons in each layer
input_num_units = n_inputs
hidden_num_units = 20
output_num_units = n_classes



# define placeholders
x = tf.placeholder(tf.float64, [None, input_num_units])
y = tf.placeholder(tf.float64, [None, output_num_units])

# set remaining variables
epochs = 5
batch_size = 40
learning_rate = 0.01

### define weights and biases of the neural network (refer this article if you don't understand the terminologies)


weights = {
    
    'hidden': tf.Variable(np.random.randn(input_num_units, hidden_num_units), trainable = True),
    'output': tf.Variable(np.random.randn(hidden_num_units, output_num_units), trainable = True)
}

biases = {
    
    'hidden': tf.Variable(np.random.randn(hidden_num_units), trainable = True),
    'output': tf.Variable(np.random.randn(output_num_units), trainable = True)
}    
    

hidden_layer = tf.add(tf.matmul(x, weights['hidden']), biases['hidden'])
hidden_layer = tf.nn.relu(hidden_layer)

output_layer =  tf.nn.softmax(tf.matmul(hidden_layer, weights['output']) + biases['output'])

output_clipped = tf.clip_by_value(output_layer, 1e-10, 0.9999999)
cost = tf.reduce_mean(-tf.reduce_sum(y_true * tf.log(output_clipped), reduction_indices=[1]))
#cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(output_layer, y))

optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost)

init = tf.global_variables_initializer() 
sess = tf.Session()
sess.run(init)

train_error_list_relu = []
test_error_list_relu = []
ear_stop_list_relu = []

X_batch_list = np.array_split(X_train_sub, batch_size)
labels_batch_list = np.array_split(y_train_sub, batch_size)

for i in range(20):
    for x_minibatch, labels_minibatch in zip(X_batch_list, labels_batch_list):
        sess.run(optimizer, feed_dict={x: x_minibatch, y_true: labels_minibatch})
    
    train_err_relu = sess.run(cost, feed_dict={x: X_train_sub, y_true: y_train_sub})
    test_err_relu = sess.run(cost, feed_dict={x: X_val, y_true: y_val})
    error_earl_relu = sess.run(cost, feed_dict={x: X_earl, y_true: y_earl})
    ear_stop_list_relu.append(error_earl_relu)
    if ear_stop_list_relu[i] > ear_stop_list_relu[i-1]:
        break
    test_error_list_relu.append(test_err_relu)
    train_error_list_relu.append(train_err_relu)
print("Stopped at:", i)    

#Training for tanh activation function
hidden_layer_tanh = tf.nn.tanh(hidden_layer)


output_layer_tanh =  tf.nn.softmax(tf.matmul(hidden_layer_tanh, weights['output']) + biases['output'])

output_clipped_tanh = tf.clip_by_value(output_layer_tanh, 1e-10, 0.9999999)
cost = tf.reduce_mean(-tf.reduce_sum(y_true * tf.log(output_clipped_tanh), reduction_indices=[1]))


optimizer_tanh = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost)

init = tf.global_variables_initializer() 
sess = tf.Session()
sess.run(init)

train_error_list_tanh = []
test_error_list_tanh = []
ear_stop_list_tanh = []

X_batch_list = np.array_split(X_train_sub, batch_size)
labels_batch_list = np.array_split(y_train_sub, batch_size)

for j in range(20):
    for x_minibatch, labels_minibatch in zip(X_batch_list, labels_batch_list):
        sess.run(optimizer_tanh, feed_dict={x: x_minibatch, y_true: labels_minibatch})
    
    train_err_tanh = sess.run(cost, feed_dict={x: X_train_sub, y_true: y_train_sub})
    test_err_tanh = sess.run(cost, feed_dict={x: X_val, y_true: y_val})
    error_earl_tanh = sess.run(cost, feed_dict={x: X_earl, y_true: y_earl})
    ear_stop_list_tanh.append(error_earl_tanh)
    if ear_stop_list_tanh[j] > ear_stop_list_tanh[j-1]:
        break
    test_error_list_tanh.append(test_err_tanh)
    train_error_list_tanh.append(train_err_tanh)
print("Stopped at:", j)

#Training for sigmoidal activation function
hidden_layer_sig = tf.nn.sigmoid(hidden_layer)


output_layer_sig =  tf.nn.softmax(tf.matmul(hidden_layer_sig, weights['output']) + biases['output'])

output_clipped_sig = tf.clip_by_value(output_layer_sig, 1e-10, 0.9999999)
cost = tf.reduce_mean(-tf.reduce_sum(y_true * tf.log(output_clipped_sig), reduction_indices=[1]))


optimizer_sig = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost)

init = tf.global_variables_initializer() 
sess = tf.Session()
sess.run(init)

train_error_list_sig = []
test_error_list_sig = []
ear_stop_list_sig = []

X_batch_list = np.array_split(X_train_sub, batch_size)
labels_batch_list = np.array_split(y_train_sub, batch_size)

for k in range(20):
    for x_minibatch, labels_minibatch in zip(X_batch_list, labels_batch_list):
        sess.run(optimizer_sig, feed_dict={x: x_minibatch, y_true: labels_minibatch})
    
    train_err_sig = sess.run(cost, feed_dict={x: X_train_sub, y_true: y_train_sub})
    test_err_sig = sess.run(cost, feed_dict={x: X_val, y_true: y_val})
    error_earl_sig = sess.run(cost, feed_dict={x: X_earl, y_true: y_earl})
    ear_stop_list_sig.append(error_earl_tanh)
    if ear_stop_list_sig[k] > ear_stop_list_sig[k-1]:
        break
    test_error_list_sig.append(test_err_sig)
    train_error_list_sig.append(train_err_sig)
print("Stopped at:", k)



    
   