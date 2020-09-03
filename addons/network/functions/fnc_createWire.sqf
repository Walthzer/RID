#include "script_component.hpp"
/*
* Author: Walthzer/Shark
* Create a "wire" that physically represents a networkLink. Allowing the link to be destroyed and broken by EOD personal and explosions.
*
* Arguments:
* 0: Node <OBJECT>
* 1: Node <OBJECT>
*
* Return Value:
* None
*
* Example:
* [_node0, _node1] call rid_network_fnc_createWire
*
* Public: [No]
*/
params["_node0", "_node1"];

private _node0Pos = (getPosASL _node0);
private _x0 = (_node0Pos select 0);
private _y0 = (_node0Pos select 1);

private _node1Pos = (getPosASL _node1);
private _x1 = (_node1Pos select 0);
private _y1 = (_node1Pos select 1);

private _cableParentPos = [(_x0 + _x1)/2, (_y0 + _y1)/2, 0];

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
    _cableSegmentPos set [2, -0.03];
    private _surfaceNormal = surfaceNormal _cableSegmentPos;
    
    _cableSegment = createVehicle ["rid_wireHelper",_cableSegmentPos, [], 0, "CAN_COLLIDE"];
    _cableSegment setVariable [QGVAR(cableParent), _cableParent, true];
    [_cableSegment, _cableParent, false] call BIS_fnc_attachToRelative;

    _cableSegments pushBack (_cableSegment); 

    _cableSegment setVectorUp _surfaceNormal;
};

_cableParent setVariable [QGVAR(cableSegments), _cableSegments, true];

[_node0, _cableParent, _node1];
  