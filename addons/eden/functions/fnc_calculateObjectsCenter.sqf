#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Get the center point from passed objects
 *
 * Arguments:
 * 0: Objects <ARRAY>
 *
 * Return Value:
 * Position <ARRAY>
 *
 * Example:
 * [[_node, _node1]] call rid_eden_fnc_calculateObjectsCenter
 *
 * Public: [No]
 */
params[["_objects", [], [[]]]];
TRACE_1("calculateObjectsCenter",_objects);

private _centerX = 0;
private _centerY = 0;
{
    (getPosATL _x) params ["_entityX", "_entityY"];
    _centerX = _centerX + _entityX;
    _centerY = _centerY + _entityY;
} forEach _objects;

private _objectsAmount = count _objects;
[_centerX / _objectsAmount, _centerY / _objectsAmount, 0];