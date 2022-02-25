#include "script_component.hpp"
/*
 * Calculated the Mass of every object in a trigger's area
 * 
 * Arguments:
 * 0: Trigger (OBJECT)
 * 1: Objects to calculate vibrations of (ARRAY)
 *
 * Return Value:
 * None
 *
 * Example:
 * [thisTrigger, thisList] call rid_fnc_calculatePressure;
 *
*/
params["_thisTrigger", "_thisList"];

//Confirm _thisTrigger is an OBJECT
if (not (IS_OBJECT(_thisTrigger))) exitWith {ERROR_1("%1 is not a TRIGGER", _object);false;};

//Confirm _thisList is an ARRAY
if (not (IS_ARRAY(_thisList))) exitWith {ERROR_1("%1 is not a ARRAY", _threshold);false;};

private _maxMass = _thisTrigger getVariable [QGVAR(maxMass), 110];
private _massOnPlate = 0;
{    
    private _objectMass = 0;
    if(_x isKindOf "Man") then {
        private _unitInventoryMass = parseNumber ((loadAbs _x) * 0.453592 / 10 toFixed 2);
        private _objectClass = typeOf _x;
        _objectMass = _unitInventoryMass + getNumber ( configFile >> "CfgVehicles" >> _objectClass >> "weight");
    };
    _massOnPlate = _massOnPlate + (_objectMass + (getMass _x));
} forEach _thisList;

_massOnPlate > _maxMass