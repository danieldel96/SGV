#video classification
import numpy as np
from sklearn.model_selection import train_test_split
import keras
from tensorflow.keras.models import Sequential
from tensorflow.keras import optimizers
from tensorflow.keras.layers import Dense, Flatten, Conv3D, MaxPooling3D, Dropout, BatchNormalization, LeakyReLU
from keras.utils import to_categorical
from tensorflow.keras.models import load_model
import matplotlib.pyplot as plt

file = np.load('data/videos-softmax.npz',allow_pickle=True)
videos, labels = file['train']
#print(videos.shape)

proper_videos = []

for i in videos:
	proper_videos.append(i)

videos = np.array(proper_videos)

del proper_videos

reshape_videos = []

# 1/x number of frames in video '88/x'
fraction = 4
frames = int(80/fraction)

for i in videos:
	single_video = []
	for j in range( i.shape[0] ):
		if(  j % fraction == 0 ):
			single_video.append( i[j] )
	reshape_videos.append( single_video )

reshape_videos = np.array(reshape_videos)
print("18 frame video shape: ", reshape_videos.shape)

videos = reshape_videos

del reshape_videos

x_train, x_test, y_train, y_test = train_test_split(videos, labels, test_size=0.2, random_state=42)

shape = (128,128,frames,1)

x_train_input_shape = (x_train.shape[0],128,128,frames,1)
x_test_input_shape = (x_test.shape[0],128,128,frames,1)

x_train = np.reshape(x_train, x_train_input_shape)
x_test = np.reshape(x_test, x_test_input_shape)
y_train = to_categorical(y_train)
y_test = to_categorical(y_test)

print("Training data shape: ",x_train.shape)
print("Training labels shape: ", y_train.shape)

print(np.any(np.isnan(x_train)))
print(np.any(np.isnan(y_train)))

print(np.any(np.isnan(x_test)))
print(np.any(np.isnan(y_test)))

def model_3d(sample_shape):
	model = Sequential()
	#layer 1
	model.add(Conv3D(64, kernel_size=(3,3,3), strides=(2, 2, 1), input_shape=sample_shape))
	model.add(LeakyReLU(alpha=0.2))
	
	#layer 2
	model.add(Conv3D(128, kernel_size=(3,3,3), strides=(2, 2, 1)))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))
	
	#layer 3
	model.add(Conv3D(256, kernel_size=(3,3,3), strides=(2, 2, 1)))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))

	#layer 4
	model.add(Conv3D(512, kernel_size=(3,3,3), strides=(2, 2, 2)))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))

	#layer 5
	model.add(Conv3D(1024, kernel_size=(3,3,3), strides=(2, 2, 2)))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))

	#layer 6
	model.add(Conv3D(2048, kernel_size=(3, 3, 3), strides=(2, 2, 2)))
	model.add(BatchNormalization())
	model.add(LeakyReLU(alpha=0.2))

	#layer 7
	model.add(Flatten())
	model.add(Dense(2, activation='softmax'))
	return model

#train
train = model_3d(shape)

train.compile(loss='categorical_crossentropy',
		optimizer=optimizers.Adam(lr=0.0001),
		metrics=['accuracy'])

train.summary()


history = train.fit(x_train, y_train,
			batch_size=32,
			epochs=40,
			verbose=1,
			validation_split=0.3)


train.save('models/3d-cnn-softmax.hdf5')


#test
model = load_model('models/3d-cnn-softmax.hdf5')

score = model.evaluate(x_train, y_train, verbose=0)
print("Training Accuracy: ", score[1])

score = model.evaluate(x_test, y_test, verbose=0)
print("Testing Accuracy: ", score[1])
