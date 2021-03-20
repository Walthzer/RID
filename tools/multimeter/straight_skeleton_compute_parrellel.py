import os
import time
import multiprocessing
import ridObjects as rid
from math import sin, cos, pi, sqrt
from scipy import ndimage
from skimage import io, measure, img_as_bool, img_as_ubyte, filters
import skgeom as sg
from skgeom.draw import draw
from matplotlib import pyplot as plt

def multiprocessing_traces_fnc(contour, index):
    #print("STARTING: Contour_{}".format(index))
    
    trace = rid.Trace(contour)

    #print("ENDING: Contour_{}".format(index))
    return trace

def multiprocessing_sector_fnc(sector, index):
    print("STARTING: Sector_{}".format(index))
    
    for trace in traces:
        sector.intersections_with_trace(trace)

    print("ENDING: Sector_{}".format(index))
    return sector

def init_child(traces_):
    global traces
    traces = traces_

def main():
    start_time = time.time()

    ##PREPARE IMAGE:
    #Read in the image:
    filename = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'traces.png')
    traces = img_as_ubyte(io.imread(filename))

    #Find contours in of the traces:
    Alpha = traces[:,:,3]
    bool = img_as_bool(Alpha)
    filled = ndimage.binary_fill_holes(bool)
    gaussian = filters.gaussian(filled)
    contours = measure.find_contours(gaussian, 0.9)

    plt.imshow(gaussian)
    ##

    ##RID:
    sectors = rid.Sectors(rid.Resolution(2048,2048), rid.Resolution(3,3))

    ##PROCESSING:
    #     
    #pool = multiprocessing.Pool(4)
    #traces = pool.map(multiprocessing_traces_fnc, contours) #enumerate(contours)
    #pool.close()
   
    traces = []
    for k,contour in enumerate(contours):
        traces.append(multiprocessing_traces_fnc(contour, k))

    #pool = multiprocessing.Pool(2, initializer=init_child, initargs=(traces,))
    #sector_list = pool.map(multiprocessing_sector_fnc, sectors.sector_list) #enumerate(contours)
    #pool.close()

    for sector in sectors.sector_list:
        for trace in traces:
            sector.intersections_with_trace(trace)
        print([sector.name, sector.traceNames])

    print("---Exiting---")
    print("Elapsed Time: {}".format(time.time() - start_time))

    plt.ylim(2048,0)
    plt.xlim(0,2048)
    plt.show()

if __name__ == '__main__':
    main()