#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Code that needs to be executed OnConnectingEnd in EDEN.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [_connectionClass, _fromEntity _toEntity ] call rid_eden_fnc_onConnectingEnd;
 *
 * Public: [No]
 */
params ["_connectionClassname", "_fromEntities", "_toEntity"];
TRACE_3("onConnectingEnd",_connectionClassname,_fromEntities,_toEntity);

//stop execution if connection was canceled or the classname doesn't match a custom class.
if (isNil "_toEntity" || {!([_connectionClassname] call FUNC(isCustomConnectionClass))}) exitWith {};

//Run connections OnConnect code.
private _customConnectionsClasses = [false] call FUNC(getCustomConnectionClasses);

private _onConnectCode = ((_customConnectionsClasses select {(_x select 0) == _connectionClassname}) select 0) select 2;
if (_onConnectCode isNotEqualTo {}) then {[flatten _fromEntities, _toEntity] call _onConnectCode};

//Store object ID in attribute, see rid_eden_fnc_onPaste
{
    _x set3DENAttribute [QGVAR(objectID), get3DENEntityID _x];
} forEach (flatten [_fromEntities, _toEntity]);
