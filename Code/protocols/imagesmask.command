#!/bin/sh

ptb3-matlab -nojvm -nodisplay -r "cd '/home/cesar/Dropbox/Experimentos/Estimulos/SamplingInterface/Code/'; stimulation('protocols/imagesmask.zip')" 2>&1 | grep -v "exclude an item from Time Machine"
