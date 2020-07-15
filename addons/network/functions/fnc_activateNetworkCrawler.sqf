#include "script_component.hpp"
/*
 * Use the passed object to start activating all linked Network Nodes
 * 
 * Arguments:
 * 0: Network node (OBJECT)
 *
 * Return Value:
 * None
 *
 * Example:
 * [145854:Empty.p3d] spawn rid_network_fnc_activateNetworkCrawler;
 *
*/
params[["_node", objNull, [objNull]]];

//Confirm _node is an OBJECT
if (isNull _node) exitWith {ERROR_1("%1 is not an OBJECT", _node)};
//Confirm _node is a Network Node

if (not (_node getVariable[QGVAR(isNetworkNode), false])) exitWith {ERROR_1("%1 is not a Network Node", _node)};

//Retrieve node connections, stop script if it has non
private _nodeNetworkConnections = _node getVariable [QGVAR(networkConnections), []];
if (count _nodeNetworkConnections == 0) exitWith {ERROR_1("%1 has no Network Connections", _node)};

private _checkedNetworkComponents = [];

//Evaluate an array of Network components and create an array from their Network Connections
//If the Network component is a signal reciever, execute it's reciever code.
private _fnc_retrieveNetworkConnections = {
    params["_networkComponents"];
    private _networkConnections = [];
    {
        private _networkComponent = _x;
        if (isNull _networkComponent) then {
        } else {
            if (_networkComponent getVariable[QGVAR(isNetworkNode), false]) then {
                private _nodeNetworkReciever = _networkComponent getVariable[QGVAR(NetworkReciever), []];
                if (count _nodeNetworkReciever > 0) then {
                    _nodeNetworkReciever params [["_function", {}, [{}]],["_arguments", [], []]];
                    [_networkComponent, _arguments] call _function;
                };
            };
            _networkConnections append (_networkComponent getVariable [QGVAR(networkConnections), []]);    
        };
        _checkedNetworkComponents pushBackUnique _networkComponent;
    } forEach _networkComponents;
    private _networkConnectionsUnique = _networkConnections - _checkedNetworkComponents;
    _networkConnectionsUnique;
};

private _foundNetworkComponents = [];
_foundNetworkComponents append ([_nodeNetworkConnections] call _fnc_retrieveNetworkConnections);

while {count _foundNetworkComponents > 0} do {
_foundNetworkComponents = [_foundNetworkComponents] call _fnc_retrieveNetworkConnections;
};