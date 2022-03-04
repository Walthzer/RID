#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(excludedMines) = [];

//CBA SETTINGS
private _category = "RID";
[
    QGVAR(requireSpecialist),
    "CHECKBOX",
    [LLSTRING(RequireExplosivesSpecialist_DisplayName),LLSTRING(RequireExplosivesSpecialist_Description)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requireEngineer),
    "CHECKBOX",
    [LLSTRING(RequireEngineer_DisplayName),LLSTRING(RequireEngineer_Description)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

ADDON = true;