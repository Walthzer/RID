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

_fnc_execNewLinkCode = {
    params["_baseNode", "_connectionNode","_nodeIndex", ["_code", {}, []]];
    if(_nodeIndex > -1 and {!(_code isEqualTo {})}) then {
        [_baseNode, _connectionNode] call _code;
    };
};

if (not ((_node0 getVariable[QGVAR(isNetworkNode), false]) and (_node1 getVariable[QGVAR(isNetworkNode), false]))) exitWith {ERROR_2("%1 and %2 are not Network Nodes!", _node0, _node1)};

    _node0NetworkConnections = _node0 getVariable [QGVAR(networkConnections), []];
    _node1NetworkConnections = _node1 getVariable [QGVAR(networkConnections), []];
    
    _node0Index = _node0NetworkConnections pushBackUnique _node1;
    _node1Index = _node1NetworkConnections pushBackUnique _node0;
    
    _node0 setVariable [QGVAR(networkConnections), _node0NetworkConnections, true];
    _node1 setVariable [QGVAR(networkConnections), _node1NetworkConnections, true];

    [_node0, _node1, _node0Index, _node0 getVariable [QGVAR(onNewLinkCode), {}]] call _fnc_execNewLinkCode;
    [_node1, _node0, _node1Index, _node1 getVariable [QGVAR(onNewLinkCode), {}]] call _fnc_execNewLinkCode;


