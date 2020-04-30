#!/usr/bin/env python3
#from os.path import dirname, join as pjoin
import scipy.io as sio
import numpy as np

def main():
    station_locations_path = 'data/stations_loc_all.mat'
    seissol_receiver_path = 'SeisSol-setup/receivers.dat'

    print("Reading {}".format(station_locations_path))
    station_locations = sio.loadmat(station_locations_path)

    locations = station_locations['locations']
    print("{} receivers found. Converting to SeisSol format.".format(locations.shape[0]))

    # These locations are relative location with respect to the north, east of the center of the lava lake
    x_lake = 2.604584249773606e+05 # east
    y_lake = 2.147270125870880e+06 # north
    locations[:,0] += x_lake
    locations[:,1] += y_lake

    print("Writing to {}".format(seissol_receiver_path))
    with open(seissol_receiver_path, 'w') as f:
        for location in locations:
            f.write("{:16.16f} {:16.16f} {:16.16f}\n".format(location[0], location[1], location[2]))
            

if __name__ == '__main__':
    main()
