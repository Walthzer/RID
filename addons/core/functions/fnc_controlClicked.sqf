#include "script_component.hpp"
/*
 * Process the click on a control in a PCB Dialog.
 * 
 * Arguments:
 * Position <Control> (OBJECT)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control] call rid_core_fnc_controlClicked
 *
*/
params["_controlClicked"];

//Prepare variables
private _lookUpArray = (missionNamespace getVariable QGVAR(lookUpArray));
private _correctCuts = (missionNamespace getVariable QGVAR(correctCuts));
private _buttonClassName = ctrlClassName _controlClicked;
private _dialog = (uiNameSpace getVariable "PCB");
private _ied = (_dialog getVariable QGVAR(ied));
private _previousWiresCut = (_ied getVariable [QGVAR(cutWires),[]]);
private _defused = _ied getVariable [QGVAR(defused),false];

//Prevent disabled controls from reactiong to clicks
if (!ctrlEnabled _controlClicked) exitWith {};
_controlClicked ctrlEnable false;

//Get the wire control object.
private _controlWireIDC = (_lookUpArray find _buttonClassName);
private _controlWire = (_dialog displayCtrl _controlWireIDC);

//Store the controlwireIDC
_previousWiresCut pushBack _controlWireIDC;
_ied setVariable [QGVAR(cutWires),_previousWiresCut];

//Cut the wire: Set the wire control opacity to 0.
playSound QGVAR(sounds_cut);
_controlWire ctrlSetTextColor [1, 1, 1, 0];

//Check if cutting this wire was a legal move, if not, trigger the IED.
if (_defused) exitWith {};
if (_buttonClassName in _correctCuts) then {_ied setVariable [QGVAR(defused),true];} else {
    closeDialog 2;
    [_ied] call FUNC(detonateIED);
};
