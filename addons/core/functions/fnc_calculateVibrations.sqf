#include "script_component.hpp"
/*
 * Calculate the vibrations created by every object in a trigger's area
 * 
 * Arguments:
 * 0: Trigger (OBJECT)
 * 1: Objects to calculate vibrations of (ARRAY)
 *
 * Return Value:
 * None
 *
 * Example:
 * [thisTrigger, thisList] call rid_core_fnc_calculateVibrations;
 *
*/
params["_thisTrigger", "_thisList"];

//Confirm _thisTrigger is an OBJECT
if (not (IS_OBJECT(_thisTrigger))) exitWith {ERROR_1("%1 is not a TRIGGER", _object)};

//Confirm _thisList is an ARRAY
if (not (IS_ARRAY(_thisList))) exitWith {ERROR_1("%1 is not a ARRAY", _threshold)};

private _vibrationDetectorObject = _thisTrigger getVariable [QGVAR(vibrationDetectorObject), objNull];
    
private _maxVibrations = _thisTrigger getVariable [QGVAR(maxVibrations), 100];

private _manTransition = 17;
private _manCutOff = 50;


private _landVehicleTransition = 17;
private _landVehicleCutOff = 50;



private _fnc_manVibration = {
    params["_distance"];
    private _return = 0;
    
    if(_distance < _manTransition) then {
        _return = (2 ^ ((-_distance / 1.8) + 3.32))/10;
    } else {
        if (_distance < _manCutOff) then {
            _return = ((2 ^ ((-_manTransition / 1.8) + 3.32 - 0)) / (_manTransition - _manCutOff) * (_distance - _manCutOff))/10;
        };
    };
    _return;
};

private _fnc_landVehicleVibration = {
    params["_distance"];
    private _return = 0;
    
    if(_distance < _landVehicleTransition) then {
        _return = (2 ^ ((-_distance / 1.2) + 3.32)) / 100;
    } else {
        if (_distance < _landVehicleCutOff) then {
            _return = ((2 ^ ((-_landVehicleTransition / 1.2) + 3.32 - 0)) / (_landVehicleTransition - _landVehicleCutOff) * (_distance - _landVehicleCutOff)) /100;
        };
    };
    _return;
};

private _vibrations = 0;
{    
    
    private _objectClass = typeOf _x;
    private _objectMass = 0;
    private _objectVibrations = 0;
    private _distanceToObject = _x distance _thisTrigger;
    
    if(_x isKindOf "Man") then {
        private _unitInventoryMass = parseNumber ((loadAbs _x) * 0.453592 / 10 toFixed 2);
        _objectMass = _unitInventoryMass + getNumber ( configFile >> "CfgVehicles" >> _objectClass >> "weight");
        _objectVibrations = (_objectMass * abs(selectMax (velocityModelSpace _x))) * ([_distanceToObject] call _fnc_manVibration);
    };
    
    if(_x isKindOf "LandVehicle") then {
        _objectMass = getMass _x;
        _objectVibrations = (_objectMass * (3.6 * abs(selectMax (velocityModelSpace _x)))) * ([_distanceToObject] call _fnc_landVehicleVibration);
    };
    
    _vibrations = _vibrations + _objectVibrations;
} forEach _thisList;
if (_vibrations > _maxVibrations) exitWith {
    true;
};
false;