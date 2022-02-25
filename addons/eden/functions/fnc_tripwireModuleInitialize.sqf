#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Initial setup for a tripwireModule.
 *
 * Arguments:
 * 0: tripwireModule <OBJECT>
 * 1: List of Nodes <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_module, _nodes] call rid_eden_fnc_tripwireModuleInitialize;
 *
 * Public: [No]
 */
params ["_module", "_nodes"];
TRACE_2("tripwireModuleInitialize",_module,_nodes);
{
    private _tripwireModules = _x getVariable [QGVAR(tripwireModules), []];
    _tripwireModules pushBack _module;

    _x setVariable [QGVAR(tripwireModules), _tripwireModules];
    _x set3DENAttribute [QGVAR(objectID), get3DENEntityID _x];

    private _ehIDs = _x getVariable [QGVAR(tripwireEHs), []];
    if (_ehIDs isEqualTo []) then {
        private _draggedID = _x addEventHandler ["Dragged3DEN", {
            params ["_entity"];

            //Update all tripwires
            private _tripwireModules = _entity getVariable [QGVAR(tripwireModules), []];

            {
                //Skip module if it was unregisterd
                if !(_x in (all3DENEntities select 3)) then {continue};

                ["update", [_x]] call FUNC(tripwireModule);
            } forEach _tripwireModules;
        }];

        private _attributesID = _x addEventHandler ["attributesChanged3DEN", {
            params ["_entity"];

            //Update all tripwires
            private _tripwireModules = _entity getVariable [QGVAR(tripwireModules), []];

            ["RID Update Tripwires"] collect3DENHistory {
                {
                    //Skip module if it was unregisterd
                    if !(_x in (all3DENEntities select 3)) then {continue};

                    private _tripwireNodes = _x getVariable [QGVAR(nodes), []];
                    private _newPosition = [_tripwireNodes] call FUNC(calculateObjectsCenter);
                    _newPosition set [2, (getPosATL _x) select 2];

                    _x setVariable [QGVAR(centerPos), _newPosition];
                    _x set3DENAttribute ["position", _newPosition];
                } forEach _tripwireModules;
            };
        }];

        _x setVariable [QGVAR(tripwireEHs), [_draggedID, _attributesID]];
    };

} forEach _nodes;

_module set3DENAttribute [QGVAR(tripwireCreation), _nodes apply {get3DENEntityID _x}];

_module setVariable [QGVAR(centerPos), (getPosATL _module)];
_module setVariable [QGVAR(nodes), _nodes];

[_module, _nodes] call FUNC(tripwireModuleCreateWire);