import os
import threading
import queue
import time
import ridObjects as rid
from math import sin, cos, pi, sqrt
from scipy import ndimage
from skimage import io, measure, img_as_bool, img_as_ubyte, filters
import skgeom as sg
from skgeom.draw import draw
from matplotlib import pyplot as plt

start_time = time.time()

#Read in the image:
filename = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'traces.png')
traces = img_as_ubyte(io.imread(filename))

#Find contours in of the traces:
Alpha = traces[:,:,3]
bool = img_as_bool(Alpha)
filled = ndimage.binary_fill_holes(bool)
gaussian = filters.gaussian(filled)
countours = measure.find_contours(gaussian, 0.9)

plt.imshow(gaussian)

def draw_skeleton(polygon, skeleton, show_time=False):
    for h in skeleton.halfedges:
        if h.is_bisector:
            if h.vertex.time > 0 and h.opposite.vertex.time > 0:
                p1 = h.vertex.point
                p2 = h.opposite.vertex.point
                plt.plot([p1.x(), p2.x()], [p1.y(), p2.y()], 'r-', lw=2)
                

    if show_time:
        for v in skeleton.vertices:
            plt.gcf().gca().add_artist(plt.Circle(
                (v.point.x(), v.point.y()),
                v.time, color='blue', fill=False))

#Display the image and plot all contours found as polygons:
filename = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'polygons/poly_1.txt')
data = open(filename, "r").readlines()

points = []
for line in data:
    currentString = ""
    for c in line:
        if (c == ","):
            points.append((float(currentString), float(line[(len(currentString)+1):])))
            break
        currentString += c

if (points[0] == points[-1]):
    points = points[:-1]

#points.reverse()
sg_points = []
for index, point in enumerate(points):
    sg_points.append(sg.Point2(-point[0], point[1]))

#rotate points
rotation = sg.Transformation2(sg.ROTATION, sin(-pi/2), cos(-pi/2))

sg_points_rot = []
for point in sg_points:
    sg_points_rot.append(rotation(point))

rotation = sg.Transformation2(sg.ROTATION, sin(-pi/2), cos(-pi/2))

def inCircle(pt1, pt2):
    distance = sqrt(sg.squared_distance(pt1.point, pt2.point))
    return (distance < pt1.time)

def merge_points(points):
    merged_points = []
    while (len(points) > 0):
        pt = points.pop()

        checked_pts = []
        current_pts = []
        found_pts = [pt]

        while (len(found_pts) > 0):
            current_pts = found_pts.copy()
            found_pts.clear()
            for work_pt in current_pts:
                for global_pt in points:
                    if (inCircle(work_pt, global_pt) and inCircle(global_pt, work_pt)):
                        plt.plot([work_pt.point.x(), global_pt.point.x()], [work_pt.point.y(), global_pt.point.y()], 'r-', lw=2)
                        found_pts.append(global_pt)
                        points.remove(global_pt)
                checked_pts.append(work_pt)

        merged_pt_x = merged_pt_y = i = 0
        merged_pts_time = []
        checked_pts_points = []
        for checked_pt in checked_pts:
            merged_pt_x += checked_pt.point.x()
            merged_pt_y += checked_pt.point.y()
            merged_pts_time.append(checked_pt.time)
            checked_pts_points.append(checked_pt.point)
            i += 1
        merged_pt = rid.vertex(merged_pt_x/i, merged_pt_y/i, max(merged_pts_time))
        merged_points.append([merged_pt, checked_pts_points.copy()])
        
    return merged_points

def create_segments(interior_edges, merge_groups):
    segments = []
    segments_ids = []
    while (len(interior_edges) > 0):
        edge = interior_edges.pop()

        vertex0 = get_merge_point_for_edge_vertex(edge.vertex.point, merge_groups)
        if vertex0 is None:
            break
        vertex1 = get_merge_point_for_edge_vertex(edge.opposite.vertex.point, merge_groups)
        if vertex1 is None:
            break

        if vertex0 != vertex1 and not (vertex0.id + vertex1.id in segments_ids):
            segment = rid.segment(vertex0, vertex1)
            segments_ids.append(segment.id)
            segments.append(segment)
    return segments_ids, segments

def get_merge_point_for_edge_vertex(vertex, merge_groups):
    for merge_group in merge_groups:
        if vertex in merge_group[1]:
            return merge_group[0]
   
poly = sg.Polygon(sg_points_rot)
skel = sg.skeleton.create_interior_straight_skeleton(poly)

interior_points = []
for point in skel.vertices:
    if point.time > 0:
        interior_points.append(point)

interior_edges = []
for edge in skel.halfedges:
    if edge.is_bisector:
        interior_edges.append(edge)
    
merge_groups = merge_points(interior_points)
for group in merge_groups:
    p1 = group[0]
    plt.plot(p1.x, p1.y, "g+")
    plt.gcf().gca().add_artist(plt.Circle(
        (p1.x, p1.y),
        p1.time, color='blue', fill=False))

segments_ids, segments = create_segments(interior_edges, merge_groups)

for segment in segments:
    p1 = segment.vertex0
    p2 = segment.vertex1
    plt.plot([p1.x, p2.x], [p1.y, p2.y], 'b-', lw=2)

print(segments)

print("---Exiting---")
print("Elapsed Time: {}".format(time.time() - start_time))

plt.grid(color='r', linestyle='-', linewidth=2)
ticks = [0, 682, 1364, 2048]
plt.xticks(ticks)
plt.yticks(ticks)
plt.show()