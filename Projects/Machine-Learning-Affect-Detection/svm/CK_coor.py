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

x = []
y = []

for filename in glob.iglob(path_s + '*.txt', recursive = True):
	
	folder = Path(filename).stem[0:17]
	part = folder[0:4]
	file = folder[5:8]
	extension = folder[9:]
	#print(folder,part,file,extension)
	f = open(filename, 'r')
	line = f.readline()
	image_location = root + part + '/' + file + '/*' + extension  + '.png'
	#print(image_location)
	arr = glob.glob(image_location)

	for read in arr:
		print(read)
		
		detector = dlib.get_frontal_face_detector()
		predictor = dlib.shape_predictor("data/shape_predictor_68_face_landmarks.dat")
		crop_img = face_coordinates.facial_features(read, detector, predictor)
		
		#crop_img = np.random.rand(2,125)

		#print(time.gmtime())
		emotion_label = int(float(line[3:16]))
		x.append(crop_img)
		#print(np.array(x[0]).shape)
		y.append(emotion_label)
		print("Emotion label array: ", y)
x = np.array(x)
y = np.array(y)
#print(x_train.shape)
#print(y_val.shape)
np.savez( './npz_files/CK_coor.npz', x = x, y = y )
