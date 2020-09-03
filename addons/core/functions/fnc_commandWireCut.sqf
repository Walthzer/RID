#include "script_component.hpp"
/*
 * Handle the cutting or dammaging of an exposed commandWire;
 * 
 * Arguments:
 * 0: Wire <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this#0] call rid_core_fnc_commandWireCut
 *
 * Public: [No]
*/
params["_wire"];

createVehicle ["rid_commandWireCut", (getPosATL _wire), [], 0, "CAN_COLLIDE"];
private _cableParent = _wire getVariable [QEGVAR(network,cableParent), objNull];
if(!(_cableParent isEqualTo objNull) && {alive _cableParent}) then {
    _cableParent setDamage 1;
};
deleteVehicle _wire;
