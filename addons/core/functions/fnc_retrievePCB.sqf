#include "script_component.hpp"
/*
 * Select a PCB with a certain difficulty, amount of wires and trigger types from those defined in the rid_pcbs config class.
 * Then return the dialog required to display the pcb, the path to the traces.paa to complete the dialog and the array containing the cuts to make for a succesful defuse
 * 
 * Arguments:
 * Defuse Difficulty <"ACE" - ACE standard "standard" - PCB Standard "difficult" - PCB Difficult> (STRING)
 * Trigger types <INT - internal EXT - external INT+EXT - internal and external> (STRING)
 * Amount of wires <3 - 4> (NUMBER)
 *
 * Return Value:
 * [[CUTS],"config_dialog_class","path\traces.paa"]
 *
 * Example:
 * ["standard","INT",3] call rid_core_fnc_retrievePCB
 *
*/
params["_difficulty","_trigger","_wires"];

//DEBUG
_difficulty = "standard";
_trigger = "INT";
_wires = 3;

//Verify Arguments
//ACE defuse doesn't need a PCB
if (_difficulty == "ACE") exitWith {}; 
//Fix _wires if above or below 4 and 3
if (_wires <= 3) then {_wires = 3} else {_wires = 4};

//Validate _trigger value
if (!(switch (_trigger) do { 

    case 0;
    case "INT": { _trigger = "INT"; true };
    
    case 1;
    case "EXT": { _trigger = "EXT"; true };
    
    case 2;
    case "INT+EXT": { _trigger = "INT+EXT"; true }; 
    
})) exitWith { ERROR("Trigger type invalid")};

//Prepare config acces
private _ridClass = getMissionConfig QGVAR(pcbs);
private _pcbConfig = (_ridClass >> _difficulty >> _trigger >> "wires" >> (str _wires));

//Retrieve config variables
Private _dialog = getText (_pcbConfig >> "dialog");
private _prefix = getText (_pcbConfig >> "prefix");
private _lookUpArray = getArray (_pcbConfig >> "lookUpArray");
private _lastClass = getNumber (_pcbConfig >> "lastClass");

//Select a random Class
private _classToSelect = str (floor random (_lastClass + 1));
private _correctCuts = getArray (_pcbConfig >> _classToSelect >> "correctCuts");

//Generate path to traces.paa for selected class
private _tracesPath = ([_prefix,_classToSelect,"traces.paa"] joinString "\");

[_lookUpArray,_correctCuts, _dialog, _tracesPath];