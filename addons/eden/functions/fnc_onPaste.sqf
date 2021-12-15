#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Code that needs to be executed onPaste in EDEN.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * onPaste = QUOTE(call rid_eden_fnc_onPaste);
 *
 * Public: [No]
 */

private _pastedConnections = uiNamespace getVariable [QGVAR(copiedCustomConnections), []];
private _pastedEntities = flatten (get3DENSelected "");

diag_log _pastedEntities;

private _entitiesAttributeID = _pastedEntities apply {[_x] call FUNC(getEntityID)};

diag_log _entitiesAttributeID;

if (_pastedConnections isNotEqualTo []) exitWith {
	["RID Pasted Connections"] collect3DENHistory {
		{
			diag_log _x;
			_x params ["_connectionType", "_fromID", "_toID"];

			private _fromIndex = _entitiesAttributeID find _fromID;
			private _toIndex = _entitiesAttributeID find _toId;

			if (_fromIndex < 0 || {_toIndex < 0}) then {continue};

			private _fromObject = _pastedEntities select _fromIndex;
			private _toObject = _pastedEntities select _toIndex;

			if (IS_OBJECT(_fromObject) && {IS_OBJECT(_toObject)}) then {
				add3DENConnection [_connectionType, [_fromObject], _toObject];
			};
		} forEach _pastedConnections;
	};
};




