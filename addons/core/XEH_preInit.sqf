#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

ADDON = true;

//CBA SETTINGS
["rid_useNonStaticIED",
"CHECKBOX",
["Use new style of IED's", "Use acual mines for RID IED's"],
"RID",
false,
true
] call CBA_fnc_addSetting;