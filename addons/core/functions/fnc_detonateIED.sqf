#include "script_component.hpp"
/*
 * Detonate an IED and clean up triggers.
 * 
 * Arguments:
 * 0: IED <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ied] call rid_core_fnc_detonateIED;
 *
*/
params["_ied", ["_delay", -1, [0]]];
TRACE_2("detonateIED",_ied,_delay);
//Cofirm given IED exists in the world
if (_ied isEqualTo objNull) exitWith { ERROR("Function exited: _ied object doesn't exist");};

private _iedType = TypeOf _ied;
private _detonationObject = 0;

if (_iedType == "rid_virtualIED") then {
    _detonationObject = _ied getVariable [QGVAR(ied), objNull];
    _ied setVariable[QGVAR(deleteCompanionOnDeletion), false, true];
    TRACE_2("VirtualIED",_ied,_detonationObject);
    deleteVehicle _ied;
    
} else {
    private _iedAmmo = getText (configFile >> "CfgVehicles" >> _iedType >> "ammo");
    _detonationObject = _iedAmmo createVehicle (getPosATL _ied);
    deleteVehicle _ied;
};

if (isNull _detonationObject) exitWith {ERROR("_detonationObject is null")};
[[_detonationObject], _delay] call ACE_FUNC(explosives,scriptedExplosive);