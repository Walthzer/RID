#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

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

[
    QGVAR(useNonStaticIED),
    "CHECKBOX",
    [LLSTRING(useNonStaticIED_Displayname), LLSTRING(useNonStaticIED_Description)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

//Cache Compatible Classes from CfgAmmo for use in IED creation.
if (isNil QGVAR(IEDCompatibleAmmoCache)) then {
    GVAR(IEDCompatibleAmmoCache) = [];
    private _ammoRemoteTrigger = "getText (_x >> 'mineTrigger') isEqualTo 'RemoteTrigger'" configClasses (configFile >> "CfgAmmo");
    
    //Prevent Duplicated Models or Base classes from being cached. rid_forceUseAsIED overrides this.
    private _models = [''];
    {
        private _index = _models pushBackUnique (getText (_x >> 'model'));
        if (_index > -1 || {(getNumber (_x >> QGVARMAIN(forceUseAsIED))) > 0}) then {
            GVAR(IEDCompatibleAmmoCache) pushBack _x;
        };

    } forEach _ammoRemoteTrigger;
};

ADDON = true;