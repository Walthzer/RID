class CfgHints {
    class Realistic_IED_Defusal_Zeus
    {
        // Topic title (displayed only in topic listbox in Field Manual)
        displayName = "Realistc IED Zeus Modules";
        class NetworkLink
        {
            displayName = "Creating a Network Link";
            description = "In order to create a link another Network Node has to be selected. %1Select one now and confirm the selection with: %1%3[ENTER]%4 %1You can cancel the Link with: %1%3[ESCAPE]%4";
            tip = "If a new Node was created for this Link, it will not be deleted if you cancel the Link";
            image = QPATHTOF(data\wfarIcon.paa);
            noImage = false;
        };
        
        class Tripwire
        {
            displayName = "Creating a Tripwire";
            description = "In order to create a tripwire another object has to be selected. %1Select one now and confirm the selection with: %1%3[ENTER]%4 %1You can cancel the Link with: %1%3[ESCAPE]%4";
            tip = "";
            image = QPATHTOF(data\wfarIcon.paa);
            noImage = false;
        };
    };
};