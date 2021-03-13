#include "script_component.hpp"
params["_display"];

//Unneccesary for now, minedetector has no settings besides on or off.
//private _screenIndicatorStatus = uiNamespace getVariable[QGVAR(screenIndcatorStatus), [1, 1, 1, 1, 9, 7]];
private _screenIndicatorStatus = [1, 1, 1, 1, 9, 7];

//Intitilize volume&Battery level:
for "_i" from 0 to 1 do {
    private _idcPrefix = "231" + str (_i+3);
    for "_k" from 0 to (_screenIndicatorStatus select (_i+4)) do {
        private _idcSuffix = if (_k < 10) then {
            "0" + str _k;
        } else {
            str _k;
        };
        (_display displayCtrl (parseNumber (_idcPrefix + _idcSuffix))) ctrlSetTextColor [1, 1, 1, 1];
    };
};

private _idcAffix = "1";
for "_i" from 0 to 2 step 2 do {
    private _detectorType = ["WD\WD","MD\MD"] select (_i==0);
    private _pwr = if (_screenIndicatorStatus select (_i) == 1) then {"ON"} else {"OFF"};
    private _path = format ["%1%2_%3.paa", QPATHTOF(ui\), _detectorType, _pwr];

    for "_i" from 0 to 1 do {
        private _idc = parseNumber("231" + _idcAffix + "0" + str (_i+8));
        private _control = _display displayCtrl _idc;
        if (_i == 0) then {
            _control ctrlSetTextColor [1, 1, 1, _screenIndicatorStatus select (_i+1)];
        }else {
            _control ctrlSetText _path;
            _control ctrlSetTextColor [1, 1, 1, 1];
        };
    };
    _idcAffix = "2";
};
