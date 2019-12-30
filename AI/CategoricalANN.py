# -*- coding: utf-8 -*-
"""
Cheryl Ngo
11/17/2019
"""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Import Libraries Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
import matplotlib.pyplot as plt
from keras import models
from keras import layers
from keras.utils import to_categorical
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
import datetime
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Load Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Fix random weights for repeatability
np.random.seed(7)

dataframe=pd.read_csv('C:\\Users\\chery\\Grad School\\BUAD 5802 -AI II\\M3-Intermediate Feed-Forward Neural Networks\\Submission\\winequality-white.csv',delimiter=";")
dataframe=dataframe.replace(np.nan,0)
dataset=dataframe.values

X=dataset[:,0:11]
Y=dataset[:,11]

xTrain, xTest, yTrain, yTest = train_test_split(X, Y, test_size = 0.2, random_state = 0)

#print ("xTrain.shape",xTrain.shape)
#print ("len(yTrain)",len(yTrain))
#print("yTrain_labels",yTrain)

#print ("xTest.shape",xTest.shape)
#print ("len(yTest)",len(yTest))
#print("yTest_labels",yTest)

# Start the timer for run time
start_time = datetime.datetime.now()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Parameters Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
num_nodes_first = 20
num_nodes_second = 20
num_classes = 11
num_epochs = 15
size_batch = 50 #The weights will be updated after ever 50 data points, default is 1 and will take longer to run
verbose_setting=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Not needed? #Reshape to 60000 x 784
#train_images = train_images.reshape((train_quantity, train_x_vars * train_y_image_size))
#test_images = test_images.reshape((test_number_images, test_x_image_size * test_y_image_size))

# Reduce range of data to 0,1
#xTrain = xTrain.astype('float32') / 11
#xTest = xTrain.astype('float32') / 11

# `to_categorical` converts this into a matrix with as many
# columns as there are classes. The number of rows
# stays the same.
yTrain = to_categorical(yTrain,num_classes=11)
yTest = to_categorical(yTest,num_classes=11)

#Encode YCat to represent an ordinal variable
#YCatTrain=[]
#for i in range(len(yTrain)):
#    ext=[]
#    for j in range(11):
#        if len(ext) < yTrain[i]:
#            ext.append(1)
#        else:
#            ext.append(0)
#    YCatTrain.extend([ext])
#YCatTest=[]
#for i in range(len(yTest)):
#    ext=[]
#    for j in range(11):
#        if len(ext) < yTest[i]:
#            ext.append(1)
#        else:
#            ext.append(0)
#    YCatTest.extend([ext])

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Create the feedforward  netowrk
network = models.Sequential()
#Add the first hidden layer specifying the input shape
network.add(layers.Dense(num_nodes_first, activation='relu'))
#Add a second hidden layer
network.add(layers.Dense(num_nodes_second, activation='relu'))
#Add the output layer
network.add(layers.Dense(num_classes, activation='softmax'))
#compile the model
network.compile(optimizer='rmsprop',
                loss='categorical_crossentropy',
                metrics=['accuracy'])

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Fit Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Train the model
network.fit(xTrain, yTrain, epochs = num_epochs, batch_size = size_batch, verbose = verbose_setting)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Show output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#print a summary of the model
network.summary()
#calculate and print the loss statistics
test_loss, test_acc = network.evaluate(xTest, yTest)
print('test_loss:', test_loss)
print('test_acc:', test_acc)

#calculate and print the tome to run
stop_time = datetime.datetime.now()
print ("Time required for training:",stop_time - start_time)





