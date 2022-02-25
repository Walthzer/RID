class RscCombo;
class RscText;
class RscControlsGroup;
class RscControlsGroupNoScrollbars;

class RscDisplayAttributes {
    class Controls {
        class Background;
        class Title;
        class Content: RscControlsGroup {
            class Controls;
        };
        class ButtonOK;
        class ButtonCancel;
    };
};

class GVAR(RscIEDCreation): RscDisplayAttributes {

    onLoad = QUOTE([ARR_3('onLoad', _this, QQGVAR(RscIEDCreation))] call ACE_FUNC(zeus,zeusAttributes));
    onUnload = QUOTE([ARR_3('onUnload', _this, QQGVAR(RscIEDCreation))] call ACE_FUNC(zeus,zeusAttributes));

    class Controls: Controls {
        class Background: Background {};
        class Title: Title {};
        class Content: Content {
            class Controls {
                class iedClass: RscControlsGroupNoScrollbars {
                    onSetFocus = QUOTE(call FUNC(ui_iedClass));
                    idc = 300000;
                    x = 0;
                    y = 0;
                    w = W_PART(26);
                    h = H_PART(2.1);
                    class controls {
                        class iedClassLabel: RscText {
                            idc = -1;
                            text = "IED Class:";
                            x = 0;
                            y = 0;
                            w = W_PART(10);
                            h = H_PART(1);
                            colorBackground[] = {0, 0, 0, 0.5};
                        };
                        class iedClass: RscCombo {
                            idc = 300001;
                            x = W_PART(10.1);
                            y = 0;
                            w = W_PART(15.9);
                            h = H_PART(1);
                        };
                        class internalTriggerLabel: iedClassLabel {
                            text = "Internal Trigger:";
                            y = H_PART(1.1);
                        };
                        class internalTrigger: RscCombo {
                            idc = 300002;
                            x = W_PART(10.1);
                            y = H_PART(1.1);
                            w = W_PART(15.9);
                            h = H_PART(1);
                            colorBackground[] = {0, 0, 0, 0.7};
                            class Items
                            {
                                class none 
                                {
                                    text = "none";
                                    value = 1;
                                    data = "ext";
                                    default = 1;
                                    tooltip = "No internal trigger";
                                };
                                class vibration 
                                {
                                    text = "Vibration";
                                    value = 1;
                                    data = "vib";
                                    tooltip = "Vibration Detector";
                                };
                            };
                        };
                    };
                };
            };
        };
        class ButtonOK: ButtonOK {};
        class ButtonCancel: ButtonCancel {};
    };
};