import cv2
import glob
import numpy as np

train_path_d = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/test_train/dump/train/'

val_path_d = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/test_train/dump/val/'


#create .npz from dump
class_arr = ['Angry','Happy', 'Surprise', 'Disgust', 'Neutral', 'Fear', 'Sad']

#instantiate training aray
x_train = []
y_train = []

x_val = []
y_val = []

def create_npz(s_path, x_ , y_ ):
	for emotion in class_arr:
		arr = glob.glob(s_path + emotion + '/' + '*.png')
		count = 0
		for read in arr:
			print(read)
			crop_img = cv2.imread(read)
			x_.append(crop_img)
			y_.append(class_arr.index(emotion))

	np_x = np.array( x_ )
	np_y = np.array( y_ )
	return ( np_x, np_y )


create_npz(train_path_d, x_train, y_train)
create_npz(val_path_d, x_val, y_val)

"""
npx_train = np.array(x_train)
npy_train = np.array(y_train)
npx_val = np.array(x_val)
npy2_val = np.array(y_val)
"""
np.savez('dump.npz', x_train=x_train, y_train=y_train, x_val=x_val, y_val=y_val)
