class CfgCloudlets {
    class Default;
    class rid_tripWire_cloudLet: Default {
        lifeTime=0;
        beforeDestroyScript = QPATHTOF(scripts\tripWireActivation.sqf);
    };
};