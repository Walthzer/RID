#include "script_component.hpp"
/*
 * Checks if a certain detonator can detonate given IED.
 * 
 * Arguments:
 * 0: IED <OBJECT>
 * 1: Trigger <STRING>
 *
 * Return Value:
 * Detonation succes <BOOLEAN>
 *
 * Example:
 * [_ied,[rid_pcb_hasPower, rid_pcb_hasDetonator]] call rid_core_fnc_tryDetonateIED
 *
 * Public: [Yes]
*/
params["_ied","_requiredArr"];

private _pcb = _ied getVariable[QEGVAR(pcb,pcb), []];

private _detonate = true;
{
    if(!(_x in (_pcb select 1))) exitWith {_detonate = false};
} forEach _requiredArr;
if(_detonate) exitWith {
    _ied call FUNC(detonateIED);
    true;
};
false;