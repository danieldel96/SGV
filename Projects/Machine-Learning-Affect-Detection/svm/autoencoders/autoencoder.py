from keras.layers import Input,Dense
from keras.models import Model
from keras.datasets import mnist
import numpy as np
import matplotlib.pyplot as plt

encoding_dim = 32

input_img = Input(shape=(250000,))

encoded = Dense(encoding_dim, activation ='relu')(input_img)

decoded = Dense(250000, activation='sigmoid')(encoded)

autoencoder = Model(input_img, decoded)

encoder = Model(input_img, encoded)

encoded_input = Input(shape=(encoding_dim,))

decoder_layer = autoencoder.layers[-1]

decoder = Model(encoded_input, decoder_layer(encoded_input))

autoencoder.compile(optimizer='adadelta', loss='binary_crossentropy')

with np.load('npz_files/face_arr.npz', allow_pickle=True) as f:
	x_train, y_train = f['x_train'], f['y_train']
	x_test, y_test = f['x_val'], f['y_val']
	test = (x_train, y_train), (x_test, y_test)

(x_train,_), (x_test,_) = test # mnist.load_data()

x_train = x_train.astype('float32') / 255.
x_test = x_test.astype('float32') / 255.
x_train = x_train.reshape((len(x_train), np.prod(x_train.shape[1:])))
x_test = x_test.reshape((len(x_test), np.prod(x_test.shape[1:]).astype(int) ))
print (x_train.shape)
print (x_test.shape)

autoencoder.fit(x_train, x_train,
		epochs=30,
		batch_size=20,
		shuffle=True,
		validation_data=(x_test, x_test))
"""
autoencoder.save("./models/autoencoder.h5")
decoder.save("./models/decoder.h5")
encoder.save("./models/encoder.h5")
"""
encoded_imgs = encoder.predict(x_test)
decoded_imgs = decoder.predict(encoded_imgs)




n = 7
plt.figure(figsize=(20,4))
for i in range(n):
	#original display
	ax = plt.subplot(2, n, i+1)
	plt.imshow(x_test[i].reshape(500,500))
	plt.gray()
	ax.get_xaxis().set_visible(False)
	ax.get_yaxis().set_visible(False)
	
	#reconstruction display
	ax = plt.subplot(2, n, i+1+n)
	plt.imshow(decoded_imgs[i].reshape(500,500))
	plt.gray()
	ax.get_xaxis().set_visible(False)
	ax.get_yaxis().set_visible(False)

plt.savefig('foo.png')

