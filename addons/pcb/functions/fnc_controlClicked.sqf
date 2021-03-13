#include "script_component.hpp"
/*
 * Process the click on a control in a PCB Dialog.
 * 
 * Arguments:
 * Control Clicked <CONTROL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_control] call rid_core_fnc_controlClicked
 *
*/
params["_controlClicked"];

//Prevent disabled controls from reactiong to clicks
if (!ctrlEnabled _controlClicked) exitWith {};
_controlClicked ctrlEnable false;

//Prepare variables
private _ied = uiNamespace getVariable QGVAR(ied);
private _dialog = uiNamespace getVariable QGVAR(dialog);
private _pcb = _ied getVariable[QGVAR(pcb), []];

if(_pcb isEqualTo []) exitWith {ERROR("ControlClicked: bad argument(s)")};

(_pcb select 0) params ["_dialogClass", "_wires", "_wireDictionary", "_connectionsLeft"];

private _controlIDCwOffset = ctrlIDC _controlClicked;
private _controlIDC = _controlIDCwOffset - CTRLOFFSET;
private _connectionsLeftIndex = floor(_controlIDC / _wires);

//Cut the wire:
playSound QGVAR(sounds_cut);
(_dialog displayCtrl _controlIDC) ctrlSetTextColor [1, 1, 1, 0]; //TODO: FIX CTRL IDC OFFSET

_fnc_iedCircuitChanged = {
    params["_id", "_global_var"];
    if(!(_connectionsLeft select _connectionsLeftIndex == "")) then {
        _connectionsLeft set [_connectionsLeftIndex, ""];
        if(({_x == _id} count _connectionsLeft) == 0) then {
            _attributesArr set [_attributesArr find _global_var, ""];
        };
    };
};

//Process Wire Type
private _detonate = false;
private _attributesArr = _pcb select 1;
switch (_wireDictionary select _controlIDC) do {

    case "det": {["det", QGVAR(hasDetonator)] call _fnc_iedCircuitChanged};
    case "dec": {if(QGVAR(hasPower) in _attributesArr) then {_detonate = true}};
    case "bat": {if(QGVAR(lopDetection) in _attributesArr) then {
                    _detonate = true;
                    ["bat", QGVAR(hasPower)] call _fnc_iedCircuitChanged;
                    };
                };
    case "ext": {["ext", QGVAR(hasExternal)] call _fnc_iedCircuitChanged};
};
if(_detonate && {QGVAR(hasDetonator) in _attributesArr}) exitWith {_ied call EFUNC(core,detonateIED)};
_ied setVariable[QGVAR(pcb), [_pcb select 0, _attributesArr], true];

//Store the _controlIDC so next time we open the dialog we can hide the wire:
private _previousCutWires = (_ied getVariable [QGVAR(cutWires),[]]);
_previousCutWires pushBack _controlIDC;
_ied setVariable [QGVAR(cutWires),_previousCutWires, true];
