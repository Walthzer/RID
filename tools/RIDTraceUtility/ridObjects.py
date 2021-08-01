from math import sqrt, sin, cos, pi, radians
import itertools
from collections import namedtuple
from skgeom import boolean_set, Polygon, squared_distance, Bbox2, Point2, Vector2, Transformation2, ROTATION, TRANSLATION, Sign
from skgeom import skeleton
from skimage.measure import approximate_polygon

Resolution = namedtuple('Resolution', 'x y')

def create_float_tuple(x, y):
    return (float(x), float(y))

def CCPolygon(points):
    polygon = Polygon(points)
    if polygon.orientation() == Sign.NEGATIVE:
        polygon.reverse_orientation()
    return polygon

class Vertex:
    def __init__(self, x, y, time=0):
        self.id = float(x + y)
        self.x = float(x)
        self.y = float(y)
        self.time = float(time)

    def arma(self):
        return [self.x, self.y]

class Segment():
    def __init__(self, vertex0, vertex1, trace):
        self.id = vertex0.id + vertex1.id
        self.trace = trace
        self.vertices = [vertex0, vertex1]
        self.polygon_points = []

        #No pickle
        self.polygon = False

        #Arma
        self.vertex0 = vertex0  #[x, y]
        self.vertex1 = vertex1  #[x, y]
        self.time = (vertex0.time + vertex1.time)/2

    def __getstate__(self):
        state = self.__dict__.copy()

        # Don't pickle SkgeomObjects
        del state["polygon"]
        return state

    def __setstate__(self, state):
        self.__dict__.update(state)
        # Add polygon back since it doesn't exist in the pickle
        self.polygon = CCPolygon(self.polygon_points)

    def calculate_bbox_polygon(self, time):
        if self.vertex0.y == self.vertex1.y:
            vx = [self.vertex0.x, self.vertex1.x]
            vertex_index = vx.index(max(vx))
        else:
            vy = [self.vertex0.y, self.vertex1.y]
            vertex_index = vy.index(min(vy))
        
        z = 0
        while z < 2: 
            #Vector pointing at point inline with current vertex:
            v0 = self.vertices[vertex_index]
            v1 = self.vertices[1-vertex_index]

            p0 = Point2(v0.x, v0.y)
            p1 = Point2(v1.x, v1.y)

            top_vector = Vector2(p1, p0)
            top_vector = top_vector / sqrt(squared_distance(p1, p0))
            top_vector = top_vector * time

            rot_90 = Transformation2(ROTATION, 1, 0)
            fidelity_radian = radians(-180/self.trace.polygon_fidelity)
            rot_fidelity = Transformation2(ROTATION, sin(fidelity_radian), cos(fidelity_radian))

            angled_vector = rot_90(top_vector)
            
            i=0
            while i <= self.trace.polygon_fidelity:
                point_vector = angled_vector
                u = 0
                while u < i:
                    point_vector = rot_fidelity(point_vector)
                    u += 1
                point_translation = Transformation2(TRANSLATION, point_vector)
                point_2 = point_translation(p0)
                self.polygon_points.append(create_float_tuple(point_2.x(), point_2.y()))
                i += 1
            vertex_index = 1 - vertex_index
            z += 1
        self.polygon = CCPolygon(self.polygon_points)
    
    def arma(self):
        return [self.vertex0.arma(), self.vertex1.arma(), self.trace.time]

