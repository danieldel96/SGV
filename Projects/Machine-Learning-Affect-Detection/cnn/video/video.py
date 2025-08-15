import ffmpeg
import glob
import numpy as np
import cv2 as cv

path = 'dataset/RAVDESS/Video_Speech_Actor_**/**/*.mp4'

videos = []
audios = []

amin_arr = []
vmin_arr = []

class_arr = []

files = glob.glob(path)
probe = ffmpeg.probe(files[0])
video_stream = next((stream for stream in probe['streams'] if stream['codec_type'] == 'video'), None)
width = int(video_stream['width'])
height = int(video_stream['height'])
"""
i=0
for file_name in files:
	probe = ffmpeg.probe(file_name)
	video_stream = next((stream for stream in probe['streams'] if stream['codec_type'] == 'video'), None)
	width = int(video_stream['width'])
	height = int(video_stream['height'])
	i += 1
	print(i, width, height)
"""
print(len(files))
i = 0
for file_name in files:
	print('\nNew file: ')
	width = 1280
	height = 720
	i += 1
	print(i,width, height)
	class_label = int(file_name[54])
	if( class_label == 3 or class_label == 4 ):
		
			print('happy or sad: ', class_label)
			out, _ = (
				ffmpeg
				.input(file_name)
				.output('pipe:', format='rawvideo')
				.run(capture_stdout=True,quiet=True)
			)

			print('unaltered length: ' , len(out)/921600 )
			print((len(out)/921600) % 1 )
			if( ((len(out)/921600) % 1) > 0 ):
				print('in if statement')
				out = out + bytes(460800)
				print( len(out) )
				print( 'past the dead point' )
			print('altered length: ', len(out)/921600 )

			video = np.frombuffer(out,np.uint8).reshape([-1,height,width])

			out, _ = (
				ffmpeg
				.input(file_name)
				.output('pipe:', format='mp3')
				.run(capture_stdout=True,quiet=True)
				)
			audio = np.frombuffer(out,np.uint8)
	
			amin_arr.append(audio.shape[0])
			vmin_arr.append(video.shape[0])
			videos.append(video[0:140])
			audios.append(audio[0:50446])
			class_arr.append(class_label)
			print(video.shape)
		#except: print('error reshaping array probably')
	else: print('not happy or sad: ', class_label)

videos = np.array(videos)
audios = np.array(audios)
print('videos shape: ', videos.shape)
print('audios shape: ', audios.shape)

min_array = []
for i in videos:
	min_array.append( i.shape[0] )
	print( i.shape )

print(np.min(min_array))
vmin_arr = np.array(vmin_arr)
amin_arr = np.array(amin_arr)

print('video min: ',vmin_arr.min())
print('audio min: ',amin_arr.min())

np.savez('data/videos', videos=videos)
np.savez('data/videos', audios=audios)
np.savez('data/labels', labels=class_arr)

