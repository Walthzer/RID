#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Remove all Tripwires an object is the master of. 
 *
 * Arguments:
 * 0: Tripwire master <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_object0] call rid_core_fnc_defuseTripWire
 *
 * Public: [Yes]
 */
 params["_object"];
private _TripwiresParts = _object getVariable [QGVAR(tripwires_parts),[]];

{
	{
		deleteVehicle _x;
	} forEach _x;
} forEach _TripwiresParts;

_object setVariable [QGVAR(tripwires_parts), [], true];

detach (_object);