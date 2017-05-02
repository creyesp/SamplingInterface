# SlantedBar Builder


This code create a images secuence with slanted bar to used in SamplingInterface.

The parameter that it use are the following

This code creates a image sequence with a slanted bar in moving for will use in Sampling Interface.
The parameters used are as follows,

* **outputFolder** : 	The relative or absolutre output folder path | default='stim/'
* **imgWith** : 		Protocol image width | default=400
* **imgHeight** : 	Protocol image height | default=400
* **slant** : 		Slant bar (in degree) respect to y axis | default=-45
* **width** : 		Slanted bar width | default=50
* **height** : 		Slanted bar height | default=100
* **rotation** : 	Protocol image rotation (0 90 180 270) degree | default=0
* **x0** : 			Slanted bar initial position in x axis | default=0
* **xn** : 			Slanted bar final position in x axis | default=400
* **y0** : 			Slanted bar initial position in y axis | default=200
* **backgroundColor** : Protocol background color | default=[0,0,0]
* **stimColor** : 	Fill color for the Slanted bar  | default=[0,255,255]
* **velocity** : 		Temporal velocity [pixels/frame]  | default=1



If you want to use the velocity 300,600 or 1200 [um/s] and you have fps = 60 [hz] and 1 [px] = 5 [um] then
you choise 1, 2 or 4 [pixels/s] respectively.
**Example:**

python slantedBarBuilder.py --outputFolder slantedBar_1v_50bw_100bl_0deg --width 50 --height 100 --rotation 0 --velocity 1
python slantedBarBuilder.py --outputFolder slantedBar_2v_50bw_100bl_0deg --width 50 --height 100 --rotation 0 --velocity 2
python slantedBarBuilder.py --outputFolder slantedBar_3v_50bw_100bl_0deg --width 50 --height 100 --rotation 0 --velocity 3
