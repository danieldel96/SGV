#test
#1D convolutional neural network employing mfcc for preprocessing
import pandas as pd
import numpy as np
from numpy import expand_dims
from numpy import zeros
from numpy import ones
from numpy import vstack
from numpy.random import randn
from numpy.random import randint
from keras.datasets.mnist import load_data
from keras.optimizers import Adam
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Reshape
from keras.layers import Flatten
from keras.layers import BatchNormalization
from keras.layers import Conv1D
from keras.layers import Conv2D
from keras.layers import Conv2DTranspose
from keras.layers import Conv3D
from keras.layers import LeakyReLU
from keras.layers import Dropout
from keras.layers import MaxPooling2D
from keras.layers import GlobalAveragePooling2D
from keras.callbacks import ModelCheckpoint
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from keras.utils import to_categorical
from matplotlib import pyplot as plt
import wave
import glob
import librosa
import sys

path = "dataset/RAVDESS/Audio_Speech_Actors_01-24/**/"

class_emo = ['neutral','calm','happy', 'sad', 'angry','fearful','disgust','surprised']

def extract_features(filename):
	audio, sample_rate = librosa.load(filename, res_type = 'kaiser_fast')
	audio_length = len(audio)
	print('audio len: ', audio_length)
	max_array.append( len(audio) )
	print('sample rate: ',sample_rate)
	if( audio_length < 116247 ):
		zero = np.zeros(116247-audio_length)
		audio = np.concatenate((zero,audio), axis=None)

	#print('new audio len: ', len(audio))
	mfccs = librosa.feature.mfcc(y=audio, sr = sample_rate, n_mfcc=40)
	print('mfccs shape: ', mfccs.shape)
	mfccsscaled = np.mean(mfccs.T, axis=0)
	print('mfccscaled: ',np.array(mfccsscaled.shape))
	return mfccs

audiofiles = []
label = []

min_array = []
"""
for filename in glob.iglob(path + '*.wav'):
	class_label = int(filename[58])
	audio, sample_rate = librosa.load(filename, res_type = 'kaiser_fast')
	audio_length = len(audio)
	#105211 max audio length in set
	if( audio_length < 105211 ):
                zero = np.zeros(105211-audio_length)
                audio = np.concatenate((zero,audio), axis=None)
	#64745 min audio length in set
	
	#if( audio_length > 64745 ):
        #        audio = audio[(audio_length-64745):]
	
	if( class_label == 2 or class_label == 3 ):
		audiofiles.append([audio,class_label])
		min_array.append(audio_length)
	#print( np.array(audio) )

np.save('audio_array_1d.npy', audiofiles)

print( np.amax(min_array))
"""

audiofiles = np.load('audio_array_1d.npy',allow_pickle=True)

featuresdf = pd.DataFrame(audiofiles, columns=['feature','class_label'])

x = np.array(featuresdf.feature.tolist())
y = np.array(featuresdf.class_label.tolist())

le = LabelEncoder()
yy = to_categorical(le.fit_transform(y))

#print(x)
print('x.shape: ', x.shape)
#print(y)

x_train, x_test, y_train, y_test = train_test_split(x,yy,test_size=0.4,random_state=42)

print('x.shape after split: ', x_train.shape)

#(1440, 64745)
num_rows = 105211
num_columns = 1
num_channels = 1
num_labels = yy.shape[1]

print(x_train.shape[0])

x_train = x_train.reshape(x_train.shape[0], num_rows, num_columns)
x_test = x_test.reshape(x_test.shape[0], num_rows, num_columns)

print(x_train.shape)

def video_cnn(model):
	return model


def audio_cnn_1d(in_shape=(num_rows, num_columns)):
	#Layer 1
	model = Sequential()
	model.add(Conv1D(padding='same', filters=25, kernel_size=64, strides = 8, input_shape=in_shape))
	model.add(LeakyReLU(alpha=0.2))

	#Layer 2
	model.add(Conv1D(padding='same', filters=25, kernel_size=128, strides = 8))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))

	#Layer 3
	model.add(Conv1D(padding='same', filters=25, kernel_size=256, strides = 8))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))

	#Layer 4
	model.add(Conv1D(padding='same', filters=25, kernel_size=512, strides = 4))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))

	#Layer 5
	model.add(Conv1D(padding='same', filters=25, kernel_size=1024, strides = 4))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))

	model.add(Flatten())
	model.add(Dense(2, activation='relu'))
	return model

model = audio_cnn_1d()
opt = Adam(lr=0.00001)
model.compile(loss='categorical_crossentropy', metrics=['accuracy'], optimizer=opt)

model.summary()

num_epochs = 30
num_batch_size = 256

checkpointer = ModelCheckpoint(filepath='models/audio_model_1d.hdf5', verbose=1, save_best_only=True)
model.fit(x_train, y_train, batch_size=num_batch_size, epochs=num_epochs, validation_data=(x_test,y_test), callbacks=[checkpointer], verbose=1)
score = model.evaluate(x_train, y_train, verbose=0)
print("Training Accuracy: ", score[1])

score = model.evaluate(x_test, y_test, verbose=0)
print("Testing Accuracy: ", score[1])

model.save("models/audio_model_1d.hdf5")
