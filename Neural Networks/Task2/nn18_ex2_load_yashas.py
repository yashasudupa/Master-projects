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
 
import tensorflow as tf
import numpy as np
import numpy.random as rd
import matplotlib.pyplot as plt
if __name__ == '__main__':
    
    X_train, C_train, X_test, C_test = load_isolet()
    size_X_train = np.shape(X_train)
    size_C_train = np.shape(C_train)
    size_X_test = np.shape(X_test)
    size_C_test = np.shape(C_test)    
    
    #Training and Validation set distribution
    X_train_Updated = []
    C_train_Updated = []
    X_Validation = []
    C_Validation = []
    validation_indices = np.random.choice(size_X_train[0], int(size_X_train[0]/2))
    
    for i in range(0,size_X_train[0]): 
        if i in validation_indices:
            X_Validation.append(X_train[i,:])
            C_Validation.append(C_train[i])
        else :
            X_train_Updated.append(X_train[i,:])
            C_train_Updated.append(C_train[i])
    X_Validation = np.asarray(X_Validation)
    C_Validation = np.asarray(C_Validation)
    X_train_Updated = np.asarray(X_train_Updated)
    C_train_Updated = np.asarray(C_train_Updated)
    
    print("Before Normalization - Validation",np.shape(X_Validation))
    #print(np.shape(C_Validation))
    print("Before Normalization - Training",np.shape(X_train_Updated))
    #print(np.shape(C_train_Updated))
    print("Before Normalization - Test",np.shape(X_test))
    
    #Normalization of datasets
    
    Normalized_X_train_Updated = []
    Normalized_X_Validation = []
    Normalized_X_Test = []
    
    for i in range(0,np.shape(X_train_Updated)[0]):
        for j in range(0,np.shape(X_train_Updated)[1]):
            Normalized_X_train_Updated.append((X_train_Updated[i][j] - np.mean(X_train_Updated[i,:]))/np.std(X_train_Updated[i,:]))
            
    for i in range(0,np.shape(X_Validation)[0]):
        for j in range(0,np.shape(X_Validation)[1]):
            Normalized_X_Validation.append((X_Validation[i][j] - np.mean(X_Validation[i,:]))/np.std(X_Validation[i,:]))
      
    for i in range(0,np.shape(X_test)[0]):
        for j in range(0,np.shape(X_test)[1]):    
            Normalized_X_Test.append((X_test[i][j] - np.mean(X_test[i,:]))/np.std(X_test[i,:]))
            
    Normalized_X_train_Updated = np.asarray(np.reshape(Normalized_X_train_Updated,((np.shape(X_train_Updated)[0]),np.shape(X_train_Updated)[1])))
    Normalized_X_Validation = np.asarray(np.reshape(X_Validation,((np.shape(X_Validation)[0]),np.shape(X_Validation)[1])))
    Normalized_X_Test = np.asarray(np.reshape(X_test,((np.shape(X_test)[0]),np.shape(X_test)[1]))) 
    
    print("After Normalization - Validation",np.shape(Normalized_X_Validation))
    #print(np.shape(C_Validation))
    print("After Normalization - Training",np.shape(Normalized_X_train_Updated))
    #print(np.shape(C_train_Updated))
    print("After Normalization - Test",np.shape(Normalized_X_Test))
    
    #Dimensions of the datasets
    N_train = np.shape(Normalized_X_train_Updated)[1]
    N_Validation = np.shape(Normalized_X_Validation)[1]
    N_test = np.shape(Normalized_X_Test)[1]
    
    #Set the Variables
    W_hid_train = tf.Variable(tf.zeros(N_train,)) 
    
    
    
    
    