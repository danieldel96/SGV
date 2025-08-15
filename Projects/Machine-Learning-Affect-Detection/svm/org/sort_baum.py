import glob
import shutil
import openpyxl as xl

#rearrange baum to specific order in file directories

"""
path_s = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/test_train/baum/MP4/'
path_d = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/test_train/baum/crop/'

for filename in glob.iglob(path_s + '**/*.mp4', recursive = True):
	print(filename)
	shutil.copy(filename, path_d)
"""
path_s = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/test_train/baum/all/'
path_d = '/s/duff/b/homes/RUIZLAB/danieldel/project_folder/datasets/test_train/baum/emo_sort/'

class_arr = ['Angry','Happy', 'Surprise', 'Disgust', 'Neutral', 'Fear', 'Sad']



path = 'Annotations_BAUM1a_fixed.xlsx'
excel = xl.load_workbook(path)
print(excel.get_sheet_names())

sheet = excel.get_sheet_by_name('Sheet1')

for index in range (2,266):
	#acess file name
	name = 'D' + str(index)
	file_path_s = path_s + sheet[name].value + '.mp4'
	print(file_path_s)
	string = 'E' + str(index)
	file_path_d = path_d + sheet[string].value
	print(file_path_d)
	shutil.copy(file_path_s, file_path_d)









