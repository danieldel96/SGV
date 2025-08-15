import os, sys, inspect
src_dir = os.path.dirname(inspect.getfile(inspect.currentframe()))
arch_dir = '../LeapSDK/win/LeapSDK/lib' if sys.maxsize > 2**32 else '../lib/x86'
sys.path.insert(0, os.path.abspath(os.path.join(src_dir, arch_dir)))

print(sys.path)
print("importing Leap")
import Leap
#import LeapSDK.win.LeapSDK.lib.Leap
#import Leap
