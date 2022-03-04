#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Remove ghost tripwire of passed module
 *
 * Arguments:
 * 0: Module <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_module] call rid_eden_fnc_tripwireModuleRemoveWire;
 *
 * Public: [No]
 */
params ["_module"];

private _ghostTripwireParts = _module getVariable [QGVAR(tripwireParts), []];
{
    if !(isNull _x) then {deleteVehicle _x};
} forEach _ghostTripwireParts;