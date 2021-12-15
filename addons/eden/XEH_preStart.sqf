#include "script_component.hpp"

#include "XEH_PREP.hpp"

private _customConnectionClasses = QUOTE((getNumber (_x >> QQGVARMAIN(isCustom))) > 0) configClasses (configfile >> "Cfg3DEN" >> "Connections");
private _compiledCustomConnections = [];

{
    _compiledCustomConnections pushBack [configName _x, compile (getText (_x >> QGVARMAIN(OnScenarioStart)))];
} forEach _customConnectionClasses;

uiNamespace setVariable [QGVAR(cacheCustomConnectionsClasses), compileFinal str _compiledCustomConnections];