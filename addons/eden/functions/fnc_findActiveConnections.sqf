#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Return all active custom Eden Connections
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: connections <ARRAY>
 *
 * Example:
 * [] call rid_eden_fnc_findActiveConnections;
 *
 * Public: [No]
 */
private _processedObjects = [];
private _foundConnections = [];
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
        //Connections are detected both ways, if we have processed the _toObject we must cancel to prevent duplicated connections.
        if (_toObject in _processedObjects) then {continue};
        
        _foundConnections pushBack [_type, _entityID, [_toObject] call FUNC(getEntityID)];

    } forEach _customConnections;

    _entity set3DENAttribute [QGVAR(objectID), _entityID];
    _processedObjects pushBack _entity;
} forEach (flatten all3DENEntities);

_foundConnections