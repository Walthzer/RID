class CfgVehicles
{
    class Logic;
    class Module_F: Logic
    {
        class AttributesBase
        {
            class Default;
            class Edit;                    // Default edit box (i.e., text input field)
            class Combo;                // Default combo box (i.e., drop-down menu)
            class Checkbox;                // Default checkbox (returned value is Boolean)
            class CheckboxNumber;        // Default checkbox (returned value is Number)
            class ModuleDescription;    // Module description
            class Units;                // Selection of units on which the module is applied
        };
        // Description base classes, for more information see below
        class ModuleDescription
        {
            class AnyBrain;
        };
    };
    class GVAR(iedModule): Module_F
    {
        // Standard object definitions
        scope = 2;
        scopeCurator = 2;
        displayName = "IED";
        icon = "a3\ui_f\data\igui\cfg\cursors\explosive_ca";
        category = "RID";

        function = QFUNC(iedModule);
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 0;
        isDisposable = 1;
        is3DEN = 1;
        GVARMAIN(on3DENStart) = 1;

        curatorInfoType = GVAR(RscIEDCreation); //RscDisplay for Zeus

        class Attributes
        {
            class GVAR(iedCreation)
            {
                displayName = "IED Class: ";
                tooltip = "Class from CfgAmmo to use for the IED.";
                property = GVAR(iedCreation);
                control = GVAR(iedCreation);

                expression = QUOTE(if (is3DEN) exitWith {}; [ARR_2(QQUOTE(expression),[ARR_2(_this,_value)])] call FUNC(iedModule));
                defaultValue = "[0,0]";

                unique = 0;
                validate = "none";
                typeName = "ARRAY";
            };
            class ModuleDescription {};
        };

    };
    class GVAR(tripwireModule): Module_F
    {
        scope = 1;
        scopeCurator = 1;
        displayName = "Tripwire";
        icon = "a3\ui_f\data\igui\rsccustominfo\sensors\targets\missilealt_ca";
        category = "RID";

        function = QFUNC(tripwireModule);
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 0;
        isDisposable = 1;
        is3DEN = 1;
        GVARMAIN(on3DENStart) = 1;

        curatorInfoType = "";

        class Attributes
        {
            class GVAR(tripwireCreation)
            {
                displayName = "";
                tooltip = "";
                property = GVAR(tripwireCreation);
                control = QGVAR(empty);

                expression = QUOTE(if (is3DEN) exitWith {}; [ARR_2(QQUOTE(expression),[ARR_2(_this,_value)])] call FUNC(tripwireModule));
                defaultValue = "[0,0]";

                unique = 0;
                validate = "none";
                typeName = "ARRAY";
            };
            class ModuleDescription {};
        };

    };
};