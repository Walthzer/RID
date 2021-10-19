#include "script_component.hpp"
/*
 * Create a link between two network components. 
 * Fysically represent this link if argument 2 is TRUE; 
 
 * Arguments:
 * 0: Node <OBJECT>
 * 1: Node <OBJECT>
 * 2: Spawn fysical cable? <BOOLEAN>
 *
 * Return Value:
 * None OR Fysical cable parent.
 *
 * Example:
 * [8481:Empty.p3d, 4852:IEDLandSmall_F.p3d] call rid_network_fnc_createNetworkLink;
 *
*/
params["_node0", "_node1", "_createCable"];


if (not (IS_OBJECT(_node0) and IS_OBJECT(_node1))) exitWith {ERROR_2("%1 and %2 are not objects!", _node0, _node1)};
if (not (([_node0] call FUNC(isNetworkNode))) and ([_node1] call FUNC(isNetworkNode))) exitWith {ERROR_2("%1 and %2 are not Network Nodes!", _node0, _node1)};

if([_node0] call EFUNC(core,isCfgAmmoInstance)) then {
    _node0 = [_node0] call EFUNC(core,getVirtualIEDFromCompanion);
};

if([_node1] call EFUNC(core,isCfgAmmoInstance)) then {
    _node1 = [_node1] call EFUNC(core,getVirtualIEDFromCompanion);
};


private _nodes = if (_createCable) then {
    [_node0, _node1] call FUNC(createWire);
} else {
    [_node0, _node1];
};

_fnc_execNewLinkCode = {
    params["_baseNode", "_connectionNode","_nodeIndex", "_this"];
    params[["_code", {}, []],["_arguments", [], [[]]]];
    if(!(_code isEqualTo {})) then {
        [_baseNode, _connectionNode, _arguments] call _code;
    };
};

private _lastIndex = (count _nodes) - 1;
{
    if(_forEachIndex == _lastIndex) exitWith {};
    private _followingNode = _nodes select (_forEachIndex + 1);

    private _nodeXNetworkConnections = _x getVariable [QGVAR(networkConnections), []];
    private _followingNodeNetworkConnections = _followingNode getVariable [QGVAR(networkConnections), []];
    
    private _nodeXIndex = _nodeXNetworkConnections pushBackUnique _followingNode;
    private _followingNodeIndex = _followingNodeNetworkConnections pushBackUnique _x;
    
    if (_nodeXIndex > -1) then {
        _x setVariable [QGVAR(networkConnections), _nodeXNetworkConnections, true];
        [_x, _followingNode, _nodeXIndex, _x getVariable [QGVAR(onNewLinkCode), {}]] call _fnc_execNewLinkCode;
    };
    
    if (_followingNodeIndex > -1) then {
        _followingNode setVariable [QGVAR(networkConnections), _followingNodeNetworkConnections, true];
        [_followingNode, _x, _followingNodeIndex, _followingNode getVariable [QGVAR(onNewLinkCode), {}]] call _fnc_execNewLinkCode;
    };

} foreach _nodes;

