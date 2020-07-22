#include "script_component.hpp"
/*
 * AIIIIII
 * 
 * Arguments:
 * 0: <OBJECT> to attach PressurePlate
 * 1: Trigger Mass Threshold <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [145854:Empty.p3d] call rid_core_fnc_createPressurePlate;
 *
*/
//GET NEAREST "rid_helper" and retrieve rid_core_tripWire_node -> rid_network_fnc_activateNetworkCrawler + rid_core_fnc_tripWireCleanUp;
private _position = _this;

//play *SNAP* sound:
playSound QEGVAR(pcb,sounds_cut);

//Verify _effectPosition was passed:
//if (isNull _position) exitWith {ERROR("_effectPosition was not passed")}; TODO: Actually fix this check, currently balancing on the fact nothing goes wrong! 

private _helper = nearestObject    [_position, "rid_tripWire_helper"];
if (isNull _helper) exitWith {ERROR("No rid_tripWire_helper found; Tripwire probably improperly created!")};

private _tripWireNodes = _helper getVariable [QGVAR(tripWireNodes), []];

if (_tripWireNodes isEqualTo []) exitWith {ERROR("Helper has no tripWireNode defined; Helper probably improperly created!")};

//Retrieve other tripwireParts
private _tripwiresParts = (_tripWireNodes#0) getVariable [QGVAR(tripwires_parts), []];
if (_tripwiresParts isEqualTo []) exitWith {ERROR("tripWireNode has no tripwires, yet a tripwire activation script points to it; How did you do this???")};

private _tripwirePartsIndex = _helper getVariable [QGVAR(tripwire_parts_index), -1];
if (_tripwirePartsIndex < 0) exitWith {ERROR("_tripwirePartsIndex is not set or invalid!")};

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

(_tripWireNodes#0) spawn EFUNC(network,activateNetworkCrawler);