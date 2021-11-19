#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Check if a unit can defuse an IED
 *
 * Arguments:
 * 0: Unit <Object>
 *
 * Return Value:
 * canDefuse <BOOLEAN>
 *
 * Example:
 * [ACE_player] call rid_core_fnc_canDefuse
 *
 * Public: [Yes]
 */
params[["_unit", objNull, [objNull]]];

if (vehicle _unit != _unit || {!([_unit, "ACE_DefusalKit"] call FUNC(hasTool))}) exitWith {TRACE_2("Unit can Defuse?",_unit,false); false};
if (rid_RequireSpecialist && {!([_unit] call ACE_FUNC(common,isEOD))}) exitWith {TRACE_2("Unit can Defuse?",_unit,false); false};
TRACE_2("Unit can Defuse?",_unit,true);
true;