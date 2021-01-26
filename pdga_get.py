#!/usr/bin/env python3

import requests
import random
import lzma
import time
import os
import logging
import random
import sys

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s", datefmt="%H:%M:%S")
log = logging.getLogger(__name__)


def getPlayerDetails(num : int):
    ''' returns the HTML page for that player from pdga.com '''
    url = '/'.join(['https://www.pdga.com/player', str(num), 'details'])
    r = requests.get(url)
    if r.status_code == 200:
        return r.text
    elif r.status_code == 404:
        log.info(f'player {num} returned a 404, saving file')
        return r.text
    else:
        log.info(f'URL get for player {num} returned un-handled result code')
        return -1

def writeToLzma(data, outfile):
    with lzma.open(outfile, "wt", encoding='utf-8') as f:
        f.write(data)       


def getPlayers(start, stop, interval=4):
    for playerID in range(start, stop):
        outfile = './player/' + str(playerID) + '.html.xz'
        if (os.path.isfile(outfile) and os.stat(outfile).st_size > 1000):   # skip if it already exists
            log.info(f'file {outfile} already exists and is larger than 1KB, so skipping')
        else:
            deets = getPlayerDetails(playerID)
            if (deets != -1):
                writeToLzma(deets, outfile)
                log.info(f'writing output file for player {playerID}')
            wait_time = interval // 2 + random.randint(0, interval)
            log.debug(f'sleeping {wait_time} seconds')
            time.sleep(wait_time)

def __main__():
    player_dir = './player/'
    if not os.path.exists(player_dir):
        os.mkdir(player_dir)
    getPlayers(int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]))

__main__()
