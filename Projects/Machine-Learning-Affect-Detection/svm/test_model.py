import keras
from keras.layers import Input,Dense
from keras.models import Model
from keras.datasets import mnist
import numpy as np
import matplotlib.pyplot as plt

#simp
input_img = Input(shape=(250000,))
encoded = Dense(512, activation='relu')(input_img)
encoded = Dense(256, activation='relu')(encoded)
encoded = Dense(128, activation='relu')(encoded)
encoded = Dense(64, activation='relu')(encoded) #the latent layer 
decoded = Dense(256, activation='relu')(encoded)
decoded = Dense(512, activation='relu')(decoded)
decoded = Dense(250000, activation='sigmoid')(decoded)

"""
input_img = Input(shape=(250000,))
encoded = Dense(128, activation='relu')(input_img)
encoded = Dense(64, activation='relu')(encoded)
encoded = Dense(32, activation='relu')(encoded)
encoded = Dense(16, activation='relu')(encoded) #the latent layer
decoded = Dense(64, activation='relu')(encoded)
decoded = Dense(128, activation='relu')(decoded)
decoded = Dense(250000, activation='sigmoid')(decoded)
"""

autoencoder = Model(input_img, decoded)
autoencoder.compile(optimizer='adadelta', loss='binary_crossentropy')

with np.load('npz_files/CK.npz', allow_pickle=True) as f:
	x_train, y_train = f['x_train'], f['y_train']
	x_test, y_test = f['x_val'], f['y_val']
	test = (x_train, y_train), (x_test, y_test)


(x_train,y_train), (x_test,y_test) = test #mnist.load_data()


x_train = x_train.astype('float32') / 255.
x_test = x_test.astype('float32') / 255.
x_train = x_train.reshape((len(x_train), np.prod(x_train.shape[1:])))
x_test = x_test.reshape((len(x_test), np.prod(x_test.shape[1:]).astype(int) ))
y_train = keras.utils.to_categorical(y_train,8)
y_test = keras.utils.to_categorical(y_test,8)

print (x_train.shape)
print (x_test.shape)


autoencoder.fit(x_train, x_train,
		epochs=30,
		batch_size=32,
		shuffle=True,
		validation_data=(x_test, x_test))

output = Dense(8, activation='softmax')(encoded)
autoencoder = Model(input_img,output)
autoencoder.compile(optimizer='adadelta',loss='categorical_crossentropy',metrics=['accuracy'])
autoencoder.fit(x_train,y_train,epochs=5,batch_size=32)
score = autoencoder.evaluate(x_test,y_test,verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])
