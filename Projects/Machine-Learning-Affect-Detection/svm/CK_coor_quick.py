#
import glob
import shutil
import openpyxl as xl
from pathlib import Path
import face_coordinates
import dlib
import numpy as np
import cv2
import time
from data import paths

#rearrange baum to specific order in file directories
class_arr = ['Angry' ,'Happy', 'Surprise', 'Disgust', 'Neutral', 'Fear', 'Sad']

#Angry: 1 , Contempt: 2 , Disgust: 3 , Fear: 4 , Happy: 5 , Sadness: 6 , Surprise: 7

root = paths.CK_ROOT()
path_s = paths.CK_EMO()


book = xl.Workbook()
sheet = book.active
count = 1

x_train = []
y_train = []

x_val = []
y_val = []

for filename in glob.iglob(path_s + '*.txt', recursive = True):
	folder = Path(filename).stem[0:17]
	part = folder[0:4]
	file = folder[5:8]
	extension = folder[9:]
	print(folder,part,file,extension)
	f = open(filename, 'r')
	line = f.readline()
	image_location = root + part + '/' + file + '/*' + extension  + '.png'
	print(image_location)
	arr = glob.glob(image_location)

	for read in arr:
		print(read)

		"""
		detector = dlib.get_frontal_face_detector()
		predictor = dlib.shape_predictor("data/shape_predictor_68_face_landmarks.dat")
		crop_img = face_coordinates.facial_features(read, detector, predictor) 
		"""
		print(time.gmtime())
		
		crop_img = cv2.imread(read)
		gray = cv2.cvtColor(crop_img, cv2.COLOR_BGR2GRAY)


		emotion_label = int(float(line[3:16]))
		if count < 750:
			print(np.array(crop_img).shape)
			print(emotion_label)
			x_train.append(crop_img)
			y_train.append(emotion_label)
		else:
			x_val.append(crop_img)
			y_val.append(emotion_label)
	print(y_val)
	print(count)
	count += 1

x_train = np.array(x_train)
y_train = np.array(y_train)
x_val = np.array(x_val)
y_val = np.array(y_val)
print(x_train.shape)
print(y_val.shape)
np.savez('./npz_files/CK_coor_quick.npz', x_train=x_train, y_train=y_train, x_val=x_val, y_val=y_val)
