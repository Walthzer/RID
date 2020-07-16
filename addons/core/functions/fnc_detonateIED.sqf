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
params["_ied", ["_delay", -2, [0]]];
//Cofirm given IED exists in the world
if (_ied isEqualTo objNull) exitWith { ERROR("Function exited: _ied object doesn't exist");};

//prepare variables
private _iedType = TypeOf _ied;
private _iedAmmo = getText (configFile >> "CfgVehicles" >> _iedType >> "ammo");

private _detonationObject = _iedAmmo createVehicle (getPosATL _ied);
[[_detonationObject], _delay] call ace_explosives_fnc_scriptedExplosive;
deleteVehicle _ied;