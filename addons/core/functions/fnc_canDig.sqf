#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Check if a unit can dig.
 *
 * Arguments:
 * 0: Unit <Object>
 *
 * Return Value:
 * canDig <BOOLEAN>
 *
 * Example:
 * [ACE_player] call rid_core_fnc_canDig
 *
 * Public: [Yes]
 */
params[["_unit", objNull, [objNull]]];

if (vehicle _unit != _unit || {!([_unit, "ACE_EntrenchingTool"] call FUNC(hasTool))}) exitWith {TRACE_2("Unit can Dig?",_unit,false); false};

if (GVAR(requireEngineer) && {!([_unit] call ACE_FUNC(common,isEngineer))}) exitWith {TRACE_2("Unit can Dig?",_unit,false); false};
TRACE_2("Unit can Dig?",_unit,true);
true;