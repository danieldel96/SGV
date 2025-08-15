#detects faces in png images and outputs png with 
import cv2
import glob
import numpy as np
from data import paths
import facial_features
import dlib

CLASS_ARR = ['Angry', 'Happy' , 'Surprise', 'Disgust', 'Neutral', 'Fear', 'Sad']
dim = (500,500)

#instantiate training aray
x_train = []
y_train = []

x_val = []
y_val = []

#
def create_np_arr( x_, y_, s_path, d_path):
	for emotion in CLASS_ARR:
		arr = glob.glob(s_path + emotion + '/' + '*.png')
		count = 0

		for read in arr:
			print(read)
			count = count + 1

			print (emotion + ': ')

			detector = dlib.get_frontal_face_detector()
			predictor = dlib.shape_predictor("data/shape_predictor_68_face_landmarks.dat")

			crop_img = facial_features.facial_features(read, detector, predictor)

			#if dataset already standard, dont resize!!!
			crop_img = cv2.resize(crop_img, dim, interpolation = cv2.INTER_CUBIC)
			x_.append(crop_img)
			y_.append(CLASS_ARR.index(emotion))

			cv2.imwrite(d_path + emotion + '/' + emotion + '_cropped_' + str(count) + '.png', crop_img)


	np_x = np.array(x_)
	np_y = np.array(y_)
	return (np_x, np_y)
#

#create (x_train, label_train)

print("Begining training data processing: ... ")

x_train_y_train_arr_np = create_np_arr(x_train, y_train, paths.TRAIN_SFEW_SOURCE() , paths.TRAIN_SFEW_DEP() )

print("Begining testing data processing: ... ")

x_val_y_val_arr_np = create_np_arr(x_val, y_val, paths.VAL_SFEW_SOURCE() , paths.VAL_SFEW_DEP() )

np.savez('./npz_files/face_arr_SFEW.npz', x_train=x_train, y_train=y_train, x_val=x_val, y_val=y_val)

print('X_train, Y_train: ', x_train_y_train_arr_np)

print('X_val, Y_val: ', x_val_y_val_arr_np)
