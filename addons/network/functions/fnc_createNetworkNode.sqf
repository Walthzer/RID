#include "script_component.hpp"
/*
 * Create an empty network node at given position.
 * Or assign the given object network node status.
 *
 * Arguments:
 * 0: Position <ARRAY> for new node OR Object <OBJECT> to assign node status.
 *
 * Return Value:
 * Passed OBJECT or Created OBJECT;
 *
 * Example:
 * [[125,25,1]] call rid_network_fnc_createNetworkNode;
 *
 *Public: [Yes]
*/
params["_arg", ["_onNewLinkCode", {}, []],["_arguments", [], [[]]]];
TRACE_3("createNetworkNode",_arg,_onNewLinkCode,_arguments);

//Confirm if argument is either an ARRAY or OBJECT
if (not (IS_ARRAY(_arg) or IS_OBJECT(_arg))) exitWith {ERROR_1("%1 is not ARRAY nor OBJECT", _arg)};


//If argument is an ARRAY, create the empty object else use the argument as the empty object
private _object = if (IS_ARRAY(_arg)) then {
    private _node = "Helper_Base_F" createVehicle _arg;
    ["ace_zeus_addObjects", [[_node]]] call CBA_fnc_serverEvent;
    _node;
} else {
    _arg;
};

//set node status
_object setVariable[QGVAR(isNetworkNode), true, true];
if (!(_onNewLinkCode isEqualTo {})) then {
    _object setVariable[QGVAR(onNewLinkCode), [_onNewLinkCode, _arguments], true];
};
_object;