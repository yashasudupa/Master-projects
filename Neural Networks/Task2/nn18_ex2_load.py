import numpy as np
import tensorflow as tf
import numpy.random as rd
import matplotlib.pyplot as plt

def load_isolet():
  # Loads the isolet dataset
  # Returns:
  # X....feature vectors (training set), X[i,:] is the i-th example
  # C....target classes
  # X_tst...feature vectors (test set)
  # C_tst...classes (test set)
  
  import pickle as pckl  # to load dataset
  import pylab as pl     # for graphics
  #from numpy import *    

  pl.close('all')   # closes all previous figures

  # Load dataset
  file_in = open('isolet_crop_train.pkl','rb')
  isolet_data = pckl.load(file_in) # Python 3
  #isolet_data = pckl.load(file_in, encoding='bytes') # Python 3
  file_in.close()
  X = isolet_data[0]   # input vectors X[i,:] is i-th example
  C = isolet_data[1]   # classes C[i] is class of i-th example

  file_in = open('isolet_crop_test.pkl','rb')
  isolet_test = pckl.load(file_in) # Python 3
  file_in.close()

  X_tst = isolet_test[0]   # input vectors X[i,:] is i-th example
  C_tst = isolet_test[1]   # classes C[i] is class of i-th example

  return (X, C, X_tst, C_tst)
    
#Normalize the data
def normalize_data(data_main):
    
    mean = np.mean(data_main, axis=0, keepdims=True)
    std = np.std(data_main, axis=0, keepdims=True)
    return (data_main - mean)/std
    
X, C, X_tst, C_tst =  load_isolet()


train_x = normalize_data(X)
test_C = normalize_data(X_tst)
size = np.shape(train_x)

n_in = 300
n_out = 26
n_hidden1 = 60
n_hidden2 = 20
#n_hidden3 = 10

layer_spec = [200]
W_hid = []
b_hid = []
n_hid_input = n_in
for n_hid in layer_spec:
    W_hid.append(tf.Variable(rd.randn(n_hid_input, n_hid) / np.sqrt(n_hid_input),trainable=True, dtype=tf.float32))
    b_hid.append(tf.Variable (np.zeros(n_hid),trainable=True, dtype=tf.float32))
    n_hid_input = n_hid

# Set the variables
w_out = tf.Variable(rd.randn(n_hid,n_out) / np.sqrt(n_hid),trainable=True, dtype=tf.float32)
b_out = tf.Variable(np.zeros(n_out), dtype=tf.float32)

"""
w_out = tf.Variable(rd.randn(n_in,n_out) / np.sqrt(n_in),trainable=True, dtype=tf.float32)
b_out = tf.Variable(np.zeros(n_out), dtype=tf.float32)
"""
# Define the neuron operations
x = tf.placeholder(shape=(None,n_in),dtype=tf.float32)

layer_inp = x
for whid, bhid in zip(W_hid, b_hid):
    y = tf.nn.relu(tf.matmul(layer_inp, whid) + bhid)
    layer_inp = y

#y = tf.nn.tanh(tf.matmul(y,W_hid_3) + b_hid_3)

z = tf.nn.softmax(tf.matmul(y,w_out) + b_out)
#z = tf.matmul(layer_inp, w_out) + b_out



z_index = tf.placeholder(shape=(None,),dtype=tf.int64)
z_ = tf.one_hot(z_index, n_out, dtype=tf.float32)
#cross_entropy = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(labels=z_, logits=z))
cross_entropy = tf.reduce_mean(-tf.reduce_sum(z_ * tf.log(z), reduction_indices=[1]))

