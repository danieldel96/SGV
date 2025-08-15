#detects faces in png images and outputs png with 
import cv2
import glob
import numpy as np
from data import paths

face_cascade = cv2.CascadeClassifier('data/haarcascade_frontalface_default.xml')

class_arr = ['Angry' ,'Happy', 'Surprise', 'Disgust', 'Neutral', 'Fear', 'Sad']
dim = (500,500)

#instantiate training aray
x_train = []
y_train = []

x_val = []
y_val = []

# create_np_arr( x, y, path): returns (x_,y_) in np array
# emaple: create_np_arr( x_train, y_train, train_path)
#####################################################################################
def create_np_arr( x_, y_, s_path, d_path):
	for emotion in class_arr:
		arr = glob.glob(s_path + emotion + '/' + '*.png')
		count = 0

		for read in arr:
			print(read)
			count = count + 1

			print (emotion + ': ')
			print(count)

			img = cv2.imread(read)
			gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
			faces = face_cascade.detectMultiScale(gray, 1.1, 4)

			for (x,y,w,h) in faces:
				cv2.rectangle(img, (x,y), (x+w, y+h), (0,0,0), 0)

			crop_img = gray[y:y+h, x:x+w]
			crop_img = cv2.resize(crop_img, dim, interpolation = cv2.INTER_CUBIC)

			x_.append(crop_img)
			y_.append(class_arr.index(emotion))

			print("Index of class_arr emotion: " + str(class_arr.index(emotion)))

			cv2.imwrite(d_path + emotion + '/' + emotion + '_cropped_' + str(count) + '.png', crop_img)

	np_x = np.array(x_)
	np_y = np.array(y_)
	return (np_x, np_y)
#############################################################################################

#create (x_train, label_train)

print("Begining training data processing: ... ")

x_train_y_train_arr_np = create_np_arr(x_train, y_train, paths.TRAIN_SFEW_SOURCE() , paths.TRAIN_SFEW_DEP() )

print("Begining testing data processing: ... ")

x_val_y_val_arr_np = create_np_arr(x_val, y_val, paths.VAL_SFEW_SOURCE() , paths.VAL_SFEW_DEP() )

np.savez('./npz_files/face_arr_SFEW.npz', x_train=x_train, y_train=y_train, x_val=x_val, y_val=y_val)

print('X_train, Y_train: ', x_train_y_train_arr_np)

print('X_val, Y_val: ', x_val_y_val_arr_np)



#(x_train, y_train)

#create x,y test

