class CfgHints {
    class Realistic_IED_Defusal_Zeus
    {
        // Topic title (displayed only in topic listbox in Field Manual)
        displayName = "Realistc IED Zeus Modules";
        class NetworkLink
        {
            displayName = CSTRING(NetworkLinkHint_Displayname);
            description = CSTRING(NetworkLinkHint_Description);
            tip = CSTRING(NetworkLinkHint_Tip);
            image = QPATHTOF(data\wfarIcon.paa);
            noImage = false;
        };
        
        class Tripwire
        {
            displayName = CSTRING(TripwireHint_Displayname);
            description = CSTRING(TripwireHint_Description);
            tip = "";
            image = QPATHTOF(data\wfarIcon.paa);
            noImage = false;
        };
    };
};