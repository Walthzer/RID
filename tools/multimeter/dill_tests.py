import os
import time
from pathos.multiprocessing import ProcessingPool as Pool
import dill
import ridObjects as rid
from math import sin, cos, pi, sqrt
from scipy import ndimage
from skimage import io, measure, img_as_bool, img_as_ubyte, filters
import skgeom as sg
from skgeom.draw import draw
from matplotlib import pyplot as plt

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

res = rid.Resolution(2048,2048)
shape = rid.Resolution(3,3)
sectors = rid.Sectors(res, shape)

def skeletonize(countour):
    approximated_countour = measure.approximate_polygon(countour, 5)
    if ((approximated_countour[0] == approximated_countour[-1]).all()):
        approximated_countour = approximated_countour[:-1]

    rotation = sg.Transformation2(sg.ROTATION, sin(-pi/2), cos(-pi/2))

    points = []
    for couple in approximated_countour:
        sg_couple = sg.Point2(-couple[0], couple[1])
        rot = rotation(sg_couple)
        points.append(rot)

    poly = sg.Polygon(points)
    return sg.skeleton.create_interior_straight_skeleton(poly)

trace = rid.Trace(skeletonize(contours[8]), 8)

vertex = rid.Vertex(58, 66, 1)

trace_copy = dill.copy(trace)