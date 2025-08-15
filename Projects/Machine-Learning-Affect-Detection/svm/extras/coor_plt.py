import numpy as np
import face_coordinates
import dlib
import glob
import shutil
from pathlib import Path
import matplotlib.pyplot as plt

feature_names = []

feature_names[1:17] = 'chin'
#TODO lol
#feaure_names[

root = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/CK/extended-cohn-kanade-images/cohn-kanade-images/'
path_s = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/CK/Emotion_labels/Emotion/**/**/'

array = []


for filename in glob.iglob(path_s + '*.txt', recursive = True):
	folder = Path(filename).stem[0:16]
	part = folder[0:4]
	file = folder[5:8]
	#print(folder,part,file)
	f = open(filename, 'r')
	line = f.readline()
	image_location = root + part + '/' + file + '/' + '*.png'
	#print(image_location)
	arr = glob.glob(image_location)
	for read in arr:
		print(read)
		detector = dlib.get_frontal_face_detector()
		predictor = dlib.shape_predictor("data/shape_predictor_68_face_landmarks.dat")
		crop_img = face_coordinates.facial_features(read, detector, predictor)
		plt.clf()
		plt.rc('font', size = 8)
		x, y = crop_img
		fig = plt.figure()
		ax = fig.add_subplot(111)
		plt.scatter(x,y,10)
		count = 1

		for xy in zip(x,y):
			label = str(count) + feature_name[count]
			ax.annotate( label, xy)
			count = count + 1

		array.append( crop_img)
		print( np.array(crop_img))
		plt.savefig('test.png')

