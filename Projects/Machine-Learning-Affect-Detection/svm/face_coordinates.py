import cv2
import dlib
import numpy as np
import math
from sklearn.preprocessing import normalize

OFFSET = 40

def norm( vector ):
	max = np.amax(vector)
	min = np.amin(vector)
	for index in range(len(vector)):
		norm = ( vector[index] - min) / ( max - min )
		vector[index] = norm
	return vector

def facial_features(path, detector, predictor):
	array = []
	array_x = []
	array_y = []
	#read in image
	img = cv2.imread(path)

	gray = cv2.cvtColor(src=img, code=cv2.COLOR_BGR2GRAY)

	#gray = cv2.equalizeHist(gray)

	faces = detector(gray,1)

	for face in faces:

		x1 = face.left() # left point
		y1 = face.top() # top point
		x2 = face.right() # right point
		y2 = face.bottom() # bottom point

		landmarks = predictor(image=gray, box=face)
		for n in range(0,68):
			x = landmarks.part(n).x
			y = landmarks.part(n).y
			#print('Coordinates: ',x,' ',y)
			array_x.append( x )
			array_y.append( y )
			#draw circle
			#cv2.circle(img=gray, center=(x, y), radius=2, color=(0, 255, 0), thickness=-1)
		#img = gray[y1 - OFFSET:y2 + OFFSET, x1 - OFFSET:x2 + OFFSET]

	array = [ array_x , array_y ]

	#normalize
	#array = norm(array)

	array_x, array_y = array
	x_mean = np.mean(array_x)
	y_mean = np.mean(array_y)

	distances = []
	angles = []

	for x,y in zip(array_x, array_y):
		dx = x - x_mean
		dy = y - y_mean
		#print("dx and dy",dx,dy)
		dist = math.hypot( dx, dy )
		angle = math.atan2( dy, dx )
		#print("angle: ", angle )
		angle = angle * 180 / math.pi
		if (angle < 0):
			angle = 360 + angle
		#print("angle(degrees): ", angle )
		distances.append( dist )
		angles.append( angle )
	
	#add in normalized array to regular array
	array_x = array_x + norm(array_x)
	array_y = array_y + norm(array_y)
	
	#add in distances and angles
	array_x = array_x + distances
	array_y = array_y + angles

	#add in the center of gravity
	array_x.append( x_mean )
	array_y.append( y_mean )
	#print( len(array_x), len(array_y))
	array = [ array_x, array_y ]
	#print(array)
	return array
