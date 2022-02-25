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

//Verify _effectPosition was passed:
//if (isNull _position) exitWith {ERROR("_effectPosition was not passed")}; TODO: Actually fix this check, currently balancing on the fact nothing goes wrong! 

private _helper = nearestObject [_position, "rid_tripWire_helper"];
if (isNull _helper) exitWith {ERROR("No rid_tripWire_helper found; Tripwire probably improperly created!")};

private _tripWireNodes = _helper getVariable [QGVAR(tripWireNodes), []];

if (_tripWireNodes isEqualTo []) exitWith {ERROR("Helper has no tripWireNode defined; Helper probably improperly created!")};


//play *SNAP* sound at each of the nodes:
{
    _x say3D QEGVAR(pcb,sounds_cut);
} forEach _tripWireNodes;

//Retrieve other tripwireParts
private _tripwiresParts = (_tripWireNodes select 0) getVariable [QGVAR(tripwires_parts), []];
if (_tripwiresParts isEqualTo []) exitWith {ERROR("tripWireNode has no tripwires, yet a tripwire activation script points to it; How did you do this???")};

private _tripwirePartsIndex = _helper getVariable [QGVAR(tripwire_parts_index), -1];
if (_tripwirePartsIndex < 0) exitWith {ERROR("_tripwirePartsIndex is not set or invalid!")};

[_tripWireNodes, _tripwirePartsIndex] call FUNC(removeTripWire);

if ((_tripWireNodes select 0) getVariable [QGVAR(isConnected), false]) then {
    (_tripWireNodes select 0) spawn EFUNC(network,activateNetworkCrawler);
};