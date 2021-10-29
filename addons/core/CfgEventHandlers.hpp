class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};

class Extended_Killed_EventHandlers {
    class rid_commandWireComplete {
        class ADDON {
            serverKilled = QUOTE(call FUNC(commandWireCut));
        };
    };
    class rid_virtualIED {
        class ADDON {
            killed = QUOTE([this select 0] call FUNC(conditionalCrawlerActivation));
        };
    };
};

class Extended_Deleted_EventHandlers {
    class rid_virtualIED {
        class ADDON {
            deleted = QUOTE(call FUNC(onVirtualIEDDeletion));
        };
    };
};