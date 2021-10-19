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
TRACE_1("activateNetworkCrawler",_node);

if (isNull _node) exitWith {ERROR_1("%1 is not an OBJECT", _node)};

if (not ([_node] call FUNC(isNetworkNode))) exitWith {ERROR_1("%1 is not a Network Node", _node)};

//Prevent companionless virtualIEDs from being functional network components.
if (TypeOf _node == "rid_virtualIED" && {not ([_node] call EFUNC(core,validVirtualIEDCompanionExists))}) exitWith {
    deleteVehicle _node;
};

private _nodeNetworkConnections = _node getVariable [QGVAR(networkConnections), []];
if (count _nodeNetworkConnections == 0) exitWith {INFO_1("%1 has no Network Connections", _node)};

private _checkedNetworkComponents = [];

//Evaluate an array of Network components and create an array from their Network Connections
//If the Network component is a signal reciever, execute it's reciever code.
private _fnc_retrieveNetworkConnections = {
    params["_networkComponents"];
    private _networkConnections = [];
    {
        private _networkComponent = _x;
        if (isNull _networkComponent || {!alive _networkComponent}) then {
        } else {
            if (_networkComponent getVariable[QGVAR(isNetworkNode), false]) then {
                //Prevent companionless virtualIEDs from being functional network components.
                if (TypeOf _networkComponent == "rid_virtualIED" && {not ([_networkComponent] call EFUNC(core,validVirtualIEDCompanionExists))}) exitWith {
                    deleteVehicle _networkComponent;
                    continue;
                };
                private _nodeNetworkReciever = _networkComponent getVariable[QGVAR(NetworkReciever), []];
                if (count _nodeNetworkReciever > 0) then {
                    _nodeNetworkReciever params [["_function", {}, [{}]],["_arguments", [], []]];
                    if(count _arguments > 0) then {
                        [_networkComponent, _arguments] call _function;
                    } else {
                        [_networkComponent] call _function;
                    };
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