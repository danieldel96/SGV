#fine tuning video feature extraction snippet
#1/13/2021
#
import ffmpeg
import numpy as np
import glob
import cv2

path = 'dataset/RAVDESS/Video_Speech_Actor_**/**/*.mp4'

#sample video from dataset
files = glob.glob(path)
probe = ffmpeg.probe(files[0])
video_stream = next((stream for stream in probe['streams'] if stream['codec_type'] == 'video'), None)
width = int(video_stream['width'])
height = int(video_stream['height'])


#into function
def extract_vid(input):
	min = 200

	#resized video frame array
	resized = []

	#training labels
	class_arr = []

	for i in input:
		class_label = int(i[54])
		if( class_label == 3 or class_label == 4 ):
			print( "passes" )
		#buffer video stream
			out, _ = (
			    ffmpeg
			    .input(i)
			    .output('pipe:', format='rawvideo', pix_fmt='rgb24', loglevel='quiet')
			    .run(capture_stdout=True)
			)
			#convert video to numpy array
			video = (
				np
			    .frombuffer(out, np.uint8)
			    .reshape([-1, height, width, 3])
			)
			
			#new video array
			new = []

			#resize frames from 1280x720x3 to 128x128x1
			for frame in range(8, 88 ):
				#print( video[i].shape )
				new_img = cv2.resize(video[frame], (128,128) )
				new_img = cv2.cvtColor(new_img, cv2.COLOR_BGR2GRAY)
				new.append(new_img)
				#print( new_img.shape )

			#print(video.shape)
			new = np.array(new)
			print(new.shape)
			print(class_label)
			resized.append( new )
			if( class_label == 3 ):
				class_arr.append( 0 )
				print( class_label, ": 0")
			else:
				class_arr.append( 1 )
				print( class_label, ": 1")
		else:
			print("nope")
	train = [ resized, class_arr ]
	return np.array( train )
#end function

train = extract_vid(files)
print(train.shape)
np.savez('data/videos-softmax.npz', train=train)
