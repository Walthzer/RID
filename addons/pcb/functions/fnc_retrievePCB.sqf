#include "script_component.hpp"
/*
 * Author: [Name of Author(s)]
 * Uses given arguments to select a suitable PCB.
 *
 * Arguments:
 * 0: IED <OBJECT>
 * 1: PCB Type <STRING>
 * 2: Wires <INTEGER>
 * 3: Trigger Type <STRING>
 *
 * Return Value:
 * PCB minigame <ARRAY>
 *
 * Example:
 *    ["standard", 3, "vib"] call rid_core_fnc_createIED
 *
 * Public: [Yes]
 */
params[["_ied", objNull, [objNull]], ["_pcbType", "", [""]], ["_wires", -1, [0]], ["_trigger", "", [""]]];

if (_pcbType isEqualTo "" || _wires isEqualTo -1 || _trigger isEqualTo "") exitWith {ERROR("CreateIED: Bad argument(s)")};

private _wiresID = format["%1W", _wires];

private _triggerGroup = configFile >> "rid_pcbs" >> _pcbType >> _wiresID >> _trigger;
private _triggerGroupSize = getArray (_triggerGroup >> "size");

private _triggerClass = _triggerGroup >> str selectRandom _triggerGroupSize;
private _triggerClassSize = getArray (_triggerClass >> "size");

private _dialogClassText = getText(_triggerClass >> "dialog");
private _dialogClass = configFile >> _dialogClassText;
private _pcbID = selectRandom _triggerClassSize;
private _traces = format["%1%2\traces.paa", getText(_dialogClass >> "prefix"), _pcbID];
private _wireDictionary = getArray(_dialogClass >> "wireDictionary" >> str _pcbID);

private _connectionsLeft = [];
{
    if (_forEachIndex / _wires == floor(_forEachIndex / _wires)) then {
        _connectionsLeft pushBack _x;
    };
} forEach _wireDictionary;

[[_dialogClassText, _wires, _wireDictionary, _connectionsLeft, _traces], getArray(_dialogClass >> "attributes")];