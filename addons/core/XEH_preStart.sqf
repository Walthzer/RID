#include "script_component.hpp"

#include "XEH_PREP.hpp"

//Cache listbox items for compatible classes from CfgAmmo for use in IED creation.
private _cachedIEDItems = [];
private _ammoRemoteTrigger = QUOTE(getText (_x >> 'mineTrigger') isEqualTo 'RemoteTrigger') configClasses (configFile >> "CfgAmmo");

private _modPicturesMap = createHashMap;

//Prevent Duplicated Models or Base classes from being cached.
private _models = [''];
{
    private _index = _models pushBackUnique (getText (_x >> 'model'));

    //rid_forceUseAsIED override duplicate models prevention.
    if !(_index > -1 || {(getNumber (_x >> QGVARMAIN(forceUseAsIED))) > 0}) then {continue};
    
    //IED object name and picture etc.. can only be retrieved from the CfgMagazine class that accompanies the CfgAmmo class.
    private _magazineClass = configfile >> "CfgMagazines" >> (getText (_x >> "defaultMagazine"));
    private _displayName = getText (_magazineClass >> "displayName");

    //Skip classes not meant to be accesed by players (e.g. zeus lightning bolt).
    if (_displayName isEqualTo "") then {continue};

    //get Mod picture.
    private _modName = configSourceMod _x;
    private _modPicture = "";

    //Use the modPictures map to prevent duplicated usage of modParams.
    if (_modName in _modPicturesMap) then {
        _modPicture = _modPicturesMap get _modName;
    } else {
        _modPicture = (modParams [_modName, ["picture"]]) select 0;
        _modPicturesMap set [_modName, _modPicture];
    };

    _cachedIEDItems pushBack [_displayName, configName _x, getText (_magazineClass >> "picture"), _modPicture];

} forEach _ammoRemoteTrigger;

uiNamespace setVariable [QGVAR(cachedIEDItems), _cachedIEDItems];