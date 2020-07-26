#include "script_component.hpp"
/*
 * Attach a PressurePlate trigger to an object. With a threshold mass.
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
params["_object", ["_threshold", 110, [0]]];

//Confirm _object is an OBJECT
if (not (IS_OBJECT(_object))) exitWith {ERROR_1("%1 is not an OBJECT", _object)};

//Confirm _threshold is a NUMBER
if (not (IS_NUMBER(_threshold))) exitWith {ERROR_1("%1 is not a NUMBER", _threshold)};

//Obtain correct trigger area size:
private _objectType = typeOf _object;
private _triggerXY = switch (_objectType) do {

    case "Land_Grave_11_F": {[0.470, 0.900]};
    
    case "Land_DirtPatch_01_4x4_F": {[1.503, 1.199]};
    
    case "Land_DirtPatch_01_6x8_F": {[3.00, 1.843]};
    
    case "Land_dirt_road_rocks_01_F";
    case "Land_dirt_road_rocks_02_F";
    case "Land_dirt_road_rocks_03_F";
    case "Land_dirt_road_rocks_04_F": {[1.515, 1.841]};
    
    case "Land_dirt_road_damage_long_01_F";
    case "Land_dirt_road_damage_long_02_F";
    case "Land_dirt_road_damage_long_03_F";
    case "Land_dirt_road_damage_long_04_F";
    case "Land_dirt_road_damage_long_05_F": {[1.515, 3.358]};
    
    case "Land_DirtPatch_02_F";
    case "Land_DirtPatch_03_F";
    case "Land_DirtPatch_04_F";
    case "Land_DirtPatch_05_F": {[2.85, 3.098]};
    
    default {_objectSize = _object call BIS_fnc_boundingBoxDimensions; [((_objectSize) select 0)/2,((_objectSize) select 1)/2]};
};

//Create the PressurePlate Trigger
_trg = createTrigger ["EmptyDetector", getPosATL _object, false];
_trg setTriggerArea [(_triggerXY select 0), (_triggerXY select 1), (getDir _object), true, 3];
_trg setTriggerActivation ["ANY","PRESENT",true]; 
_trg setTriggerStatements ["private _return = if (this and ('AllVehicles' countType thisList > 0)) then {[thisTrigger, thisList] call rid_core_fnc_calculatePressure;} else {false;}; _return;","[(thisTrigger getVariable ['rid_core_pressurePlateObject', objNull])] call rid_network_fnc_activateNetworkCrawler;",""];
_trg setVariable [QGVAR(pressurePlateObject), _object, true];
_trg setVariable [QGVAR(maxMass), _threshold, true];
_object setVariable [QGVAR(pressureDetector), _trg, true];
//Attach trigger to VibrationDetector object
_trg attachTo [_object];

//Make VibrationDetector object a network node
_object call EFUNC(network,createNetworkNode);

//Delete detector when oject is deleted:
_object addEventHandler ["Deleted", {
	params ["_entity"];
	deleteVehicle (_entity getVariable [QGVAR(pressureDetector), objNull]);
}];
