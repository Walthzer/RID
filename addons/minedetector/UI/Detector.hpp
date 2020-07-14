#define UISCALEFACTOR getNumber( configFile >> "uiScaleFactor" )		

//UI layout system from LarrowZurb. 
//user defined size of A grid to design your ui around ( integer )
#define GRIDSCALE 13	

//Definition for element grid sizes
//Grids are always pixel perfect, you never multiply a grid by anything other than an integer
//If you want smaller grids to design your ui around change the GRIDSCALE
#define GRID_X( NUM ) ( pixelW * pixelGrid * ((( ceil ( NUM )) * ( GRIDSCALE )) / UISCALEFACTOR ))
#define GRID_Y( NUM ) ( pixelH * pixelGrid * ((( ceil ( NUM )) * ( GRIDSCALE )) / UISCALEFACTOR ))		

//SafeZone pixel perfect anchor points
#define HORZ_LEFT ( safeZoneX )
#define HORZ_CENTER ( safeZoneX + ( safeZoneW / 2 ))
#define HORZ_RIGHT ( safeZoneX + safeZoneW )
#define VERT_TOP ( safeZoneY )
#define VERT_CENTER ( safeZoneY + ( safeZoneH / 2 ))
#define VERT_BOTTOM ( safeZoneY + safeZoneH )		

//Picture element sizes in grids
#define PIC_W 10
#define PIC_H 10		

#define WA 231

