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
        [_ied] call FUNC(addIEDActions);
    }] call CBA_fnc_addEventHandler;
};


