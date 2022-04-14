class ctrlMenuStrip;
class display3DEN
{
    class Controls
    {
        class MenuStrip: ctrlMenuStrip
        {
            class Items
            {
                class Tools
                {
                    items[] += {QGVAR(tools)};
                };
                class GVAR(tools)
                {
                    text = "RID";
                    picture = QPATHTOEF(common,data\logo_rid_ca.paa);
                    items[] = {QGVAR(tripwireTool)};
                };
                class GVAR(tripwireTool)
                {
                    text = "Create Tripwire";                    
                    action = QUOTE(call FUNC(toolsTripwireModule));
                };
            };
        };
    };
};