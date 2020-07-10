#include "script_component.hpp"
params["_display", "_alpha"];

private _idcRanges = [-1, 9, 9, 12, 12, -1,  8, 8];
{
    if (_x >= 0) then {
        _idcPrefix = ("231" + str _foreachIndex);
        for "_i" from 0 to _x do {
            _idcSuffix = if (_i < 10) then {
                "0" + str _i;
            } else {
                str _i;
            };
            (_display displayCtrl (parseNumber (_idcPrefix + _idcSuffix))) ctrlSetTextColor [1, 1, 1, _alpha];
        };
    };
} foreach _idcRanges;

