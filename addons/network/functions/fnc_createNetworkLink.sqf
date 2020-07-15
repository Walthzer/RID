#include "script_component.hpp"
/*
 * Create a link between two network components. 
 * Fysically represent this link if argument 2 is TRUE; 
 
 * Arguments:
 * 0: Node <OBJECT>
 * 1: Node <OBJECT>
 * 2: Spawn fysical cable? <BOOLEAN>
 *
 * Return Value:
 * None OR Fysical cable parent.
 *
 * Example:
 * [8481:Empty.p3d, 4852:IEDLandSmall_F.p3d] call rid_network_fnc_createNetworkLink;
 *
*/
params["_node0", "_node1", "_createCable"];

//Use _createCable is it has a passed value, else default to false
//private _createCable = (IS_BOOLEAN(_createCable) || {false});
//Confirm the arguments are objects
if (not (IS_OBJECT(_node0) and IS_OBJECT(_node1))) exitWith {ERROR_2("%1 and %2 are not objects!", _node0, _node1)};
//Confirm the arguments are network nodes
if (not ((_node0 getVariable[QGVAR(isNetworkNode), false]) and (_node1 getVariable[QGVAR(isNetworkNode), false]))) exitWith {ERROR_2("%1 and %2 are not Network Nodes!", _node0, _node1)};

//Create fysical cable: ////TODO: FIX THE CREATION OF PHYSICAL WIRE
if (_createCable) then {
	private _node0Pos = (getPosASL _node0);
	private _x0 = (_node0Pos select 0);
	private _y0 = (_node0Pos select 1);
	
	private _node1Pos = (getPosASL _node1);
	private _x1 = (_node1Pos select 0);
	private _y1 = (_node1Pos select 1);
	
	private _cableParentPos = [(_x0 + _x1)/2, (_y0 + _y1)/2, 0.5];
	
	private _cableParent = "Helper_Base_F" createVehicle _cableParentPos;
	[_cableParent, {{ _x addCuratorEditableObjects [[_this],true ] } forEach allCurators;}] remoteExec ["call", 2];
	
	private _distanceBetweenNodes = (_node0 distance2D _node1);
	private _directionVector = _node0Pos vectorFromTo _node1Pos;
	private _direction = _node0 getDir _node1;
	
	private _cableSegments = [];
	private _cableSegmentsAmount = ceil (_distanceBetweenNodes / 2);
	
	for "_i" from 1 to _cableSegmentsAmount do {
		private _offset = _i * 2 - 1;
		private _cableSegmentPos = (_node0Pos vectorAdd ( _directionVector vectorMultiply (_offset)));
		_cableSegmentPos set [2, 0.5];
		private _surfaceNormal = surfaceNormal _cableSegmentPos;
		
		//Land_WoodenWall_03_s_pole_F
		_cableSegment = createVehicle ["Land_NetFence_03_m_pole_F",_cableSegmentPos, [], 0, "CAN_COLLIDE"];
		[_cableSegment, _cableParent, false] call BIS_fnc_attachToRelative;
		_cableSegments pushBack (_cableSegment); 
		
		_cableSegment setVectorUp _directionVector;
		//_cableSegment setVectorUp surfaceNormal position _cableSegment;
		
		//_cableSegment setVectorUp[1,1,1];
	};
	_cableParent setVariable [QGVAR(cableSegments), _cableSegments];
	_cableParent setVariable [[QGVAR(networkConnections), [_node0, _node1]];
	
	_node0NetworkConnections = _node0 getVariable [QGVAR(networkConnections), []];
	_node1NetworkConnections = _node1 getVariable [QGVAR(networkConnections), []];
	
	_node0NetworkConnections pushBackUnique _cableParent;
	_node1NetworkConnections pushBackUnique _cableParent;
	
	_node0 setVariable [QGVAR(networkConnections), _node0NetworkConnections];
	_node1 setVariable [QGVAR(networkConnections), _node1NetworkConnections];
	
} else {
//Don't create Fysical cable, just link the nodes:
	_node0NetworkConnections = _node0 getVariable [QGVAR(networkConnections), []];
	_node1NetworkConnections = _node1 getVariable [QGVAR(networkConnections), []];
	
	_node0NetworkConnections pushBackUnique _node1;
	_node1NetworkConnections pushBackUnique _node0;
	
	_node0 setVariable [QGVAR(networkConnections), _node0NetworkConnections];
	_node1 setVariable [QGVAR(networkConnections), _node1NetworkConnections];
};