#train_step = tf.train.GradientDescentOptimizer(1.0e-3).minimize(cross_entropy)
train_step = tf.train.AdamOptimizer(1.0e-4).minimize(cross_entropy)
correct_prediction = tf.equal(tf.argmax(z,1), tf.argmax(z_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

misclassification_rate = (1 - tf.reduce_mean(tf.cast(correct_prediction, tf.float32)))

init = tf.global_variables_initializer() # Create an op that will
sess = tf.Session()

#Init
sess.run(init)

# Create some list to monitor how error decreases
test_loss_list = []
train_loss_list = []
val_loss_list = []

test_acc_list = []
train_acc_list = []
val_acc_list = []

mis_train = []
mis_test = []
mis_val = []

indices_x = np.random.permutation(size[0])
train_data = train_x[indices_x]
target = C[indices_x]

#Uncomment to include validation set
"""
value = (75 * size[0])/100

train_x = train_data[0: round(value)]
C = target[0: round(value)]

validation_x = train_data[round(value): size[0]]
C_validation = target[round(value): size[0]]
"""


# Create minibtaches to train faster

batch_size = 40
k_batch = (train_x.shape[0] + batch_size - 1) // batch_size
X_batch_list = np.array_split(train_x,k_batch)
labels_batch_list = np.array_split(C,k_batch)

#Uncomment to include validation set
"""
validataion_batch_list = np.array_split(validation_x, k_batch)
validation_labels_batch_list = np.array_split(C_validation,k_batch)
"""

for k in range(34):
    # Run gradient steps over each minibatch
    for x_minibatch,labels_minibatch in zip(X_batch_list,labels_batch_list):
        sess.run(train_step, feed_dict={x: x_minibatch, z_index:labels_minibatch})
        
   
    # Compute the errors over the whole dataset
    train_loss = sess.run(cross_entropy, feed_dict={x:train_x, z_index:C})
    test_loss = sess.run(cross_entropy, feed_dict={x:test_C, z_index:C_tst})
    
    #Uncomment to include validation set
    #val_loss = sess.run(cross_entropy, feed_dict={x:validation_x, z_index:C_validation})
    
    weights = sess.run(W_hid)

    # Compute the acc over the whole dataset
    train_acc = sess.run(accuracy, feed_dict={x:train_x, z_index:C})
    test_acc = sess.run(accuracy, feed_dict={x:test_C, z_index:C_tst})
   
    #Uncomment to include validation set
    #val_acc = sess.run(accuracy, feed_dict={x:validation_x, z_index:C_validation})
    
    train_miss_rate = sess.run(misclassification_rate, feed_dict={x:train_x, z_index:C})
    test_miss_rate = sess.run(misclassification_rate, feed_dict={x:test_C, z_index:C_tst})
    
    #Uncomment to include validation set
    #val_miss_rate = sess.run(misclassification_rate, feed_dict={x:validation_x, z_index:C_validation})

    
    # Put it into the lists
    test_loss_list.append(test_loss)
    train_loss_list.append(train_loss)
    
    #Uncomment to include validation set
    #val_loss_list.append(val_loss)
    
    test_acc_list.append(test_acc)
    train_acc_list.append(train_acc)
    
    #Uncomment to include validation set
    #val_acc_list.append(val_acc)
    
    mis_train.append(train_miss_rate)
    mis_test.append(test_miss_rate)
    
    #Uncomment to include validation set
    #mis_val.append(val_miss_rate)
    
    #shuffle Data
    
    #Uncomment to include validation set
    #indices_x = np.random.permutation(round(value))
    
    #comment to include validation set
    indices_x = np.random.permutation(size[0])
    train_x = train_x[indices_x]
    C = C[indices_x]
    
    X_batch_list = np.array_split(train_x,k_batch)
    labels_batch_list = np.array_split(C,k_batch)

    if np.mod(k,1) == 0:
        print('iteration {} test accuracy: {:.3f}'.format(k+1,test_acc))
        print('iteration {} train loss: {:.3f}'.format(k+1,train_loss))
    
    #Uncomment to include Early stopping
    """
    #Early Stopping    
    if(k > 1):
        if val_loss_list[k] > val_loss_list[k-1]:
            print("Stopping Criterion is", k)
            print("Validation error ", val_acc_list[k])
            break
    """
fig,ax_list = plt.subplots(1,2)
ax_list[0].plot(train_loss_list, color='blue', label='training', lw=2)
ax_list[0].plot(test_loss_list, color='green', label='testing', lw=2)
ax_list[0].plot(val_loss_list, color='red', label='validation', lw=2)

#Uncomment to Plot accuracy
"""
ax_list[1].plot(train_acc_list, color='blue', label='training', lw=2)
ax_list[1].plot(test_acc_list, color='green', label='testing', lw=2)
ax_list[1].plot(val_acc_list, color='red', label='validation', lw=2)
"""

ax_list[1].plot(mis_train, color='blue', label='training', lw=2)
ax_list[1].plot(mis_test, color='green', label='testing', lw=2)

#Uncomment to include validation set
#ax_list[1].plot(mis_val, color='red', label='validation', lw=2)


ax_list[0].set_xlabel('training iterations')
ax_list[1].set_xlabel('training iterations')

ax_list[0].set_ylabel('Cross-entropy')
ax_list[1].set_ylabel('Misclassification rate')
plt.legend(loc=2)