class rid_detector_group
{
	type = 0;
  	x = HORZ_RIGHT - GRID_X( PIC_W );
	y = VERT_BOTTOM - GRID_Y( PIC_H );
	w = GRID_X( PIC_W );
	h = GRID_Y( PIC_H );	
	style = 2+48+2048;
	colorBackground[] = {1,1,1,1};
	colorText[] = {1,1,1,0};
	font = "PuristaMedium";
	sizeEx = (((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1);
	access = 0;
};


class RscTitles
{
	class Rsc_rid_detector
	{
		idd = 231000;
		duration=1e+1000;
		fadeIn=0;
		onLoad = "uiNamespace setVariable ['rid_minedetector_displayRscDetector', _this select 0]";
		class Controls
		{
			class Screen: rid_detector_group 
			{
				idc = 231001;
				colorText[] = {1,1,1,1};
				text = QPATHTOF(ui\Screen_OFF.paa);
				on = QPATHTOF(ui\Screen_ON.png);
				off = QPATHTOF(ui\Screen_OFF.paa);
			};

			class MD_bar_1: rid_detector_group 
			{
				idc = 231100;
				text = QPATHTOF(ui\MD\MD_bar_1.paa);
			};
			class MD_bar_2: rid_detector_group 
			{
				idc = 231101;
				text = QPATHTOF(ui\MD\MD_bar_2.paa);
			};
			class MD_bar_3: rid_detector_group 
			{
				idc = 231102;
				text = QPATHTOF(ui\MD\MD_bar_3.paa);
			};
			class MD_bar_4: rid_detector_group 
			{
				idc = 231103;
				text = QPATHTOF(ui\MD\MD_bar_4.paa);
			};
			class MD_bar_5: rid_detector_group 
			{
				idc = 231104;
				text = QPATHTOF(ui\MD\MD_bar_5.paa);
			};
			class MD_bar_6: rid_detector_group 
			{
				idc = 231105;
				text = QPATHTOF(ui\MD\MD_bar_6.paa);
			};
			class MD_bar_7: rid_detector_group 
			{
				idc = 231106;
				text = QPATHTOF(ui\MD\MD_bar_7.paa);
			};
			class MD_bar_8: rid_detector_group 
			{
				idc = 231107;
				text = QPATHTOF(ui\MD\MD_bar_8.paa);
			};
			class MD_speaker: rid_detector_group
			{
				idc = 231108;
				text = QPATHTOF(ui\MD\MD_Speaker.paa);
			};
			class MD_PWR: rid_detector_group 
			{
				idc = 231109;
				text = QPATHTOF(ui\MD\MD_OFF.paa);
			};


			class WD_bar_1: rid_detector_group 
			{
				idc = 231200;
				text = QPATHTOF(ui\WD\WD_bar_1.paa);
			};
			class WD_bar_2: rid_detector_group 
			{
				idc = 231201;
				text = QPATHTOF(ui\WD\WD_bar_2.paa);
			};
			class WD_bar_3: rid_detector_group 
			{
				idc = 231202;
				text = QPATHTOF(ui\WD\WD_bar_3.paa);
			};
			class WD_bar_4: rid_detector_group 
			{
				idc = 231203;
				text = QPATHTOF(ui\WD\WD_bar_4.paa);
			};
			class WD_bar_5: rid_detector_group 
			{
				idc = 231204;
				text = QPATHTOF(ui\WD\WD_bar_5.paa);
			};
			class WD_bar_6: rid_detector_group 
			{
				idc = 231205;
				text = QPATHTOF(ui\WD\WD_bar_6.paa);
			};
			class WD_bar_7: rid_detector_group 
			{
				idc = 231206;
				text = QPATHTOF(ui\WD\WD_bar_7.paa);
			};
			class WD_bar_8: rid_detector_group 
			{
				idc = 231207;
				text = QPATHTOF(ui\WD\WD_bar_8.paa);
			};
			class WD_speaker: rid_detector_group
			{
				idc = 231208;
				text = QPATHTOF(ui\WD\WD_Speaker.paa);
			};
			class WD_PWR: rid_detector_group 
			{
				idc = 231209;
				text = QPATHTOF(ui\WD\WD_OFF.paa);
			};

			class Vol_1: rid_detector_group 
			{
				idc = 231300;
				text = QPATHTOF(ui\Vol\vol_1.paa);
			};
			class Vol_2: rid_detector_group 
			{
				idc = 231301;
				text = QPATHTOF(ui\Vol\vol_2.paa);
			};
			class Vol_3: rid_detector_group 
			{
				idc = 231302;
				text = QPATHTOF(ui\Vol\vol_3.paa);
			};
			class Vol_4: rid_detector_group 
			{
				idc = 231303;
				text = QPATHTOF(ui\Vol\vol_4.paa);
			};
			class Vol_5: rid_detector_group 
			{
				idc = 231304;
				text = QPATHTOF(ui\Vol\vol_5.paa);
			};
			class Vol_6: rid_detector_group 
			{
				idc = 231305;
				text = QPATHTOF(ui\Vol\vol_6.paa);
			};
			class Vol_7: rid_detector_group 
			{
				idc = 231306;
				text = QPATHTOF(ui\Vol\vol_7.paa);
			};
			class Vol_8: rid_detector_group 
			{
				idc = 231307;
				text = QPATHTOF(ui\Vol\vol_8.paa);
			};
			class Vol_9: rid_detector_group 
			{
				idc = 231308;
				text = QPATHTOF(ui\Vol\vol_9.paa);
			};
			class Vol_10: rid_detector_group 
			{
				idc = 231309;
				text = QPATHTOF(ui\Vol\vol_10.paa);
			};
			class Vol_11: rid_detector_group 
			{
				idc = 231310;
				text = QPATHTOF(ui\Vol\vol_11.paa);
			};
			class Vol_12: rid_detector_group 
			{
				idc = 231311;
				text = QPATHTOF(ui\Vol\vol_12.paa);
			};

			class Battery_1: rid_detector_group 
			{
				idc = 231400;
				text = QPATHTOF(ui\Battery\Battery_1.paa);
			};
			class Battery_2: rid_detector_group 
			{
				idc = 231401;
				text = QPATHTOF(ui\Battery\Battery_2.paa);
			};
			class Battery_3: rid_detector_group 
			{
				idc = 231402;
				text = QPATHTOF(ui\Battery\Battery_3.paa);
			};
			class Battery_4: rid_detector_group 
			{
				idc = 231403;
				text = QPATHTOF(ui\Battery\Battery_4.paa);
			};
			class Battery_5: rid_detector_group 
			{
				idc = 231404;
				text = QPATHTOF(ui\Battery\Battery_5.paa);
			};
			class Battery_6: rid_detector_group 
			{
				idc = 231405;
				text = QPATHTOF(ui\Battery\Battery_6.paa);
			};
			class Battery_7: rid_detector_group 
			{
				idc = 231406;
				text = QPATHTOF(ui\Battery\Battery_7.paa);
			};
			class Battery_8: rid_detector_group 
			{
				idc = 231407;
				text = QPATHTOF(ui\Battery\Battery_8.paa);
			};
			class Battery_9: rid_detector_group 
			{
				idc = 231408;
				text = QPATHTOF(ui\Battery\Battery_9.paa);
			};
			class Battery_10: rid_detector_group 
			{
				idc = 231409;
				text = QPATHTOF(ui\Battery\Battery_10.paa);
			};
			class Battery_11: rid_detector_group 
			{
				idc = 231410;
				text = QPATHTOF(ui\Battery\Battery_11.paa);
			};
			class Battery_12: rid_detector_group 
			{
				idc = 231411;
				text = QPATHTOF(ui\Battery\Battery_12.paa);
			};

			class Chassis: rid_detector_group 
			{
				idc = 231500;
				colorText[] = {1,1,1,1};
				text = QPATHTOF(ui\chassis.paa);
			};

			class Orange_Ring: rid_detector_group 
			{
				idc = 231600;
				text = QPATHTOF(ui\Orange\Orange_Ring.paa);
			};
			class Orange_1: rid_detector_group 
			{
				idc = 231601;
				text = QPATHTOF(ui\Orange\Orange_1.paa);
			};
			class Orange_2: rid_detector_group 
			{
				idc = 231602;
				text = QPATHTOF(ui\Orange\Orange_2.paa);
			};
			class Orange_3: rid_detector_group 
			{
				idc = 231603;
				text = QPATHTOF(ui\Orange\Orange_3.paa);
			};
			class Orange_4: rid_detector_group 
			{
				idc = 231604;
				text = QPATHTOF(ui\Orange\Orange_4.paa);
			};
			class Orange_5: rid_detector_group 
			{
				idc = 231605;
				text = QPATHTOF(ui\Orange\Orange_5.paa);
			};
			class Orange_6: rid_detector_group 
			{
				idc = 231606;
				text = QPATHTOF(ui\Orange\Orange_6.paa);
			};
			class Orange_7: rid_detector_group 
			{
				idc = 231607;
				text = QPATHTOF(ui\Orange\Orange_7.paa);
			};
			class Orange_8: rid_detector_group 
			{
				idc = 231608;
				text = QPATHTOF(ui\Orange\Orange_8.paa);
			};

			class Green_Ring: rid_detector_group 
			{
				idc = 231700;
				text = QPATHTOF(ui\Green\Green_Ring.paa);
			};
			class Green_1: rid_detector_group 
			{
				idc = 231701;
				text = QPATHTOF(ui\Green\Green_1.paa);
			};
			class Green_2: rid_detector_group 
			{
				idc = 231702;
				text = QPATHTOF(ui\Green\Green_2.paa);
			};
			class Green_3: rid_detector_group 
			{
				idc = 231703;
				text = QPATHTOF(ui\Green\Green_3.paa);
			};
			class Green_4: rid_detector_group 
			{
				idc = 231704;
				text = QPATHTOF(ui\Green\Green_4.paa);
			};
			class Green_5: rid_detector_group 
			{
				idc = 231705;
				text = QPATHTOF(ui\Green\Green_5.paa);
			};
			class Green_6: rid_detector_group 
			{
				idc = 231706;
				text = QPATHTOF(ui\Green\Green_6.paa);
			};
			class Green_7: rid_detector_group 
			{
				idc = 231707;
				text = QPATHTOF(ui\Green\Green_7.paa);
			};
			class Green_8: rid_detector_group 
			{
				idc = 231708;
				text = QPATHTOF(ui\Green\Green_8.paa);
			};
		};
	};
};