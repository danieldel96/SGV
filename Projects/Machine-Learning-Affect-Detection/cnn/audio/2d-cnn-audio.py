#test
#2D convolutional neural network
#employs mfcc for preprocessing
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

#np.set_printoptions(threshold=sys.maxsize)

path = "dataset/RAVDESS/Audio_Speech_Actors_01-24/**/"

class_emo = ['neutral','calm','happy', 'sad', 'angry','fearful','disgust','surprised']

max_array = []
max = 0

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
"""
for filename in glob.iglob(path + '*.wav'):
	class_label = int(filename[58])
	file = extract_features(filename)
	audiofiles.append([file,class_label])

np.save('data/audio_array_2d.npy', audiofiles)
"""
audiofiles = np.load('data/audio_array_2d.npy',allow_pickle=True)

print(audiofiles[0].shape)


featuresdf = pd.DataFrame(audiofiles, columns=['feature','class_label'])

x = np.array(featuresdf.feature.tolist())
y = np.array(featuresdf.class_label.tolist())

le = LabelEncoder()
yy = to_categorical(le.fit_transform(y))

#print(x)
print('x.shape: ', x.shape)
#print(y)

x_train, x_test, y_train, y_test = train_test_split(x,yy,test_size=0.2,random_state=42)

num_rows = 40
num_columns = 228
num_channels = 1
num_labels = yy.shape[1]

x_train = x_train.reshape(x_train.shape[0], num_rows, num_columns, num_channels)
x_test = x_test.reshape(x_test.shape[0], num_rows, num_columns, num_channels)



def audio_cnn(in_shape=(num_rows,num_columns,num_channels)):
	model = Sequential()
	model.add(Conv2D(filters=16, kernel_size=2,input_shape=in_shape, activation='relu'))
	model.add(MaxPooling2D(pool_size=2))
	model.add(Dropout(0.2))
	
	model.add(Conv2D(filters=32, kernel_size=2, activation='relu'))
	model.add(MaxPooling2D(pool_size=2))
	model.add(Dropout(0.2))
	
	model.add(Conv2D(filters=64, kernel_size=2, activation='relu'))
	model.add(MaxPooling2D(pool_size=2))
	model.add(Dropout(0.2))

	model.add(Conv2D(filters=128, kernel_size=2, activation='relu'))
	model.add(MaxPooling2D(pool_size=2))
	model.add(Dropout(0.2))
	model.add(GlobalAveragePooling2D())
	
	model.add(Dense(num_labels, activation='softmax'))
	return model

def video_cnn(model):
	return model

model = audio_cnn()
model.compile(loss='categorical_crossentropy', metrics=['accuracy'], optimizer='adam')

model.summary()

num_epochs = 30
num_batch_size = 2

checkpointer = ModelCheckpoint(filepath='models/audio_model.hdf5', verbose=1, save_best_only=True)
model.fit(x_train, y_train, batch_size=num_batch_size, epochs=num_epochs, validation_data=(x_test,y_test), callbacks=[checkpointer], verbose=1)
score = model.evaluate(x_train, y_train, verbose=0)
print("Training Accuracy: ", score[1])

score = model.evaluate(x_test, y_test, verbose=0)
print("Testing Accuracy: ", score[1])

model.save("models/audio_model_2d.hdf5")
