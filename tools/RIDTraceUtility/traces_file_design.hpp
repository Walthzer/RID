///STATIC -> DEFINED IN RID
class traces {
    type = 0;
    idc = 1894;
	text = "";

	/// TEXT TO GENERATE IN SERIES FILE:
	#include "0\traces.hpp"
	#include "1\traces.hpp"
	#include "2\traces.hpp"
	#include "3\traces.hpp"
	#include "4\traces.hpp"
	#include "5\traces.hpp"

/// TEXT TO GENERATE IN FILE -> .hpp
    
class sectors {
	shape[] = [3,3];
	sectors_list[] = [] //Python dict

		class 0_0 {
			traces_in_sector[] = [];
			traceSegmentsHashArray[] = [] //[["tr_0", [[[58, 85], [34, 92], 1], [[58, 85], [34, 92], 25], [[58, 85], [34, 92], 595]]
		};
};

class tr_0 {
	//Voltage
	connections[] = [];

	/*class segment_0 {
		vertex0 = [254.5, 875.4];
		vertex1 = [254.5, 875.4];
		diameter = 5; // Average diameter of trace in px
	}; Redundant due to HashMaps */
};
/*
[["tr_0", [
[[58, 85], [34, 92], 1], -> Segment with [vertex0, Vertex1, time]
[[58, 85], [34, 92], 25],
[[58, 85], [34, 92], 595]
]
*/