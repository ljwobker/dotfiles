#!/usr/bin/env python3

import os
import pathlib
import subprocess
import multiprocessing


def buildInOutList(vid_dir):
    ''' takes a directory, returns a list of the input and output filename pairs '''
    argslist = []   # this is a list of lists: argslist = [ [in1, out1], [in2, out2] ] and so on... 
    for root, dirs, files in os.walk(vid_dir):
        for filename in files:
            if filename.endswith(".avi"):
                newroot = root.replace('flyspot november 2019 originals', 'converted_264')
                newfile = filename.replace('.avi', '.mp4')
                argslist.append([os.path.join(root, filename), os.path.join(newroot, newfile)])
    return argslist



# -vf crop=in_w*0.64:in_h*0.9:in_w*0.15:0

def convertOne(infile, outfile, qual='28'):
    ''' launches a subprocess that runs ffmpeg on a single file ''' 
    args = []
    # some initial setup stuff and the input file
    args.append('ffmpeg')
    args.append('-loglevel')
    args.append('fatal')
    args.append('-hide_banner')
    args.append('-i')
    args.append(infile)
    # args.append('-ss')           # -ss is how far to seek into the file
    # args.append('0')
    args.append('-c:v')     # we use libx265 because it's the best codec currently out there.... 
    args.append('libx264')
    args.append('-crf')
    args.append(qual)
    args.append('-an')      # -an is 'strip audio' 
    args.append('-y')       # -y is 'overwrite without asking'
    # some filename-specific cropping action happens here!
    if 'centerline' in infile:
        args.append('-vf')
        args.append('crop=in_w*0.6:in_h:in_w*0.2:0')    # take the "sides" off 
    if 'TAXI' in infile:
        args.append('-vf')
        args.append('crop=in_w:in_h*0.9:0:in_h*0.10')   # take a little off the top  ;)     
    args.append(outfile)
    print ("Converting {} to {}".format(infile, outfile))
    # rc = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, universal_newlines=True)
    rc = subprocess.run(args)
    print("finished {}".format(outfile))
    return rc




def __main__():

    vid_dir = '/storage/scratch/josiah/flyspot november 2019 originals'
    todo = buildInOutList(vid_dir)
    with multiprocessing.Pool(3) as mpool:   # create my worker pool 
        returncodes = mpool.starmap(convertOne, list(todo))
   
    return



__main__()
exit(0)

