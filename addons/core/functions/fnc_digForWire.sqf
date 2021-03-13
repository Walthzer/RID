#include "script_component.hpp"
/*
 * Create a dirt hump for a "digging effect" and put a wire in it if there is a buried network link nearby
 * 
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_this select 0] call rid_core_fnc_digForWire;
 *
 * Public: [No]
*/
params["_player"];

private _fnc_digCompleted = {
    (_this select 0) params ["_player", "_playerAnimation"];
    private _digPos = getPosATL _player;
    _digPos set [2,0];

    createVehicle ["rid_dirt", [_digPos select 0,_digPos select 1, -0.0225], [], 0, "CAN_COLLIDE"];

    private _wireHelper = nearestObject[_digPos, "rid_wireHelper"];
    if(!(_wireHelper isEqualTo objNull) && {(_wireHelper distance2D _digPos) <= 1}) then {
        private _wire = createVehicle ["rid_commandWireComplete", _digPos, [], 0, "CAN_COLLIDE"];
        private _cableParent = _wireHelper getVariable [QEGVAR(network,cableParent), objNull];
        _wire setVariable [QEGVAR(network,cableParent), _cableParent, true];
        deleteVehicle _wireHelper;
    };
    [_player, _playerAnimation, 1] call ace_common_fnc_doAnimation;

};

[6, [_player, (animationState _player)], _fnc_digCompleted, {[_this select 0 select 0, _this select 0 select 1, 1] call ace_common_fnc_doAnimation}, "Diggy Diggy"] call ace_common_fnc_progressBar;
[_player, "AinvPknlMstpSnonWnonDnon_medic4"] call ace_common_fnc_doAnimation;
