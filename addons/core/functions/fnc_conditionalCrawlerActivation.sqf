#include "script_component.hpp"
/*
 * Check if the node is "rid_core_isConnected" and crawl the network accordingly.
 * 
 * Arguments:
 * 0: Network node (OBJECT)
 *
 * Return Value:
 * None
 *
 * Example:
 * [145854:Empty.p3d] spawn rid_core_fnc_conditionalCrawlerActivation;
 *
*/
params[["_node", objNull, [objNull]]];
TRACE_1("conditionalCrawlerActivation",_node);

if (isNull _node) exitWith {ERROR_1("%1 is not an OBJECT", _node)};

if (not (_node getVariable[QEGVAR(network,isNetworkNode), false])) exitWith {WARNING_1("%1 is not a Network Node", _node)};

if (_node getVariable[QGVAR(isConnected), false]) then {
    [_node] call EFUNC(network,activateNetworkCrawler);
};