# SlantedBar Builder


This code creates an images sequence with slanted or straight bar to use in SamplingInterface.

The parameter that it use are the following:

This code creates a image sequence with a slanted bar in moving for will use in Sampling Interface.
The parameters used are as follows,

* **outputFolder** : 	The relative or absolutre output folder path | default='stim/'
* **imgWith** : 	The width of the protocol image (pixels) | default=400
* **imgHeight** : 	The heigh of the protocol image (pixels) | default=400
* **slant** : 		Slant Angles for bar respect to y axis (degree)| default=-45
* **width** : 		The width of bar (pixels) | default=50
* **height** : 		The heigh of bar (pixels) | default=100
* **rotation** : 	Rotation for protocol images  (0 90 180 270 degree)  | default=0
* **x0** : 		Initial position in x axis for bar (pixels)| default=0
* **xn** : 		Final position in x axis for bar (pixels)| default=400
* **y0** : 		Initial position in y axis for bar (pixels)| default=200
* **backgroundColor** : Protocol background color (pixels) | default=[0,0,0]
* **stimColor** : 	Fill color for the Slanted bar | default=[0,255,255]
* **velocity** : 	Velocity of the bar (pixels/frame)  | default=1



If you want to use the velocity 300,600 or 1200 [um/s] and you have fps = 60 [hz] and 1 [px] = 5 [um] then
you choise 1, 2 or 4 [pixels/frame] respectively.
**Example:**

python slantedBarBuilder.py --outputFolder slantedBar_1v_50bw_100bl_0deg --width 50 --height 100 --rotation 0 --velocity 1
python slantedBarBuilder.py --outputFolder slantedBar_2v_50bw_100bl_0deg --width 50 --height 100 --rotation 0 --velocity 2
python slantedBarBuilder.py --outputFolder slantedBar_3v_50bw_100bl_0deg --width 50 --height 100 --rotation 0 --velocity 3
