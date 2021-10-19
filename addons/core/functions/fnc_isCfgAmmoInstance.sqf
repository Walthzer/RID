#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Figures out if a certain object is an instance of a CfgAmmo Class
 *
 * Arguments:
 * 0: Instance <Object>
 *
 * Return Value:
 * is Instance <BOOLEAN>
 *
 * Example:
 * [_object] call rid_core_fnc_isCfgAmmoInstance
 *
 * Public: [No]
 */
params["_object"];

private _objectClass = typeOf _object;
isClass(configFile >> "CfgAmmo" >> _objectClass);