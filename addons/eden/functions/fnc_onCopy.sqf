#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Code that needs to be executed onCopy in EDEN.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * OnCopy = QUOTE(call rid_eden_fnc_onCopy);
 *
 * Public: [No]
 */

//Object that got copied would still be selected
private _clipboardEntities = flatten (get3DENSelected "");

private _excludedObjects = [];
private _copiedConnections = [];
{
    private _entity = _x;
    private _connections = get3DENConnections _entity;
    if (_connections isEqualTo []) then {continue};
    
    //Not all connections are arrays e.g. GROUP
    private _customConnections = _connections select {IS_ARRAY(_x) && {(_x select 0) in ([true] call FUNC(getCustomConnectionClasses))}};
    if (_customConnections isEqualTo []) then {continue};

    private _entityID = [_entity] call FUNC(getEntityID);
    {
        _x params ["_type", "_toObject"];

        //Connections are detected both ways, we must cancel if we have processed the _toObject before or it wasn't copied.
        if (_toObject in _excludedObjects) then {continue};

        //toObject might not have been included in the copy operation.
        if (!(_toObject in _clipboardEntities)) then {_excludedObjects pushBack _toObject; continue};
         
         _copiedConnections pushBack [_type, _entityID, [_toObject] call FUNC(getEntityID)];

    } forEach _customConnections;

    _excludedObjects pushBack _entity;
} forEach _clipboardEntities;

uiNamespace setVariable [QGVAR(copiedCustomConnections), _copiedConnections];