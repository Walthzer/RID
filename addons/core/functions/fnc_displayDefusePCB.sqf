#include "script_component.hpp"
/*
* Author: Walthzer/Shark
* display the PCB assigned to an IED for defusal
*
* Arguments:
* 0: IED <OBJECT>
*
* Return Value:
* None
*
* Example:
* [_ied] call rid_core_fnc_displayDefusePCB
*
* Public: [No]
*/
params["_ied"];
TRACE_1("Function start",_ied);
private _pcb = _ied getVariable [QEGVAR(pcb,pcb), [] ];

if(_pcb isEqualTo []) exitWith {
    systemChat LLSTRING(NothingToDefuse);
};
uiNamespace setVariable[QEGVAR(pcb,ied), _ied];
createDialog (_pcb select 0 select 0);
_dialog = findDisplay 3300;
//Show previously cuts wires as such.
{
    (_dialog displayCtrl _x) ctrlSetTextColor [1, 1, 1, 0];
    (_dialog displayCtrl _x) ctrlEnable false;
} forEach  (_ied getVariable [QEGVAR(pcb,cutWires), [] ]);
//Assign the path to the traces.paa selected.
ctrlSetText [1894, (_pcb select 0 select 4)];

