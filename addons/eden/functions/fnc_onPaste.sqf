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
private _pastedEntities = flatten (get3DENSelected "");
private _entitiesAttributeID = _pastedEntities apply {[_x] call FUNC(getEntityID)};
TRACE_2("onPaste",_pastedEntities,_entitiesAttributeID);

["RID Process Pasting"] collect3DENHistory {

    //Add copied connections
    private _pastedConnections = uiNamespace getVariable [QGVAR(copiedCustomConnections), []];
    {
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

    //Update copied Tripwires
    private _tripwireModules = (flatten (get3DENSelected "logic")) select {(typeOf _x) == QGVAR(tripwireModule)};
    {
        private _module = _x;
        ((_module get3DENAttribute QGVAR(tripwireCreation)) select 0) params ["_nodeID0", "_nodeID1"];
        
        private _index0 = _entitiesAttributeID find _nodeID0;
        private _index1 = _entitiesAttributeID find _nodeID1;

        TRACE_3("attrubteIDs",_module,_nodeID0,_nodeID1);

        if (_index0 < 0 || {_index1 < 0}) then {continue};

        private _node0 = _pastedEntities select _index0;
        private _node1 = _pastedEntities select _index1;
        
        TRACE_2("nodes",_node0,_node1);

        if !(IS_OBJECT(_node0) && {IS_OBJECT(_node1)}) then {continue};

        _module set3DENAttribute [QGVAR(tripwireCreation), [get3DENEntityID _node0, get3DENEntityID _node1]];

        private _tripwireNodes = [_node0, _node1];
        [_module, _tripwireNodes] call FUNC(tripwireModuleInitialize);
    } forEach _tripwireModules;

    //Updated cached objectID's
    {
        _x set3DENAttribute [QGVAR(objectID), get3DENEntityID _x];
    } forEach _pastedEntities;
};




