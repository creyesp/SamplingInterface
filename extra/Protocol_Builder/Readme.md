# SlantedBar Builder


This code create a images secuence with slanted bar to used in SamplingInterface.

The parameter that it use are the following

This code creates a image sequence with a slanted bar in moving for will use in Sampling Interface.
The parameters used are as follows,

outputFolder : 	Output folder | default='.'
imgWith : 		Image width | default=400
imgHeight : 	Image height | default=400
slant : 		Slant bar in degree | default=-45
width : 		Bar width | default=50
height : 		Bar height | default=100
rotation : 	Image rotation (0 90 180 270) degree | default=0
x0 : 			Bar initial position in x axis | default=0
xn : 			Bar final position in x axis | default=400
y0 : 			Bar initial position in y axis | default=200
backgroundColor : Background color | default=[0,0,0]
stimColor : 	Stimulus fill color | default=[0,255,255]
velocity : 		Temporal velocity [pixels/frame]  | default=1



If you want to use the velocity 300,600 or 1200 [um/s] and you have fps = 60 [hz] and 1 [px] = 5 [um] then
you choise 1, 2 or 4 pixels / s.