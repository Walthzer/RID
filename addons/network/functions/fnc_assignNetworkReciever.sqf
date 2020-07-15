#include "script_component.hpp"
/*
 * Turn a Network Node into a Network Reciever. Storing a function to be called when a Network Caller processes the node.
 *
 * Arguments:
 * 0: Network Node (OBJECT)
 * 1: <FUNCTION or CODE> to call
 * 2: arguments (ARRAY)
 *
 * Return Value:
 * None
 *
 * Example:
 * [_ied, rid_fnc_detonateIED] call rid_network_fnc_assignNetworkReciever;
 *
*/
params[["_node", objNull, [objNull]],["_function", {}, [{}]],["_arguments", [], []]];

//Confirm _node is not null
if (isNull _node) exitWith {ERROR_1("%1 is not an OBJECT")};
//Confirm _function is not empty
if (_function isEqualTo {}) exitWith {ERROR_1("%1 is not a valid function")};

if (not (_node getVariable[QGVAR(isNetworkNode), false])) then {[_node] call FUNC(createNetworkNode);};

_node setVariable[QGVAR(NetworkReciever), [_function, _arguments]];