# TrackSingleLines
This is a simple Processing script to measure several lengths in a single picture, save the data to csv file and automatically load the next picture.

You need to install Processing first. (https://processing.org/)
After launching the script you can choose a picture to work with. All meassured data will be saved to this folder.
The picture will be scaled to fit the properties of the window. (The coordinates will be scaled before calculating disctances.)

Start meassuring by clicking the left mouse button. Drag a line and release. That's it!
The length will be saved automatically to YourPictureFolder/singleLines.csv

Load the next picture with right click. It looks for a similar name with an increased index. If it fails to do so it will pop up aselection window.
