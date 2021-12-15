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

//stop execution if connection was canceled or the classname doesn't match a custom class.
if (isNil "_toEntity" || {!([_connectionClassname] call FUNC(isCustomConnectionClass))}) exitWith {};

//Store object ID in attribute, see rid_eden_fnc_onPaste
{
    _x set3DENAttribute [QGVAR(objectID), get3DENEntityID _x];
    
} forEach (flatten [_fromEntities, _toEntity]);
