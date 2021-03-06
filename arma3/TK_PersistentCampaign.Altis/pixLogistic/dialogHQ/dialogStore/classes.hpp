#include "defines.hpp"

class PIXLOGISTIC_DIALOG_HQ_STORE 
{
	idd = PIXLOGISTIC_IDD_DIALOG_HQ_STORE;
	name = "PIXLOGISTIC_DIALOG_HQ_STORE";
	movingEnable = false;
	
	controlsBackground[] = 
	{
		PIXLOGISTIC_DIALOG_HQ_STORE_Title,
		PIXLOGISTIC_DIALOG_HQ_STORE_Background
	};
	objects[] = {};
	controls[] =
	{
		PIXLOGISTIC_DIALOG_HQ_STORE_SubTitle,
		PIXLOGISTIC_DIALOG_HQ_STORE_List,
		
		PIXLOGISTIC_DIALOG_HQ_STORE_ButtonCreate,
		PIXLOGISTIC_DIALOG_HQ_STORE_ButtonCancel
	};
	
	class PIXLOGISTIC_DIALOG_HQ_STORE_Background: IGUIBack
	{
		idc = -1;
		x = GRID_ABS_X;
		y = GRID_ABS_Y;
		w = GRID_ABS_W;
		h = GRID_ABS_H;
	};	
	class PIXLOGISTIC_DIALOG_HQ_STORE_Title : RscTitle
	{
		idc = -1;
		x = GRID_ABS_X;
		y = GRID_ABS_Y - GRID_TITLE_H;
		w = GRID_ABS_W;
		h = GRID_TITLE_H;
		text = "";
	};	
	class PIXLOGISTIC_DIALOG_HQ_STORE_SubTitle : RscText
	{
		idc = PIXLOGISTIC_IDC_DIALOG_HQ_STORE_SubTitle;
		x = 1 * GRID_W + GRID_ABS_X; 
		y = 1 * GRID_H + GRID_ABS_Y; 
		w = 8 * GRID_W;
		h = 1 * GRID_H;
		text = "";
		colorbackground[] = 
		{
			0,
			0,
			0,
			1
		};		
	};
	
	class PIXLOGISTIC_DIALOG_HQ_STORE_List : RscListBox
	{
		idc = PIXLOGISTIC_IDC_DIALOG_HQ_STORE_List;
		x = 1 * GRID_W + GRID_ABS_X; 
		y = 2 * GRID_H + GRID_ABS_Y; 
		w = 8 * GRID_W;
		h = 6 * GRID_H;
	};
	

	class PIXLOGISTIC_DIALOG_HQ_STORE_ButtonCreate : RscButtonMenuOK
	{
		idc = PIXLOGISTIC_IDC_DIALOG_HQ_STORE_ButtonCreate;
		x = 5 * GRID_W + GRID_ABS_X; 
		y = 8 * GRID_H + GRID_ABS_Y; 
		w = 4 * GRID_W;
		h = 1 * GRID_H;
		text = "Anfordern";
		action = "execVM 'pixLogistic\dialogHQ\dialogStore\onButtonCreateClicked.sqf';";
	};
	
	class PIXLOGISTIC_DIALOG_HQ_STORE_ButtonCancel : RscButtonMenuCancel
	{
		idc = PIXLOGISTIC_IDC_DIALOG_HQ_STORE_ButtonCancel;
		x = 1 * GRID_W + GRID_ABS_X; 
		y = 8 * GRID_H + GRID_ABS_Y; 
		w = 4 * GRID_W;
		h = 1 * GRID_H;
		text = "Abbrechen";
		action = "execVM 'pixLogistic\dialogHQ\dialogStore\onButtonCancelClicked.sqf';";
	};
};