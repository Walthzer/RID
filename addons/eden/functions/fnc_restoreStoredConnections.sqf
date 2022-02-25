#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Restore passed custom Eden connections to visible Eden connections.
 *
 * Arguments:
 * 0: storedConnections <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call rid_eden_fnc_restoreStoredConnections;
 *
 * Public: [No]
 */
params["_connections"];
TRACE_1("restoreStoredConnections",_connections);

["RID Restore Connections"] collect3DENHistory {
    if (IS_ARRAY(_connections)) then {
        {
            _x params ["_connectionType", "_fromID", "_toID"];
            private _fromObject = get3DENEntity _fromID;
            private _toObject = get3DENEntity _toID;

            if (IS_OBJECT(_fromObject) && {IS_OBJECT(_toObject)}) then {
                add3DENConnection [_connectionType, [_fromObject], _toObject];
            };
        } forEach _connections;
    };
};