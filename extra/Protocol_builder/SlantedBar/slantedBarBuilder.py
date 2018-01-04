#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Wed Apr 26 08:25:54 2017

@author: cesar
"""
from PIL import Image, ImageDraw
#import Image, ImageDraw
import numpy as np
import os
import argparse        #argument parsing

parser = argparse.ArgumentParser(prog='slantedBarBuilder.py',description='Bar prototocls builder',formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('--outputFolder',help='Output folder',type=str, default='stim/', required=False)
parser.add_argument('--imgWith',help='Image width',type=int, default=400, required=False)
parser.add_argument('--imgHeight',help='Image height',type=int, default=400, required=False)
parser.add_argument('--slant',help='Slant bar (in degree) respect to y axis', type=int, default=-45, required=False)
parser.add_argument('--width',help='Bar width',type=int, default=50, required=False)
parser.add_argument('--height',help='Bar height',type=int, default=100, required=False)
parser.add_argument('--rotation',help='Image rotation (0 90 180 270) degree',type=int, default=0, required=False)
parser.add_argument('--x0',help='Bar initial position in x axis',type=int, default=0, required=False)
parser.add_argument('--xn',help='Bar final position in x axis',type=int, default=400, required=False)
parser.add_argument('--y0',help='Bar initial position in y axis',type=int, default=200, required=False)
parser.add_argument('--backgroundColor',help='Background color',nargs='+', type=int, default=[0,0,0], required=False)
parser.add_argument('--stimColor',help='Stimulus fill color',nargs='+', type=int, default=[0,255,255], required=False)
parser.add_argument('--velocity',help='Temporal velocity [pixels/frame] ',type=int, default=5, required=False)
args = parser.parse_args()

outputFolder = os.path.realpath(args.outputFolder)

if outputFolder[-1] != '/':
	outputFolder = outputFolder + '/'

if os.path.isdir(outputFolder):
    for kitem in os.listdir(outputFolder):
        if os.path.isfile(outputFolder+kitem):
            os.remove(outputFolder+kitem)            
else:
    os.mkdir( outputFolder ) 

imgWith = args.imgWith
imgHeight = args.imgHeight
slant = np.deg2rad(args.slant)
rotation = args.rotation
width = args.width
height = args.height
x0 = args.x0 - width
xn = args.xn
y0 = args.y0 - height/2
deltaW = int(height*np.tan(slant))
backgroundColor = tuple(args.backgroundColor)
stimColor = tuple(args.stimColor)
velocity =  args.velocity #in pixels/frame
step = range(0,xn+(width+np.abs(deltaW))+1,velocity)


for kdelta,kindex in zip(step,range(len(step))):
    im = Image.new("RGB", (imgWith, imgHeight), backgroundColor)
    draw = ImageDraw.Draw(im)
    
    if slant >= 0:    
        point1 = (x0 - deltaW + width + kdelta,y0 + height)
        point2 = (x0 - deltaW + kdelta, y0 + height)
        point3 = (x0 + kdelta,y0) 
        point4 = (x0 + width + kdelta,y0)
    else:
        point1 = (x0 + width + kdelta,y0 + height)
        point2 = (x0 + kdelta, y0 + height)
        point3 = (x0 + deltaW + kdelta,y0) 
        point4 = (x0 + deltaW + width + kdelta,y0)
    draw.polygon([point1,point2,point3,point4],fill=stimColor)
    
    
    del draw
    
    # write to stdout
    im = im.rotate(rotation,expand=True)
    # im = im.crop((211,211,631,631))
    # print outputFolder+'stim'+'{:05d}'.format(kindex)+'.png'
    im.save(outputFolder+'stim'+'{:05d}'.format(kindex)+'.png',format='PNG')
    
    
