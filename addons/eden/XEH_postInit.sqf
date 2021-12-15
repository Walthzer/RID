#include "script_component.hpp"

if (isServer) then {
    private _edenConnections = call FUNC(getStoredConnections);

    if (IS_ARRAY(_edenConnections) && {count _edenConnections > 0}) then {
        private _customConnectionsClasses = call FUNC(getCustomConnectionClasses);
        {
            _x params ["_type", "_fromID", "_toID"];

            private _OnScenarioStartCode = ((_customConnectionsClasses select {(_x select 0) == _type}) select 0) select 1;
            [[_fromID] call FUNC(getObjectByID), [_toID] call FUNC(getObjectByID)] call _OnScenarioStartCode;
        } forEach _edenConnections;
    };
};
