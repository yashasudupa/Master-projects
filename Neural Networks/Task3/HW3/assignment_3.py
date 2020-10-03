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

#1...One hot encoding
n_samples,n_inputs = np.shape(X_train)
y_train = y_train.reshape((n_samples,1))
onehot_encoder = OneHotEncoder(sparse=False)
y_coded = onehot_encoder.fit_transform(y_train)


# ...

#print(X_train.mean(axis=0))
#print(X_train.var(axis=0))


#2...split the training data sets into test, validation and early stopping set etc...
xtrain, xval_earl, ytrain, yval_earl = train_test_split(X_train, y_coded, test_size=0.3) 
xtest,xval,ytest,yval = train_test_split(xval_earl, yval_earl, test_size=0.5)




# ...

#Applying transformation
scaler = StandardScaler()
xtrain = scaler.fit_transform(xtrain)
xval = scaler.transform(xval) 


#print(xtrain.mean(axis=0))
#print(xtrain.var(axis=0))




#2.....Best algorithm
n_classes = y_coded.shape[1]
W = tf.Variable(np.random.randn(n_inputs,n_classes), trainable=True)
b = tf.Variable(np.random.randn(n_classes), trainable=True)
x = tf.placeholder(shape=(None,n_inputs), dtype=tf.float64)
y = tf.nn.softmax(tf.matmul(x, W) + b)
y_true = tf.placeholder(shape=(None,n_classes),dtype=tf.float64)
y_clipped = tf.clip_by_value(y, 1e-10, 0.9999999)
cross_entropy = tf.reduce_mean(-tf.reduce_sum(y_true * tf.log(y_clipped), reduction_indices=[1]))

#2.....Selecting among various optimizer
train_step = tf.train.GradientDescentOptimizer(0.5).minimize(cross_entropy)
#train_step = tf.train.RMSPropOptimizer(0.5).minimize(cross_entropy)
#train_step = tf.train.AdamOptimizer(0.5).minimize(cross_entropy)

init = tf.global_variables_initializer() 
sess = tf.Session()
sess.run(init)

train_error_list_grad = []
test_error_list_grad = []
ear_stop_list_grad = []

#2.....Create minibatches to train faster
k_batch = 40
X_batch_list = np.array_split(xtrain, k_batch)
labels_batch_list = np.array_split(ytrain, k_batch)


for i in range(500):
    for x_minibatch, labels_minibatch in zip(X_batch_list, labels_batch_list):
        sess.run(train_step, feed_dict={x: x_minibatch, y_true: labels_minibatch})
    
    train_err_grad = sess.run(cross_entropy, feed_dict={x: xtrain, y_true: ytrain})
    error_earl_grad = sess.run(cross_entropy, feed_dict={x: xval, y_true: yval})
    ear_stop_list_grad.append(error_earl_grad)
    #print(ear_stop_list_grad)
    if ear_stop_list_grad[i] > ear_stop_list_grad[i-1]:
        break
    train_error_list_grad.append(train_err_grad) 
print("Stopped at:", i)    

## 3......Finding best activation function     
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
learning_rate = 0.001

weights = {
    
    'hidden': tf.Variable(np.random.randn(input_num_units, hidden_num_units), trainable = True),
    'output': tf.Variable(np.random.randn(hidden_num_units, output_num_units), trainable = True)
}

biases = {
    
    'hidden': tf.Variable(np.zeros(hidden_num_units), trainable = True),
    'output': tf.Variable(np.zeros(output_num_units), trainable = True)
}    
    
#3.....selection among different hidden layer activation functions
hidden_layer = tf.add(tf.matmul(x, weights['hidden']), biases['hidden'])
#hidden_layer = tf.nn.relu(hidden_layer)
hidden_layer = tf.nn.tanh(hidden_layer)
#hidden_layer = tf.nn.sigmoid(hidden_layer)
#output_layer =  tf.nn.softmax(tf.matmul(hidden_layer, weights['output']) + biases['output'])

#4......different network sizes (defined until 3 NN layers with varying hidden units).

