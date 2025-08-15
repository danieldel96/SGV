#guide to the contents in this directory
1. First extract features from images in the CK/CK+ dataset using CK_coor.py
	-"python CK_coor.py"
	-CK_coor_quick.py removes the face detection algorithm and is mostly
		used for debugging.
		-runs very quickly compared to the original, hence the name.
	-CK_coor.py should take several minutes to properly extract all of the
		images in the dataset.
	-produces CK_coor.npz
2. After feature extraction, use svm.py to train/classify/test, along with
	some basic analytics of the algorithm used.
3. Future implementations will include:
	-training/testing on other datasets
	-multi-modal features
4. Need to include more detailed explanations within each file.

Papers:
	Gupta, Shivam. "Facial emotion recognition in real-time and static images." 2018 2nd International Conference on 		Inventive Systems and Control (ICISC). IEEE, 2018.
		https://ieeexplore.ieee.org/abstract/document/8398861?casa_token=3Sf-IR3Mrl0AAAAA:KRNXaXpW_hekzp8CsYL-9c9SUOKW0ERwloWW5RJp36Jwvn2lIjcQB9eAHbKLYxiMKMFopRZY2Q

	