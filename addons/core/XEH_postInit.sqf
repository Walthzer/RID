#include "script_component.hpp"
#include "ArchillesModules.hpp"
#include "ZENModules.hpp"

if (isServer) then {
    [QGVAR(createPressurePlate), {
    params["_object", "_threshold"];
        [_object, _threshold] call FUNC(createPressurePlate);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(createVibrationDetector), {
        params["_object", "_isIED"];
        [_object, _isIED] call FUNC(createVibrationDetector);
    }] call CBA_fnc_addEventHandler;
};

[QGVAR(fixVector), {
    params["_wire", "_vector"];
    if (isNull _wire || {!alive _wire}) exitWith {};
    _wire setVectorDir _vector;
}] call CBA_fnc_addEventHandler;

if (hasInterface) then {
    [QGVAR(addIEDActions), {
        params["_ied"];

        private _mainCondition = [{true}, {[_target] call FUNC(validVirtualIEDCompanionExists)}] select ((typeOf _ied) == "rid_virtualIED");

        private _action = ["Main","","", {},_mainCondition, {}, [], [0,0,0], 1] call ACE_FUNC(interact_menu,createAction);
        [_ied, 0, [], _action] call ACE_FUNC(interact_menu,addActionToObject);

        _action = ["Defuse",LLSTRING(Defuse),"z\ace\addons\explosives\UI\Defuse_ca.paa",{[_target] call FUNC(displayDefusePCB)},{[_player] call FUNC(canDefuse)}, {}, [], [0,0,0], 2] call ACE_FUNC(interact_menu,createAction);
        [_ied, 0, ["Main"], _action] call ACE_FUNC(interact_menu,addActionToObject);

        _action = ["Dig_up",LLSTRING(DigUp),"",{[_target] call FUNC(digUpIED)},{[_player, "ACE_EntrenchingTool"] call FUNC(hasTool)}, {}, [], [0,0,0], 2] call ACE_FUNC(interact_menu,createAction);
        [_ied, 0, ["Main"], _action] call ACE_FUNC(interact_menu,addActionToObject);
    }] call CBA_fnc_addEventHandler;
};


