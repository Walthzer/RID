#include "script_component.hpp"
/*
 * Remove a tripwire
 * 
 * Arguments:
 * 0: Objects to which tripwire is attached <ARRAY>
 * 1: 
 * 
 * Return Value:
 * None
 *
 * Example:
 * [_tripWireNodes, _tripwirePartsIndex] call rid_core_fnc_removeTripWire
 *
 * Public: [Yes]
*/
params[["_tripWireNodes", []],["_tripwirePartsIndex", -1]];

if (_tripWireNodes isEqualTo [] || {_tripwirePartsIndex < 0}) exitWith {};

//Retrieve other tripwireParts
private _tripwiresParts = (_tripWireNodes#0) getVariable [QGVAR(tripwires_parts), []];
if (_tripwiresParts isEqualTo []) exitWith {};

private _tripwireParts = _tripwiresParts select _tripwirePartsIndex;

//Clean up the _tripWireNode's _tripwire_parts ARRAY.
_tripwiresParts set [_tripwirePartsIndex, []];
(_tripWireNodes#0) setVariable [QGVAR(tripwires_parts), _tripwiresParts, true];

//Delete all other parts of the tripwire:
{
deleteVehicle _x;
} forEach _tripwireParts;

//Deatch the Tripwire nodes from each other:
detach (_tripWireNodes#1);
