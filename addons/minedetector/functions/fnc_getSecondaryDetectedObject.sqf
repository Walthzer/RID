#include "script_component.hpp"
params ["_unit", "_primaryObject", "_primaryIsCW"];

(_unit getVariable [QGVAR(detectorConfig), [null, 2.5]]) params ["", "_radius"];

//Utilize ACE code to retrieve a reference point of the detector head. 
private _worldPosition = _unit modelToWorld (_unit selectionPosition "granat");
private _ref = (_unit weaponDirection currentWeapon _unit) call ace_common_fnc_createOrthonormalReference;
_ref params ["_v1", "_v2", "_v3"];
private _detectorPointAGL = _worldPosition vectorAdd
                                (_v1 vectorMultiply ( 0.9 * __DR)) vectorAdd
                                (_v2 vectorMultiply (-0.2 * __DR)) vectorAdd
                                (_v3 vectorMultiply ( 0.4 * __DR));

private _nearestObjects = nearestObjects [_detectorPointAGL, [], _radius];

//Modified ACE code to only consider objects of a diffrent "detectionType" as vaild.
private _isDetectable = false;
private _secondaryObject = objNull;
private _secondaryIsCW = false;
private _distance = -1;

{
    private _secondaryObjectType = typeOf _x;
	_secondaryIsCW = isNumber (configFile >> "CfgAmmo" >> _secondaryObjectType >> "isCW");
	private _isValidObject = ((_primaryIsCW || _secondaryIsCW) && !(_primaryIsCW && _secondaryIsCW));
	
    _isDetectable = ace_minedetector_detectableClasses getVariable _secondaryObjectType;
    if (isNil "_isDetectable" || {(getModelInfo _x) select 0 == "empty.p3d"}) then {
        _isDetectable = false;
    };

    // If a nun-null object was detected exit the search
    if (_isDetectable && _isValidObject && {!isNull _x}) exitWith {
        _distance = _detectorPointAGL distance _x;
        _secondaryObject = _x;
    };
} forEach _nearestObjects;

[_secondaryObject, _secondaryIsCW, _distance];