class Trace():
    id_iter = itertools.count()
    def __init__(self, contour=None, polygon_fidelity=5):
        #Unique
        self.id = next(self.id_iter)
        self.name = "tr_{}".format(self.id)

        #Minigame Variables
        self.voltage = 0
        self.connections = []

        #Topography and structure
        self.contour = contour
        self.polygon = self.create_polygon_from_contour(contour)
        sg_skeleton = skeleton.create_interior_straight_skeleton(self.polygon)
        self.merge_groups = self.create_merge_groups(sg_skeleton)
        self.polygon_fidelity = polygon_fidelity + 1
        self.segments, self.time = self.create_segments(sg_skeleton, self.merge_groups)

        for seg in self.segments:
            seg.calculate_bbox_polygon(self.time)

    def __getstate__(self):
        state = self.__dict__.copy()

        # Don't pickle SkgeomObjects
        del state["polygon"]
        return state

    def __setstate__(self, state):
        self.__dict__.update(state)
        # Add polygon back since it doesn't exist in the pickle
        self.polygon = self.create_polygon_from_contour(self.contour)

    def create_polygon_from_contour(self, contour):
        approx_polygon = approximate_polygon(contour, 5)

        #Prevent last point duplicate
        if (approx_polygon[0] == approx_polygon[-1]).all():
            approx_polygon = approx_polygon[:-1]

        #Rotate so origin becomes top left -> Screen space origin
        rotation = Transformation2(ROTATION, sin(-pi/2), cos(-pi/2))

        points = []
        for couple in approx_polygon:
            rot = rotation(Point2(-couple[0], couple[1]))
            points.append(rot)

        return CCPolygon(points)

    def inCircle(self, pt1, pt2):
        distance = sqrt(squared_distance(pt1.point, pt2.point))
        return (distance < pt1.time)

    def create_merge_groups(self, sg_skeleton):
        #Obtain interior points from CGAL::StraightSkeleton:
        points = []
        for point in sg_skeleton.vertices:
            if point.time > 0:
                points.append(point)

        #Simplfiy interior by merging points within each others time circle:
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
                        if (self.inCircle(work_pt, global_pt) and self.inCircle(global_pt, work_pt)):
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
                checked_pts_points.append(create_float_tuple(checked_pt.point.x(), checked_pt.point.y()))
                i += 1
            merged_pt = Vertex(merged_pt_x/i, merged_pt_y/i, max(merged_pts_time))
            merged_points.append([merged_pt, checked_pts_points.copy()])
            
        return merged_points

    def create_segments(self, sg_skeleton, merge_groups):
        #Obtain interior-skeleton edges from CGAL::StraightSkeleton:
        edges = []
        for edge in sg_skeleton.halfedges:
            if edge.is_bisector:
                edges.append(edge)

        #Build new segments based on simplified/reduced interior points:    
        segments = []
        segments_ids = []
        time = 0
        while (len(edges) > 0):
            edge = edges.pop()

            vertex0 = self.get_merge_point_for_edge_vertex(create_float_tuple(edge.vertex.point.x(), edge.vertex.point.y()), merge_groups)
            if vertex0 is None:
                break
            vertex1 = self.get_merge_point_for_edge_vertex(create_float_tuple(edge.opposite.vertex.point.x(), edge.opposite.vertex.point.y()), merge_groups)
            if vertex1 is None:
                break

            if vertex0 != vertex1 and not (vertex0.id + vertex1.id in segments_ids):
                segment = Segment(vertex0, vertex1, self)
                time += segment.time 
                segments_ids.append(segment.id)
                segments.append(segment)
        time = time/len(segments)
        return segments, time

    def get_merge_point_for_edge_vertex(self, vertex, merge_groups):
        for merge_group in merge_groups:
            if vertex in merge_group[1]:
                return merge_group[0]

class Sectors:

    def __init__(self, res=Resolution(0,0), shape=Resolution(0,0)):
        self.shape = shape
        self.sector_list, self.polygon_list, self.bbox_list = self.calculate_sectors(res, shape)

    def calculate_sectors(self, res, shape):
        sd = Resolution(res.x/shape.x, res.y/shape.y)
        bbox_list = {}
        polygon_list = {}
        sectors_list = []
        iy = 0
        while iy < shape.y:
            y0 = (sd.y)*iy
            y1 = (sd.y)*(iy+1)
            ix = 0
            while ix < shape.x:
                x0 = (sd.x)*ix
                x1 = (sd.x)*(ix+1)
                sector_name = "{}_{}".format(ix, iy)
                sectors_list.append(Sector(sector_name, Resolution(x0, y0), Resolution(x1, y1)))
                ix += 1
            iy += 1
        return sectors_list, polygon_list, bbox_list
    
class Sector():
    def __init__(self, name, xy0, xy1):
        self.name = name
        self.bbox_points = [xy0.x, xy1.y, xy1.x, xy0.y]
        self.bbox = Bbox2(xy0.x, xy1.y, xy1.x, xy0.y)
        self.polygon_points = [(xy0.x, xy0.y), (xy0.x, xy1.y), (xy1.x, xy1.y), (xy1.x, xy0.y)]
        self.traces = []

        #No pickle
        self.polygon = CCPolygon(self.polygon_points)

        #Arma
        self.traceNames = []
        self.traceSegments = []
    
    def __getstate__(self):
        state = self.__dict__.copy()

        # Don't pickle SkgeomObjects
        del state["polygon"]
        del state["bbox"]
        return state

    def __setstate__(self, state):
        self.__dict__.update(state)
        # Add polygon back since it doesn't exist in the pickle
        self.polygon = CCPolygon(self.polygon_points)
        self.bbox = Bbox2(self.bbox_points[0], self.bbox_points[1], self.bbox_points[2], self.bbox_points[3])

    def do_intersect(self, polygon):
        intersection = boolean_set.intersect(self.polygon, polygon)
        return intersection == []

    def intersections_with_trace(self, trace):
        if self.do_intersect(trace.polygon):
            return False

        self.traces.append(trace)
        intersecting_segments = []
        for segment in trace.segments:
            if self.do_intersect(segment.polygon):
                intersecting_segments.append(segment.arma())
        
        self.traceNames.append(trace.name)
        self.traceSegments = [trace.name, intersecting_segments]


       