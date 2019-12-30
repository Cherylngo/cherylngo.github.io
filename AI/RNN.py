"""
Cheryl Ngo

12/1/19
"""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Code Flow
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
'''
The model is trained using a data set of news headlines. First, the data 
is loaded and 10,000 headlines are chosen at random for use in training
the model.  We set the parameters in the following section including
epochs, input sequence length, dense layer quantity, and hidden unit
quantity. Next, the data is tokenized and formatted into groups of 
seq_length units and a categorical response variable is stored.  The 
RNN is created and trained saving checkpoints every 10 epochs and the loss
of the model through the training process is graphed.  Finally, we can 
choose a checkpoint to load weights from, generate a starting seed, and 
output our models prediction for the next word.
'''
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Import Libraries Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
from numpy import array
from keras.preprocessing.text import Tokenizer
from keras.utils import to_categorical
from keras.preprocessing.sequence import pad_sequences
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Embedding

import random as rand
import numpy as np
import pandas as pd
from keras.callbacks import ModelCheckpoint
import datetime
import matplotlib.pyplot as plt
from keras.layers import Dropout
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Variables Used
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
'''
text is used to store the subset of headlines used to train the model
raw_text formats this into one string

start_time and end_time are used to calculate training time for the model

doubleHidden doubles the hidden units in the LSTM layer
halveHidden halves the hidden units in the LSTM layer

doubleSeq doubles the sequence length of the random seed used to generate text
halveSeq havles the sequence length of the random seed used to generate text

addDense adds another dense layer to the model

num_epoch is used to specify the number of epochs for which the model will be trained
batch_sz is used to specify the batch size used when fitting the model

tokenizer is the raw_text without punctuation and tokenized
int_to_word is used to convert the integers feed to the model back to words

vocab_size is the amount of unique words in text
sequences is used to store the data in groups of length seq_length used to predict the next word
X contains the groups used to predict the next work
y contains the actual next words

path is used to specify where the checkpoints will be saved
filepath specifies the name of the checkpoint file

checkpoint and callbacks_list allow the checkpoints to be accesssed later

pattern is the specified group of words used seed the model
seed_text converts pattern from integers to words
    seed_text is also updated at the end of the code to include the word predictions
    
encoded is used to store seed_text converted back into integers and padded
yhat stores the predition of the next word given the encoded sequence

'''
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Objective
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
'''The goal of this program is to create a recurrent neural network that will
generage headlines of four to eight words for articles
'''
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Load Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Import the data
#Fix random weights for repeatability
np.random.seed(7)

#Import the data
dataframe=pd.read_csv('C:\\Users\\chery\\Grad School\\BUAD 5802 -AI II\\M5-Deep Learning for Text and Sequences\\Submission\\abcnews-date-text.csv')
#Keep only the headline column
text=list(dataframe['headline_text'])

#Due to memory error and speed selecting only 10,000 headlines
text=rand.sample(text,25000) 

#Capture the time to allow us to calculate training duration
start_time = datetime.datetime.now()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Parameters Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Use the following true/false variables to vary the model
#Modify the hidden units in the LSTM Layer
doubleHidden=True
halveHidden=False

#Modify the sequence seed length
doubleSeq=False
halveSeq=False

#Modify the number of dense layers
addDense=False

#The following define the modified units
#Set the hidden units in the LSTM layer   
if doubleHidden:
    hidden_units=100
elif halveHidden:
    hidden_units=50
else:
    hidden_units=200
    
#Set the sequence length for seeding
if doubleSeq:
    seq_length=8
elif halveSeq:
    seq_length=2
else:
    seq_length = 4        
    
#Set the number of epochs for training
num_epoch=100
#Set the batch size
batch_sz=128

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Format the imported text as one string
raw_text=''
for i in text:
    #Combine each headline with a space in between
    raw_text+=' '
    #Make all the text lowercase
    raw_text+=i.lower()

