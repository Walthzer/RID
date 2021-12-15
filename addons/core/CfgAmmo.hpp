class CfgAmmo {
    
    class APERSTripMine_Wire_Ammo;
    class rid_tripWire_base_Ammo: APERSTripMine_Wire_Ammo 
    {
        author = "Walthzer/Shark";
        GVARMAIN(isCW) = 1;
        SoundSetExplosion[] = {};
        defaultMagazine="APERSTripMine_Wire_Mag";
        hiddenSelections[]={"camo", "start", "end"};
        hit=0;
        indirectHit=0;
        indirectHitRange=0;
        soundHit[]={"",1,1};
        explosionEffects="rid_tripWireEffect";
        CraterEffects="";
        soundTrigger[]={"",1,1};
        class CamShakeExplode {
            power=0;
            duration=0;
            frequency=0;
            distance=0;
        };
    };
    class rid_tripWire_segment_Ammo: rid_tripWire_base_Ammo
    {
        model=QPATHTOF(models\rid_tripwire);
        mineTrigger="rid_tripWire_base_trigger";
        mineModelDisabled="";
    };
};