import cv2
import dlib

OFFSET = 40

def facial_features(path, detector, predictor):

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
			print(x,' ',y)
			#draw circle
			cv2.circle(img=gray, center=(x, y), radius=2, color=(0, 255, 0), thickness=-1)
		img = gray[y1 - OFFSET:y2 + OFFSET, x1 - OFFSET:x2 + OFFSET]

	return img
