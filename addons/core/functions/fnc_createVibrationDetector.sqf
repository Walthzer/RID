#include "script_component.hpp"
/*
 * Attach a VibrationDetector trigger to an object.
 * 
 * Arguments:
 * 0: <OBJECT> to attach PressurePlate
 * 1: Trigger Mass Threshold <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [145854:Empty.p3d] call rid_core_fnc_createVibrationDetector;
 *
*/
params["_object"];

//Confirm _object is an OBJECT
if (not (IS_OBJECT(_object))) exitWith {ERROR_1("%1 is not an OBJECT", _object)};

//Obtain correct trigger area size:
private _objectType = typeOf _object;
private _triggerXY = [25, 25];

//Create the VibrationDetector Trigger
_trg = createTrigger ["EmptyDetector", getPosATL _object];
_trg setTriggerArea [(_triggerXY select 0), (_triggerXY select 1), (getDir _object), false, 3];
_trg setTriggerActivation ["ANY","PRESENT",true]; 
_trg setTriggerStatements ["private _return = if (this and ('AllVehicles' countType thisList > 0)) then {[thisTrigger, thisList] call rid_core_fnc_calculateVibrations;} else {false;}; _return;","[(thisTrigger getVariable ['rid_core_vibrationDetectorObject', objNull])] call rid_network_fnc_activateNetworkCrawler;",""];
_trg setVariable [QGVAR(vibrationDetectorObject), _object];

//Attach trigger to VibrationDetector object
_trg attachTo [_object];

//Make VibrationDetector object a network node
_object call EFUNC(network,createNetworkNode);

