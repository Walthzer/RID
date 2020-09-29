#include "script_component.hpp"
#include "ArchillesModules.hpp"
#include "ZENModules.hpp"

[QGVAR(fixVector), {
    params["_wire", "_vector"];
    if (isNull _wire || {!alive _wire}) exitWith {};
    _wire setVectorDir _vector;
}] call CBA_fnc_addEventHandler;