#Tokenize
tokenizer=Tokenizer()
tokenizer.fit_on_texts([raw_text])
encoded=tokenizer.texts_to_sequences([raw_text])[0]

#Create a dictionary to convert the values back to words
int_to_word = dict((c, i) for i, c in tokenizer.word_index.items())

# determine the vocabulary size
vocab_size = len(tokenizer.word_index) + 1
print('Vocabulary Size: %d' % vocab_size)

# encode seq_length words -> 1 word
sequences = list()
for i in range(seq_length-1, len(encoded)):
	sequence = encoded[i-seq_length+1:i+1]
	sequences.append(sequence)
print('Total Sequences: %d' % len(sequences))

# pad sequences
max_length = max([len(seq) for seq in sequences])
sequences = pad_sequences(sequences, maxlen=max_length, padding='pre')
print('Max Sequence Length: %d' % max_length)

# split into input and output elements
sequences = array(sequences)
X, y = sequences[:,:-1],sequences[:,-1]
y = to_categorical(y, num_classes=vocab_size)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Define the LSTM model
model = Sequential()
model.add(Embedding(vocab_size, 10, input_length=max_length-1))
model.add(LSTM(hidden_units))

if addDense:
    model.add(Dense(50, activation='relu'))
    model.add(Dropout(0.25))
    model.add(Dense(vocab_size, activation='softmax'))
    
else:
    model.add(Dense(vocab_size, activation='softmax'))
    
model.summary()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Train Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Define the filepath in which to save the checkpoints
path='C:\\Users\\chery\\Grad School\\BUAD 5802 -AI II\\M5-Deep Learning for Text and Sequences\\Submission\\'
#Define the naming schema for the checkpoints
filepath=path+"weights-improvement-{epoch:02d}-{loss:.4f}-dropout.hdf5"

#Save the checkpoints
checkpoint = ModelCheckpoint(filepath, save_weights_only=True, verbose=1, period=20)
callbacks_list = [checkpoint]

# compile network
model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
# fit network
history=model.fit(X, y, epochs=num_epoch, batch_size=batch_sz, verbose=1, callbacks=callbacks_list)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Show Output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Save the stop time to calculate the run time
stop_time = datetime.datetime.now()
#Print the run time
print ("Time required for training:",stop_time - start_time)

#Graph of loss
#Save the test loss of the model per epoch to plot
loss = history.history['loss']
#Save the number of epochs for use in our metric plot
epochs = range(len(loss))

#Create figure
plt.figure()
#Create a plot of training loss
plt.plot(epochs, loss, 'b', label='Training loss')
#Set a title for the plot
plt.title('Training Loss')
#Set a y-axis label for the plot
plt.ylabel('Loss')
#Set an x-axis label for the plot
plt.xlabel('Epoch')

#Show the plots
plt.show()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Generate New Output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#Specify which checkpoint to use for the output
filename = "weights-improvement-100-2.6093-dropout.hdf5"
filename=path+filename
#Load the specified checkpoint's weights
model.load_weights(filename)
#Compile the model
model.compile(loss='categorical_crossentropy', optimizer='adam')

#Select a random place to take the seed 
start = np.random.randint(0, len(sequences)-1)
pattern = list(sequences[start])
#Print the seed sequence
seed_text=' '.join([int_to_word[value] for value in pattern])
print("Seed:")
print("\"", seed_text, "\"")

# generate a sequence from a language model
# generate a fixed number of words
for i in range(0,np.random.randint(4,9)):
	# encode the text as integer
	encoded = tokenizer.texts_to_sequences([seed_text])[0]
	# pre-pad sequences to a fixed length
	encoded = pad_sequences([encoded], maxlen=max_length-1, padding='pre')
	# predict probabilities for each word
	yhat = model.predict_classes(encoded, verbose=0)
	# map predicted word index to word
	out_word = ''
	for word, index in tokenizer.word_index.items():
		if index == yhat:
			out_word = word
			break
	# append to input
	seed_text += ' ' + out_word
print(seed_text)