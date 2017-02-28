#pragma once

#ifndef WIN32
#define __stdcall
#define __declspec(dllexport)
#endif

#include "Basetype.h"


typedef void (__stdcall *WLMessageCallback)(int fncode, void *pdata);
typedef void (__stdcall *WLDebugMessageCallback)(_SDK_DEBUG_MSG *pdata);
typedef void (__stdcall *WLWatchMessageCallback)(int fncode, void *pdata);

extern "C"
{
	__declspec(dllexport) int Init(WLMessageCallback messageCallback, CPCHAR loc);
	__declspec(dllexport) int UnInit();
	__declspec(dllexport) int RegDebugMsg(WLDebugMessageCallback debugMessageCallback);
    __declspec(dllexport) int RegWatchMessageMsg(WLWatchMessageCallback watchMessageCallback);
	__declspec(dllexport) int Search(CPCHAR ClientIP);
	__declspec(dllexport) int SetCustomDomain(CPCHAR CustomDomain);
	__declspec(dllexport) int connectDefault(CPCHAR appID, CPCHAR appType, CPCHAR appVer, CPCHAR gwID, CPCHAR gwPwd, CPCHAR token, CPCHAR lang, CPCHAR appDir, CPCHAR ClientIP, bool &bLocal);
	__declspec(dllexport) int connectCustom(CPCHAR appID, CPCHAR appType, CPCHAR appVer, CPCHAR LocalIP, CPCHAR gwID, CPCHAR gwPwd, CPCHAR token, CPCHAR lang, CPCHAR appDir);
	__declspec(dllexport) int disconnect(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int flashconnect(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int blockconnect(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int recoverconnect(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int noconnectionobject(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendConnectGwMsg(CPCHAR appID, CPCHAR appType, CPCHAR appVer, CPCHAR gwID, CPCHAR gwPwd, CPCHAR token, CPCHAR lang);
	__declspec(dllexport) int sendDisConnectGwMsg(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendChangeGwPwdMsg(CPCHAR appID, CPCHAR gwID, CPCHAR gwPwd, CPCHAR gwNewPwd);
	__declspec(dllexport) int sendRefreshDevMsg(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendControlDevMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID, CPCHAR ep, CPCHAR epType, CPCHAR epData);
	__declspec(dllexport) int sendGetRoomMsg(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendSetRoomMsg(CPCHAR appID, CPCHAR gwID, int mode, CPCHAR roomID, CPCHAR name, CPCHAR icon);
	__declspec(dllexport) int sendGetSceneMsg(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendSetSceneMsg(CPCHAR appID, CPCHAR gwID, int mode, CPCHAR sceneID, CPCHAR name, CPCHAR icon, CPCHAR status);
	__declspec(dllexport) int sendGetTaskMsg(CPCHAR appID, CPCHAR gwID, CPCHAR version, CPCHAR sceneID);
	__declspec(dllexport) int sendSetTaskMsg(CPCHAR appID, CPCHAR gwID, CPCHAR sceneID, CPCHAR devID, CPCHAR type, CPCHAR ep, CPCHAR epType, _TASK_DATA data[], int datacount);
	__declspec(dllexport) int sendSetTaskMsgV5(CPCHAR appID, CPCHAR gwID, CPCHAR sceneID, CPCHAR devID, CPCHAR type, CPCHAR ep, CPCHAR epType, _TASK_DATA data[], int datacount, CPCHAR mutilLinkage);
	__declspec(dllexport) int sendSetDevMsg(CPCHAR appID, CPCHAR gwID, int mode, CPCHAR devID, CPCHAR type, CPCHAR ep, CPCHAR epType, CPCHAR name, CPCHAR category, CPCHAR roomID, CPCHAR epName, CPCHAR epStatus);
	__declspec(dllexport) int sendGetDevIRMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID, CPCHAR ep);
	__declspec(dllexport) int sendSetDevIRMsg(CPCHAR appID, CPCHAR gwID, int mode, CPCHAR devID, CPCHAR ep, CPCHAR irType, _DEVICE_IR_INFO data[], int datacount);
	__declspec(dllexport) int sendGetTimedSceneMsg(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendSetTimedSceneMsg(CPCHAR appID, CPCHAR gwID, int mode, CPCHAR groupID, CPCHAR groupName, CPCHAR status, _TD_DATA data[], int datacount);
	__declspec(dllexport) int sendGetBindSceneMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID);
	__declspec(dllexport) int sendSetBindSceneMsg(CPCHAR appID, CPCHAR gwID, int mode, CPCHAR devID, CPCHAR type, _BIND_SCENE_INFO data[], int datacount);
	__declspec(dllexport) int sendQueryDevRssiMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID);

	__declspec(dllexport) int sendEnableJoinGateWay(CPCHAR appID, CPCHAR gwID/*, CPCHAR devID*/);
	__declspec(dllexport) int sendDisableJoinGateWay(CPCHAR appID, CPCHAR gwID/*, CPCHAR devID*/);
	__declspec(dllexport) int sendGetGateWayMsg(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendSetGatewayMsg(CPCHAR appID, CPCHAR gwID, CPCHAR gwName, CPCHAR gwLocation, CPCHAR gwRoomID);
	__declspec(dllexport) int sendResetGatewayMsg(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendRestoreGatewayMsg(CPCHAR appID, CPCHAR gwID);

	__declspec(dllexport) int sendDevShineMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID);
	__declspec(dllexport) int sendSocialMsg(CPCHAR appID, CPCHAR gwID, CPCHAR userID, CPCHAR userType, CPCHAR alias, CPCHAR to, CPCHAR data, long time);

	__declspec(dllexport) int sendGetRouterMsg(CPCHAR appID, CPCHAR gwID, CPCHAR cmdindex);
	__declspec(dllexport) int sendSetRouterMsg(CPCHAR appID, CPCHAR gwID, CPCHAR jsondata, int len);
	__declspec(dllexport) int sendGetDreamFlowerMsg(CPCHAR appID, CPCHAR gwID, CPCHAR cmdindex);
	__declspec(dllexport) int sendSetDreamFlowerMsg(CPCHAR appID, CPCHAR gwID, CPCHAR jsondata, int len);
	__declspec(dllexport) int sendGetFileMsg(CPCHAR appID, CPCHAR gwID, CPCHAR cmdindex);
	__declspec(dllexport) int sendSetFileMsg(CPCHAR appID, CPCHAR gwID, CPCHAR jsondata, int len);
    //406
    __declspec(dllexport) int sendGetDeviceCommonMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID, CPCHAR time, CPCHAR key);
    __declspec(dllexport) int sendSetDeviceCommonMsg(CPCHAR appID, CPCHAR gwID, CPCHAR jsondata, int len);

	__declspec(dllexport) int sendGetRuleGroupEnableAutoProgramMsg(CPCHAR appID, CPCHAR gwID, CPCHAR groupID);
	__declspec(dllexport) int sendSetRuleGroupEnableAutoProgramMsg(CPCHAR appID, CPCHAR gwID, CPCHAR jsondata, int len);

	__declspec(dllexport) int sendGetAutoProgramMsg(CPCHAR appID, CPCHAR gwID); 
	__declspec(dllexport) int sendSetAutoProgramMsg(CPCHAR appID, CPCHAR gwID, CPCHAR operType, CPCHAR programID, CPCHAR programName, CPCHAR programDesc, CPCHAR programType, CPCHAR status, _AP_TRIGGER trigger[], int triggercount, _AP_CONDITION condition[], int conditioncount, _AP_ACTION action[], int actioncount);
	//管家升级相关函数
	__declspec(dllexport) int sendGetUpdataAutoProGramMsg(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendSetUpdataAutoProGramMsg(CPCHAR appID, CPCHAR gwID,CPCHAR zoneID);
	__declspec(dllexport) int sendClearUpdataAutoProGramMsg(CPCHAR appID, CPCHAR gwID);
	//网关时间同步相关函数
	__declspec(dllexport) int sendGetGateWayCurrTime(CPCHAR appID, CPCHAR gwID);
	__declspec(dllexport) int sendSetGateWayCurrTime(CPCHAR appID, CPCHAR gwID,CPCHAR zoneID, CPCHAR time);
	//直接命令发送
	__declspec(dllexport) int sendDirectCmdMsg(CPCHAR appID, CPCHAR gwID,CPCHAR data);
	//OP门锁设备管理操作函数
	__declspec(dllexport) int sendOperaOPUserMsg(CPCHAR appID, CPCHAR gwID,CPCHAR devID, CPCHAR operType, CPCHAR token, CPCHAR userID, CPCHAR userType, CPCHAR password, CPCHAR peroid, CPCHAR unlocktype, CPCHAR menace,CPCHAR sceneID, CPCHAR cName, CPCHAR armSet,CPCHAR disArmSet,CPCHAR force);
    
    //获取设备历史消息接口
    __declspec(dllexport) int sendGetDeviceAlarmData(CPCHAR appID, CPCHAR gwID,CPCHAR devID, CPCHAR time, CPCHAR pageSize);
    
    //MiniGateway中继设置(cmd:330) 相应接口
    __declspec(dllexport) int sendGetMiniGatewayRepeater(CPCHAR appID, CPCHAR gwID, CPCHAR cmdindex);
    __declspec(dllexport) int sendSetMiniGatewayRepeater(CPCHAR appID, CPCHAR gwID, CPCHAR data);
    
    //查找设置wifi复合设备信息
    __declspec(dllexport) int sendGetWIFIDevMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID);
    __declspec(dllexport) int sendGetWIFIDevStatusMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID);
    __declspec(dllexport) int sendSetWIFIDevMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID, CPCHAR wifiiSSID, CPCHAR wifiPass);
    
    //查询设备绑定消息
    __declspec(dllexport) int sendGetBindDeviceMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID);
    __declspec(dllexport) int sendSetBindDeviceMsg(CPCHAR appID, CPCHAR gwID, int mode, CPCHAR devID, CPCHAR type, _BIND_DEVICE_INFO data[], int datacount);
    //子网关绑定解绑管理网关
    __declspec(dllexport) int sendSubGWBindManagerGW(CPCHAR appID, CPCHAR gwID,CPCHAR subGWID,CPCHAR subGWPwd,CPCHAR type);
    
    //修改获取子网关信息
    __declspec(dllexport) int sendGetSubGateWayMsg(CPCHAR appID, CPCHAR gwID,CPCHAR subGWID);
    __declspec(dllexport) int sendSetSubGatewayMsg(CPCHAR appID, CPCHAR gwID,CPCHAR subGWID,CPCHAR gwName, CPCHAR gwRoomID);
    //管理网关查询子网关
     __declspec(dllexport) int sendQuerySubGateWay(CPCHAR appID, CPCHAR gwID);
}

