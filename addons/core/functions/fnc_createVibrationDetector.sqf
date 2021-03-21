#include "script_component.hpp"
/*
 * Attach a VibrationDetector trigger to an object.
 * 
 * Arguments:
 * 0: IED to attach detector to OR position for detector <OBJECT> OR <ARRAY>
 * 1: Trigger Mass Threshold <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * [145854:Empty.p3d] call rid_core_fnc_createVibrationDetector;
 *
 * Public: Yes
 *
*/
params[["_objectOrPosition", [0,0,0], [[], objNull], 3], ["_isIED", false, [false]]];
TRACE_2("createVibrationDetector",_objectOrPosition,_isIED);

private _objectAndPos = if (_objectOrPosition isEqualType []) then {
    [createVehicle ["rid_wireBox_base", _objectOrPosition, [], 0, "CAN_COLLIDE"], _objectOrPosition];
    TRACE_1("wireBox created at",_objectOrPosition);
} else {
    [_objectOrPosition, getPosATL _objectOrPosition]
};

_objectAndPos params["_object", "_position"];

//Obtain correct trigger area size:
private _triggerXY = [25, 25];

//Trigger activation code for IED and Detector
private _actionCode = [FUNC(conditionalCrawlerActivation),{[_this select 0, [QEGVAR(pcb,hasPower), QEGVAR(pcb,hasDetonator)]] call FUNC(tryDetonateIED)}] select _isIED;

//Create the VibrationDetector Trigger
_trg = createTrigger ["EmptyDetector", _position, false];
_trg setTriggerArea [(_triggerXY select 0), (_triggerXY select 1), (getDir _object), false, 3];
_trg setTriggerActivation ["ANY","PRESENT",true]; 
_trg setTriggerStatements ["private _return = if (this and ('AllVehicles' countType thisList > 0)) then {[thisTrigger, thisList] call rid_core_fnc_calculateVibrations} else {false}; _return;", format["[(thisTrigger getVariable ['rid_core_vibrationDetectorObject', objNull])] call %1;", _actionCode],""];
_trg setVariable [QGVAR(vibrationDetectorObject), _object, true];
_object setVariable [QGVAR(vibrationDetector), _trg, true];
//Attach trigger to VibrationDetector object
_trg attachTo [_object];

//Make VibrationDetector object a network node
if (!(_object getVariable[QGVAR(isNetworkNode), false])) then {
    _object call EFUNC(network,createNetworkNode);
};

//Delete detector when oject is deleted:
_object addEventHandler ["Deleted", {
    params ["_entity"];
    deleteVehicle (_entity getVariable [QGVAR(vibrationDetector), objNull]);
}];

TRACE_2("Vibration Detector Created",_trg,_object,_isIED);