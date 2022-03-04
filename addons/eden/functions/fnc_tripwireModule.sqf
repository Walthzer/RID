#include "script_component.hpp"
/*
 * Author: Walthzer/Shark
 * Function for the rid_eden_tripwireModule.
 *
 * Arguments:
 * 0: Mode <STRING>
 * 1: Arguments dependant on Mode <ARRAY>
 *
 * Return Value:
 * true
 *
 * Example:
 * ["attributesChanged3DEN", _module] call rid_eden_fnc_tripwireModule
 *
 * Public: [No]
 */
params["_mode", "_args"];
TRACE_2("tripwireModule",_mode,_args);

switch _mode do {
    //Called before init, called from tripwireCreation attribute (see CfgVehicles) so we get acces to the attribute data.
    case "expression": {
        _args params ["_module", "_data"];

        _module setVariable [QGVAR(data), _data];
    };
    case "init": {
        _args params ["_module"];
        (_module getVariable [QGVAR(data), [-1,-1]]) params ["_nodeID0", "_nodeID1"];

        private _node0 = [_nodeID0] call FUNC(getObjectByID);
        private _node1 = [_nodeID1] call FUNC(getObjectByID);

        [_node0, _node1, _module] call EFUNC(core,createRIDTripwire);

        deleteVehicle _module;
    };
    //Called from preInit on Eden start
    case "edenStart": {
        _args params ["_module"];
        
        private _nodeIDs = _module get3DENAttribute QGVAR(tripwireCreation);
        private _tripwireNodes = (_nodeIDs select 0) apply {get3DENEntity _x};

        [_module, _tripwireNodes] call FUNC(tripwireModuleInitialize);
    };
    case "update": {
        _args params ["_module"];
        
        private _tripwireNodes = _module getVariable [QGVAR(nodes), []];
        [_module, _tripwireNodes, true] call FUNC(tripwireModuleCreateWire);
    };
    case "attributesChanged3DEN": {
        _args params ["_module"];

        private _centerPos = _module getVariable [QGVAR(centerPos), [0,0,0]];
        private _modulePos = getPosATL _module;

        if (_centerPos isEqualTo [0, 0, 0] || {(_centerPos select [0,2]) isEqualTo (_modulePos select [0,2])}) exitWith {};

        _centerPos set [2, _modulePos select 2];
        ["RID Correct Module Position"] collect3DENHistory {
            _module set3DENAttribute ["position", _centerPos];
        };
    };
    // When object is being dragged
    case "dragged3DEN": {
        _args params ["_module"];
        
        private _tripwireNodes = _module getVariable [QGVAR(nodes), []];
        [_module, _tripwireNodes, true] call FUNC(tripwireModuleCreateWire);
    };
    // When removed from the world (i.e., by deletion or undoing creation)
    case "unregisteredFromWorld3DEN": {
        _args params ["_module"];
        [_module] call FUNC(tripwireModuleRemoveWire);
    };
    case "registeredToWorld3DEN": {
        _args params ["_module"];

        private _nodeIDs = _module get3DENAttribute QGVAR(tripwireCreation);
        private _tripwireNodes = (_nodeIDs select 0) apply {get3DENEntity _x};

        _module setVariable [QGVAR(centerPos), (getPosATL _module)];
        _module setVariable [QGVAR(nodes), _tripwireNodes];

        [_module, _tripwireNodes] call FUNC(tripwireModuleCreateWire);
    };
};

true