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
params["_object", ["_isIED", false, [false]]];

//Confirm _object is an OBJECT
if (not (IS_OBJECT(_object))) exitWith {ERROR_1("%1 is not an OBJECT", _object)};

//Obtain correct trigger area size:
private _objectType = typeOf _object;
private _triggerXY = [25, 25];

//Trigger activation code for IED and Detector
private _actionCode = [QEFUNC(network,activateNetworkCrawler),{[_this#0, [QEGVAR(pcb,hasPower), QEGVAR(pcb,hasDetonator)]] call FUNC(tryDetonateIED)}] select _isIED;

//Create the VibrationDetector Trigger
_trg = createTrigger ["EmptyDetector", getPosATL _object, false];
_trg setTriggerArea [(_triggerXY select 0), (_triggerXY select 1), (getDir _object), false, 3];
_trg setTriggerActivation ["ANY","PRESENT",true]; 
_trg setTriggerStatements ["private _return = if (this and ('AllVehicles' countType thisList > 0)) then {[thisTrigger, thisList] call rid_core_fnc_calculateVibrations} else {false}; _return;", format["[(thisTrigger getVariable ['rid_core_vibrationDetectorObject', objNull])] call %1;", _actionCode],""];
_trg setVariable [QGVAR(vibrationDetectorObject), _object, true];
_object setVariable [QGVAR(vibrationDetector), _trg, true];
//Attach trigger to VibrationDetector object
_trg attachTo [_object];

//Make VibrationDetector object a network node
_object call EFUNC(network,createNetworkNode);

//Delete detector when oject is deleted:
_object addEventHandler ["Deleted", {
    params ["_entity"];
    deleteVehicle (_entity getVariable [QGVAR(vibrationDetector), objNull]);
}];

