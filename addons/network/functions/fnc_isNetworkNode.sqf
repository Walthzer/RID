#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Determines if an object is a networkNode, keeping in mind IEDs and VirtualIEDs 
 *
 * Arguments:
 * 0: object <Object>    
 *
 * Return Value:
 * is networkNode <BOOLEAN>
 *
 * Example:
 * [_ied] call rid_network_fnc_isNetworkNode
 *
 * Public: [No]
 */
params["_object"];

private _objectClass = typeOf _object;
if (isClass(configFile >> "CfgAmmo" >> _objectClass)) then {
    private _objectPos = getPosATL _object;
    private _virtualIED = nearestObject [_objectPos, "rid_virtualIED"];

    if (isNull _virtualIED || {(_object distance _virtualIED) > MaxVirtualIEDDistance}) exitWith {false};

    _object = _virtualIED;
};

_object getVariable[QGVAR(isNetworkNode), false];