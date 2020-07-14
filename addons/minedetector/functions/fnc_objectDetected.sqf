#include "script_component.hpp"
params["_unit", "_primaryObject", "_primaryDistance"];

private _display = uiNamespace getVariable[QGVAR(displayRscDetector), displayNull];
if (isNull _display) exitwith {ERROR_MSG("Is not display")};

GVAR(timeOfLastDetect) = CBA_missionTime;
if (GVAR(canCreateTimeoutResetRscDetector)) then {
    GVAR(canCreateTimeoutResetRscDetector) = false;
    [FUNC(timeoutResetRscDetector), [], 0.06] call CBA_fnc_waitAndExecute;
};

private _primaryIsCW = isNumber (configFile >> "CfgAmmo" >> (typeOf _primaryObject) >> "isCW");

private _detected = [[_unit, _primaryObject, _primaryIsCW], FUNC(getSecondaryDetectedObject), _unit, QGVAR(secondaryDetectedObjects), 0.15] call ace_common_cachedCall;
//private _detected = [_unit, _primaryObject, _primaryIsCW] call FUNC(getSecondaryDetectedObject);

_detected params ["_secondaryObject", "_secondaryIsCW", "_secondaryDistance"];
private _argCache = [_primaryObject, _primaryDistance, _secondaryObject, _secondaryDistance];
if ( _argCache isEqualTo (_unit getVariable [QGVAR(detectedObjectsCacheRscDetector), []])) exitwith {};
_unit setVariable [QGVAR(detectedObjectsCacheRscDetector), _argCache];

_fnc_topIndicators = {
    params["_dist", "_isCW"];
    private _indicatorStatus = [0,0];
    for "_i" from 0 to 1 do {
        private _topIndicator = switch (true) do {
        case (_dist >= 2): {1};
        case (_dist >= 1.75): {2};
        case (_dist >= 1.5): {3};
        case (_dist >= 1.25): {4};
        case (_dist >= 1): {5};
        case (_dist >= 0.75): {6};
        case (_dist >= 0.25): {7};
        default {8};
        };
        if (_i == 0) then {
            if (!_isCW) then {
                _indicatorStatus set [0, _topIndicator-selectRandom[0,0,1]];
            }else {
                _indicatorStatus set [0, selectRandom[0,1,1,2]];
            };    
        }else {
            if (_isCW) then {
                _indicatorStatus set [1, _topIndicator-selectRandom[0,0,1]];
            }else {
                _indicatorStatus set [1, selectRandom[0,1,1,2]];
            };    
        };
    };
    _indicatorStatus;
};

private _indicatorStatus = [_primaryDistance, _primaryIsCW] call _fnc_topIndicators;
private _secondaryIndicatorStatus = [_secondaryDistance, _secondaryIsCW] call _fnc_topIndicators;

if (!isNull _secondaryObject) then {
    {
        if (_x > (_indicatorStatus#_forEachIndex)) then {
            _indicatorStatus set [_forEachIndex, _x];
        };
    } foreach _secondaryIndicatorStatus;
};

{
    for "_i" from 1 to 8 do {
        private _alpha = if (_i <= _x) then {1} else {0};
        _screenIdc = parseNumber("231" + str(1+_forEachIndex) + "0" + str (_i-1));
        _sideIdc = parseNumber("231" + str(6+_forEachIndex) + "0" + str _i);
        (_display displayCtrl _screenIdc) ctrlSetTextColor [1, 1, 1, _alpha];
        (_display displayCtrl _sideIdc) ctrlSetTextColor [1, 1, 1, _alpha];
    };  
} forEach _indicatorStatus;