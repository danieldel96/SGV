#main svm program
from sklearn import datasets
from sklearn import svm
from sklearn.model_selection import train_test_split
from sklearn import metrics
import numpy as np
import keras
from tensorflow.keras.datasets import mnist

results = []
accur = []

"""
with np.load('npz_files/CK_coor.npz', allow_pickle=True) as f:
	y = f['y'] 
	x = f['x']



"""
with np.load('npz_files/CK_svm.npz', allow_pickle=True) as f:
        x_train, y_train = f['x_train'], f['y_train']
        x_test, y_test = f['x_val'], f['y_val']

x = np.array( np.ndarray.tolist( x_train ) + np.ndarray.tolist( x_test ) )
y = np.array( np.ndarray.tolist( y_train ) + np.ndarray.tolist( y_test ) )
print("numpy!: ", x.shape)

def model( start, step_size, finish ):
	step = start

	while( step < finish ):
		x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=step,random_state=109)

		x_train = x_train.astype('float32') / 255.
		x_test = x_test.astype('float32') / 255.
		x_train = x_train.reshape((len(x_train), np.prod(x_train.shape[1:])))
		x_test = x_test.reshape((len(x_test), np.prod(x_test.shape[1:]).astype(int) ))

		#print(x_train.shape)
		#print(y_train.shape)

		clf = svm.SVC(kernel='linear')
		clf.fit(x_train, y_train)
		y_pred = clf.predict(x_test)

		accuracy = metrics.accuracy_score(y_test, y_pred)
		precision = metrics.precision_score(y_test, y_pred,pos_label='positive',average='micro')
		recall = metrics.recall_score(y_test, y_pred,pos_label='positive',average='micro')
		results.append( [ step, accuracy ] )
		accur.append( accuracy )

		print( [ step , accuracy ] )
		step = step + step_size

model(0.004, 0.01, 0.996)
min = np.amin(accur)
max = np.amax(accur)
mean = np.average(accur)

print( "min:	max:	mean:\n", min, max, mean )
