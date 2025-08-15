#video to image array script
import cv2
import glob

path_s = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/test_train/baum/emo_sort/'
path_d = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/test_train/baum/emo_sort_cap/'
class_arr = ['Angry','Happy', 'Surprise', 'Disgust', 'Neutral', 'Fear', 'Sad']
dim = (500,500)

num_of_fram = 3
count = 0
for emotion in class_arr:
	arr = glob.glob(path_s + emotion + '/' + '*.mp4')

	for index in arr:
		cap = cv2.VideoCapture(index)
		value = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
		frames = 1
		while cap.isOpened():
			cap.read()
			cap.read()
			success, image = cap.read()
			train = 2*num_of_fram/3
			print(train)
			if( success and frames <= (2 * num_of_fram / 3) ):
				cv2.imwrite(path_d + 'train/' + emotion + '/baum_' + emotion + '_' + str(count) + '_%#03d.png' % frames, image)
			elif( success ):
				 cv2.imwrite(path_d + 'val/' + emotion + '/baum_' + emotion + '_' + str(count) + '_%#03d.png' % frames, image)
			else:
				cap.release()
				print( index )
			print(success, count)
			frames += 1
			if(frames > num_of_fram ):
				cap.release()
				break
		count += 1