def nn_layers(n_layers, n_hiddenunits):
    if n_layers == 1:
        weights_1 = {'hidden': tf.Variable(np.random.randn(input_num_units, n_hiddenunits), trainable = True),
                     'output': tf.Variable(np.random.randn(n_hiddenunits, output_num_units), trainable = True)}
        biases_1 = {'hidden': tf.Variable(np.zeros(n_hiddenunits), trainable = True),
                    'output': tf.Variable(np.zeros(output_num_units), trainable = True)} 
        hidden_1 = tf.add(tf.matmul(x, weights_1['hidden']), biases_1['hidden'])
        #hidden_1 = tf.nn.relu(hidden_1)
        #hidden_1 = tf.nn.tanh(hidden_1)
        hidden_1 = tf.nn.sigmoid(hidden_1)
        y =  tf.nn.softmax(tf.matmul(hidden_1, weights_1['output']) + biases_1['output'])
    elif n_layers == 2:
        weights_2 = {'hidden_1': tf.Variable(np.random.randn(input_num_units, n_hiddenunits), trainable = True),
                     'hidden_2': tf.Variable(np.random.randn(n_hiddenunits, n_hiddenunits), trainable = True),
                     'output': tf.Variable(np.random.randn(n_hiddenunits, output_num_units), trainable = True)}
        biases_2 = {'hidden_1': tf.Variable(np.zeros(n_hiddenunits), trainable = True),
                    'hidden_2': tf.Variable(np.zeros(n_hiddenunits), trainable = True),
                    'output': tf.Variable(np.zeros(output_num_units), trainable = True)} 
        hidden_1 = tf.add(tf.matmul(x, weights_2['hidden_1']), biases_2['hidden_1'])
        hidden_1 = tf.nn.sigmoid(hidden_1)
        #hidden_1 = tf.nn.relu(hidden_1)
        #hidden_1 = tf.nn.tanh(hidden_1)
        hidden_2 = tf.add(tf.matmul(hidden_1, weights_2['hidden_2']), biases_2['hidden_2'])
        hidden_2 = tf.nn.sigmoid(hidden_2)
        #hidden_2 = tf.nn.relu(hidden_2)
        #hidden_2 = tf.nn.tanh(hidden_2)
        y =  tf.nn.softmax(tf.matmul(hidden_2, weights_2['output']) + biases_2['output'])
    elif n_layers == 3:
        weights_3 = {'hidden_1': tf.Variable(np.random.randn(input_num_units, n_hiddenunits), trainable = True),
                     'hidden_2': tf.Variable(np.random.randn(n_hiddenunits, n_hiddenunits), trainable = True),
                     'hidden_3': tf.Variable(np.random.randn(n_hiddenunits, n_hiddenunits), trainable = True),
                     'output': tf.Variable(np.random.randn(n_hiddenunits, output_num_units), trainable = True)}
        biases_3 = {'hidden_1': tf.Variable(np.zeros(n_hiddenunits), trainable = True),
                    'hidden_2': tf.Variable(np.zeros(n_hiddenunits), trainable = True),
                    'hidden_3': tf.Variable(np.zeros(n_hiddenunits), trainable = True),
                    'output': tf.Variable(np.zeros(output_num_units), trainable = True)} 
        hidden_1 = tf.add(tf.matmul(x, weights_3['hidden_1']), biases_3['hidden_1'])
        hidden_1 = tf.nn.sigmoid(hidden_1)
        #hidden_1 = tf.nn.relu(hidden_1)
        #hidden_1 = tf.nn.tanh(hidden_1)
        hidden_2 = tf.add(tf.matmul(hidden_1, weights_3['hidden_2']), biases_3['hidden_2'])
        hidden_2 = tf.nn.sigmoid(hidden_2)
        #hidden_2 = tf.nn.relu(hidden_2)
        #hidden_2 = tf.nn.tanh(hidden_2)
        hidden_3 = tf.add(tf.matmul(hidden_2, weights_3['hidden_2']), biases_3['hidden_2'])
        hidden_3 = tf.nn.sigmoid(hidden_3)
        #hidden_3 = tf.nn.relu(hidden_3)
        #hidden_3 = tf.nn.tanh(hidden_3)
        y =  tf.nn.softmax(tf.matmul(hidden_3, weights_3['output']) + biases_3['output'])
    return y 

#4....function call to select no. hidden units and no. hidden layers.
output_layer = nn_layers(1,10)
        
ce = tf.nn.softmax_cross_entropy_with_logits(labels = y_true, logits = output_layer)
cost = tf.reduce_mean(ce)
correct = tf.equal(tf.argmax(output_layer,1), tf.argmax(y_true,1))
misclassification = (1 - tf.reduce_mean(tf.cast(correct, tf.float32)))*100

#3 and 4.....selection among different optimizer.

#optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate).minimize(cost)
#optimizer = tf.train.GradientDescentOptimizer(learning_rate=learning_rate).minimize(cost)
optimizer = tf.train.RMSPropOptimizer(learning_rate=learning_rate).minimize(cost)

init = tf.global_variables_initializer() 
sess = tf.Session()
sess.run(init)

train_error_list = []
test_error_list = []
ear_stop_list = []
estop_mcr_list = []
train_mcr_list = []

X_batch_list = np.array_split(xtrain, batch_size)
labels_batch_list = np.array_split(ytrain, batch_size)

for i in range(500):
    for x_minibatch, labels_minibatch in zip(X_batch_list, labels_batch_list):
        sess.run(optimizer, feed_dict={x: x_minibatch, y_true: labels_minibatch})
    
    train_err = sess.run(cost, feed_dict={x: xtrain, y_true: ytrain})
    error_earl = sess.run(cost, feed_dict={x: xval, y_true: yval})
    ear_stop_list.append(error_earl)
    train_mcr = sess.run(misclassification, feed_dict={x: xtrain, y_true: ytrain})
    estop_mcr = sess.run(misclassification, feed_dict={x: xval, y_true: yval}) 
    train_error_list.append(train_err)
    train_mcr_list.append(train_mcr)
    estop_mcr_list.append(estop_mcr)
    if ear_stop_list[i] > ear_stop_list[i-1]:
        break
print("Stopped at:", i)

sess.close()

fig,ax_list = plt.subplots(1,2)
ax_list[0].plot(train_error_list, color='blue', label='training', lw=2)
ax_list[0].plot(ear_stop_list, color='green', label='test', lw=2)
ax_list[1].plot(train_mcr_list, color='blue', label='training', lw=2)
ax_list[1].plot(estop_mcr_list, color='green', label='test', lw=2)

ax_list[0].set_title('Cross-entropy')
ax_list[0].set_xlabel('Training epoch')
ax_list[0].set_ylabel('Cross-entropy')
ax_list[1].set_title('Misclassification Rate (%)')
ax_list[1].set_xlabel('Training epoch')
ax_list[1].set_ylabel('Misclassification Rate (%)')
ax_list[0].legend(loc='best')
ax_list[1].legend(loc='best')
plt.show()
