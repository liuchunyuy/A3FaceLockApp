//
//  AppDelegate.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/1/17.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "AppDelegate.h"
//#import "wulianMasterViewController.h"
#import "AddGateWayViewController.h"
#include "wulianSDK.h"
#include "Device.h"
#import "PackageMessage.h"
#import "OpenUDID.h"
//@interface AppDelegate ()
//
//@end

MAP_STR_GATEWAY m_map_str_gateway;
MAP_ID_STR_DEVICE m_map_id_str_device;				//Õ¯πÿID”Î…Ë±∏¡–±Ì
MAP_ID_STR_AREA m_map_id_str_area;					//Õ¯πÿID”Î«¯”Ú¡–±Ì
MAP_ID_STR_SCENE m_map_id_str_scene;				//Õ¯πÿID”Î≥°æ∞¡–±Ì
MAP_ID_STR_TIME_SCENE m_map_id_str_time_scene;


MAP_ID_STR_AUTOPROGRAM m_map_id_str_autoProgram;
MAP_ID_STR_AUTOPROGRAMDETAIL m_map_id_str_autoProgramDetail;

std::string m_strCurID;
std::string m_strAppID;
std::string m_strAppVer;
std::string m_strChangePw;

void __stdcall myMessageCallback(int fncode, void *pdata)
{
    std::cout<<"fncode:"<<fncode<<std::endl;
    CString strID;
    CString strAreaID;
    bool bArea = false;
    CString strDeviceID;
    bool bDevice = false;
    CString strSceneID;
    bool bScene = false;
    bool bAuto = false;
    if (fncode == CONNECT_SERVER)
    {
        LP_CONNECT_SERVER result = (LP_CONNECT_SERVER)pdata;
        strID = result->gwID;
        m_map_str_gateway[strID]->m_iServerStatus = result->iResult;
        // NSLog(@"iResult is %@",result);
    }
    else if (fncode == CONNECT_GATEWAY)
    {
        //µ±∑µªÿ¥˙¬ÎŒ™14 ±£¨–Ë“™∂œø™”√–¬IP÷ÿ–¬¡¨Ω”
        LP_GATEWAY_INFO result = (LP_GATEWAY_INFO)pdata;
        strID = result->gwID;
        m_map_str_gateway[strID]->m_strIP = result->gwIP;
        m_map_str_gateway[strID]->m_strTime = result->gwTime;
        m_map_str_gateway[strID]->m_strZone = result->gwZone;
        m_map_str_gateway[strID]->m_strData = result->gwData;
        if (atoi(result->gwData.c_str()) == 0)
        {
            sendRefreshDevMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
            sendGetRoomMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
            sendGetSceneMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
            sendGetTimedSceneMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
            sendGetAutoProgramMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
        }
    }
    else if (fncode == DISCONNECT_GATEWAY)
    {
        LP_DISCONNECT_GATEWAY result = (LP_DISCONNECT_GATEWAY)pdata;
        strID = result->gwID;
        int idata = atoi(result->gwData.c_str());
        if (idata == 0)
        {
            m_map_str_gateway[strID]->m_strData = "-3";	//Õ¯πÿ∂œø™
        }
    }
    else if (fncode == CHANGE_GATEWAY_PW)
    {
        LP_CHANGE_GATEWAY_PW result = (LP_CHANGE_GATEWAY_PW)pdata;
        strID = result->gwID;
        int idata = atoi(result->gwData.c_str());
        if (idata == 0)
        {
            m_map_str_gateway[strID]->m_strNewPW = m_strChangePw;
            m_map_str_gateway[strID]->m_strPW = m_map_str_gateway[strID]->m_strNewPW;
            m_map_str_gateway[strID]->m_strNewPW = "";
            m_map_str_gateway[strID]->m_strData = "21";	//–ﬁ∏ƒ√‹¬Î≥…π¶
        }
        else
        {
            m_map_str_gateway[strID]->m_strData = "22";	//–ﬁ∏ƒ√‹¬Î ß∞‹
        }
    }
    else if (fncode == DEVICE_DATA)
    {
        bDevice = true;
        LP_DEVICE_DATA result = (LP_DEVICE_DATA)pdata;
        strID = result->gwID;
        strDeviceID = result->devID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            iter->second->m_bOnline = true;
            iter->second->m_map_ep_data[result->ep].m_strEPType = result->epType;
            iter->second->m_map_ep_data[result->ep].m_strEPData = result->epData;
        }
    }
    else if (fncode == GATEWAY_UP)
    {
        LP_GATEWAY_UP result = (LP_GATEWAY_UP)pdata;
        strID = result->gwID;
        m_map_str_gateway[strID]->m_strData = "31";	//Õ¯πÿ…œœﬂ
        sendRefreshDevMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
        sendGetRoomMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
        sendGetSceneMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
        sendGetAutoProgramMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), strID.c_str());
    }
    else if (fncode == GATEWAY_DOWN)
    {
        LP_GATEWAY_UP result = (LP_GATEWAY_UP)pdata;
        strID = result->gwID;
        m_map_str_gateway[strID]->m_strData = "32";	//Õ¯πÿœ¬œﬂ
    }
    else if (fncode == DEVICE_UP)
    {
        bDevice = true;
        LP_DEVICE_UP result = (LP_DEVICE_UP)pdata;
        strID = result->gwID;
        strDeviceID = result->devID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            iter->second->m_strGWID = result->gwID;
            iter->second->m_strID = result->devID;
            iter->second->m_strType = result->type;
            iter->second->m_strName = result->name;
            iter->second->m_strRoomID = result->roomID;
            iter->second->m_strCategory = result->category;
            iter->second->m_bOnline = true;
            iter->second->m_iEPCount = result->datacount;
            for (int i = 0; i < result->datacount; i++)
            {
                iter->second->m_map_ep_data[result->pEpData[i].ep].m_strEP = result->pEpData[i].ep;
                iter->second->m_map_ep_data[result->pEpData[i].ep].m_strEPType = result->pEpData[i].epType;
                iter->second->m_map_ep_data[result->pEpData[i].ep].m_strEPName = result->pEpData[i].epName;
                iter->second->m_map_ep_data[result->pEpData[i].ep].m_strEPData = result->pEpData[i].epData;
                iter->second->m_map_ep_data[result->pEpData[i].ep].m_strEPStatus = result->pEpData[i].epStatus;
            }
        }
        else
        {
            CDevice *pDevice = new CDevice;
            pDevice->m_strGWID = result->gwID;
            pDevice->m_strID = result->devID;
            pDevice->m_strType = result->type;
            pDevice->m_strName = result->name;
            pDevice->m_strRoomID = result->roomID;
            pDevice->m_strCategory = result->category;
            pDevice->m_bOnline = true;
            pDevice->m_iEPCount = result->datacount;
            for (int i = 0; i < result->datacount; i++)
            {
                pDevice->m_map_ep_data[result->pEpData[i].ep].m_strEP = result->pEpData[i].ep;
                pDevice->m_map_ep_data[result->pEpData[i].ep].m_strEPType = result->pEpData[i].epType;
                pDevice->m_map_ep_data[result->pEpData[i].ep].m_strEPName = result->pEpData[i].epName;
                pDevice->m_map_ep_data[result->pEpData[i].ep].m_strEPData = result->pEpData[i].epData;
                pDevice->m_map_ep_data[result->pEpData[i].ep].m_strEPStatus = result->pEpData[i].epStatus;
                if (result->type == "22")	//∑¢ÀÕªÒ»°∫ÏÕ‚◊™∑¢∞¥º¸≈‰÷√–≈œ¢
                {
                    sendGetDevIRMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), result->gwID.c_str(), result->devID.c_str(), result->pEpData[i].ep.c_str());
                }
            }
            if ((result->type == "32")||(result->type == "33")||(result->type == "34"))
            {
                sendGetBindSceneMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), result->gwID.c_str(), result->devID.c_str());
            }
            m_map_id_str_device[result->gwID][result->devID] = pDevice;
        }
    }
    else if (fncode == DEVICE_DOWN)
    {
        bDevice = true;
        LP_DEVICE_DOWN result = (LP_DEVICE_DOWN)pdata;
        strID = result->gwID;
        strDeviceID = result->devID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            iter->second->m_bOnline = false;
        }
    }
    else if (fncode == GET_ROOM_INFO)
    {
        bArea = true;
        LP_GET_ROOM_INFO result = (LP_GET_ROOM_INFO)pdata;
        strID = result->gwID;
        for (int i = 0; i < result->datacount; i++)
        {
            ITER_MAP_STR_AREA iter = m_map_id_str_area[result->gwID].find(result->pRoomInfo[i].roomID);
            if (iter != m_map_id_str_area[result->gwID].end())
            {
                iter->second->m_strGWID = result->gwID;
                iter->second->m_strID = result->pRoomInfo[i].roomID;
                iter->second->m_strName = result->pRoomInfo[i].name;
                iter->second->m_strIcon = result->pRoomInfo[i].icon;
            }
            else
            {
                CArea *pArea = new CArea;
                pArea->m_strGWID = result->gwID;
                pArea->m_strID = result->pRoomInfo[i].roomID;
                pArea->m_strName = result->pRoomInfo[i].name;
                pArea->m_strIcon = result->pRoomInfo[i].icon;
                m_map_id_str_area[result->gwID][result->pRoomInfo[i].roomID] = pArea;
            }
        }
    }
    else if (fncode == GET_SCENE_INFO)
    {
        bScene = true;
        LP_GET_SCENE_INFO result = (LP_GET_SCENE_INFO)pdata;
        strID = result->gwID;
        for (int i = 0; i < result->datacount; i++)
        {
            ITER_MAP_STR_SCENE iter = m_map_id_str_scene[result->gwID].find(result->pSceneInfo[i].sceneID);
            if (iter != m_map_id_str_scene[result->gwID].end())
            {
                iter->second->m_strGWID = result->gwID;
                iter->second->m_strID = result->pSceneInfo[i].sceneID;
                if (result->pSceneInfo[i].name.bHasValue)
                {
                    iter->second->m_strName = result->pSceneInfo[i].name.strValue;
                }
                if (result->pSceneInfo[i].icon.bHasValue)
                {
                    iter->second->m_strIcon = result->pSceneInfo[i].icon.strValue;
                }
                if (result->pSceneInfo[i].status.bHasValue)
                {
                    iter->second->m_strStatus = result->pSceneInfo[i].status.strValue;
                }
            }
            else
            {
                CScene *pScene = new CScene;
                pScene->m_strGWID = result->gwID;
                pScene->m_strID = result->pSceneInfo[i].sceneID;
                if (result->pSceneInfo[i].name.bHasValue)
                {
                    pScene->m_strName = result->pSceneInfo[i].name.strValue;
                }
                if (result->pSceneInfo[i].icon.bHasValue)
                {
                    pScene->m_strIcon = result->pSceneInfo[i].icon.strValue;
                }
                if (result->pSceneInfo[i].status.bHasValue)
                {
                    pScene->m_strStatus = result->pSceneInfo[i].status.strValue;
                }
                m_map_id_str_scene[result->gwID][result->pSceneInfo[i].sceneID] = pScene;
                sendGetTaskMsg(m_map_str_gateway[strID]->m_strAppID.c_str(), result->gwID.c_str(), "-1", pScene->m_strID.c_str());
            }
        }
    }
    else if (fncode == GET_TASK_INFO)
    {
        bScene = true;
        LP_GET_TASK_INFO result = (LP_GET_TASK_INFO)pdata;
        strID = result->gwID;
        for (int i = 0; i < result->datacount; i++)
        {
            ITER_MAP_STR_SCENE iter = m_map_id_str_scene[result->gwID].find(result->pTaskInfo[i].sceneID);
            if (iter != m_map_id_str_scene[result->gwID].end())
            {
                CTask *pTask = new CTask;
                pTask->taskMode = result->pTaskInfo[i].taskMode;
                pTask->sceneID = result->pTaskInfo[i].sceneID;
                pTask->devID = result->pTaskInfo[i].devID;
                pTask->type = result->pTaskInfo[i].type;
                pTask->ep = result->pTaskInfo[i].ep;
                pTask->epType = result->pTaskInfo[i].epType;
                pTask->contentID = result->pTaskInfo[i].contentID;
                pTask->epData = result->pTaskInfo[i].epData;
                pTask->available = result->pTaskInfo[i].available;
                pTask->sensorID = result->pTaskInfo[i].sensorID;
                pTask->sensorEp = result->pTaskInfo[i].sensorEp;
                pTask->sensorType = result->pTaskInfo[i].sensorType;
                pTask->sensorName = result->pTaskInfo[i].sensorName;
                pTask->sensorCond = result->pTaskInfo[i].sensorCond;
                pTask->sensorData = result->pTaskInfo[i].sensorData;
                pTask->delay = result->pTaskInfo[i].delay;
                pTask->forward = result->pTaskInfo[i].forward;
                pTask->time = result->pTaskInfo[i].time;
                pTask->weekday = result->pTaskInfo[i].weekday;
                ITER_LIST_TASK it = iter->second->m_mapStrListTask[result->pTaskInfo[i].devID].begin();
                while (it != iter->second->m_mapStrListTask[result->pTaskInfo[i].devID].end())
                {
                    if ((**it) == (*pTask))
                    {
                        (**it) = (*pTask);
                        delete pTask;
                        break;
                    }
                    it++;
                }
                if (it == iter->second->m_mapStrListTask[result->pTaskInfo[i].devID].end())
                {
                    iter->second->m_mapStrListTask[result->pTaskInfo[i].devID].push_back(pTask);
                }
            }
        }
    }
    else if (fncode == GET_TIMED_SCENE)
    {
        bScene = true;
        LP_GET_TIMED_SCENE result = (LP_GET_TIMED_SCENE)pdata;
        
        strID = result->gwID;
        for (int i = 0; i < result->datacount; i++)
        {
            ITER_MAP_STR_TIME_SCENE iter = m_map_id_str_time_scene[result->gwID].find(result->pTDInfo[i].groupID);
            if (iter != m_map_id_str_time_scene[result->gwID].end())
            {
                iter->second->m_strGWID = result->gwID;
                iter->second->groupID = result->pTDInfo[i].groupID;
                iter->second->groupName = result->pTDInfo[i].groupName;
                //                if (result->pTDInfo[i].status == SCENE_ACTIVE)
                //                {
                //                    CTimedScene::m_strActiveID = result->pTDInfo[i].groupID.c_str();
                //                }
                CTimedSceneData ptr1;
                ptr1.sceneID = result->pTDInfo[i].sceneID.c_str();
                ptr1.time = result->pTDInfo[i].time.c_str();
                ptr1.weekday = result->pTDInfo[i].weekday.c_str();
                iter->second->vec_data.push_back(ptr1);
            }
            else
            {
                CTimedScene *pScene = new CTimedScene;
                pScene->m_strGWID = result->gwID;
                pScene->groupID = result->pTDInfo[i].groupID;
                pScene->groupName = result->pTDInfo[i].groupName;
                CTimedSceneData ptr1;
                ptr1.sceneID = result->pTDInfo[i].sceneID.c_str();
                ptr1.time = result->pTDInfo[i].time.c_str();
                ptr1.weekday = result->pTDInfo[i].weekday.c_str();
                pScene->vec_data.push_back(ptr1);
                m_map_id_str_time_scene[result->gwID][result->pTDInfo[i].groupID] = pScene;
            }
        }
    }
    else if (fncode == SET_DEVICE_INFO)
    {
        bDevice = true;
        LP_SET_DEVICE_INFO result = (LP_SET_DEVICE_INFO)pdata;
        strID = result->gwID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            if (atoi(result->mode.c_str()) == 0)
            {
                strDeviceID = result->devID;
                if (result->epStatus.bHasValue)
                {
                    iter->second->m_map_ep_data[result->ep].m_strEPStatus = result->epStatus.strValue;
                }
            }
            else if (atoi(result->mode.c_str()) == 2)
            {
                //–ﬁ∏ƒ£¨√˚≥∆°¢◊”√˚≥∆°¢¿‡±°¢∑øº‰≥ˆœ÷«Èøˆ≤ª“ª
                strDeviceID = result->devID;
                if (result->name.bHasValue)
                {
                    iter->second->m_strName = result->name.strValue;
                }
                if (result->roomID.bHasValue)
                {
                    iter->second->m_strRoomID = result->roomID.strValue;
                }
                if (result->category.bHasValue)
                {
                    iter->second->m_strCategory = result->category.strValue;
                }
                if (result->epName.bHasValue)
                {
                    iter->second->m_map_ep_data[result->ep].m_strEPName = result->epName.strValue;
                }
            }
            else if (atoi(result->mode.c_str()) == 3)
            {
                m_map_id_str_device[result->gwID].erase(iter);
            }
        }
    }
    else if (fncode == SET_ROOM_INFO)
    {
        bArea = true;
        LP_SET_ROOM_INFO result = (LP_SET_ROOM_INFO)pdata;
        strID = result->gwID;
        if (atoi(result->mode.c_str()) == 1)
        {
            //ÃÌº”
            strAreaID = result->roomInfo.roomID;
            CArea *pArea = new CArea;
            pArea->m_strGWID = result->gwID;
            pArea->m_strID = result->roomInfo.roomID;
            pArea->m_strName = result->roomInfo.name;
            pArea->m_strIcon = result->roomInfo.icon;
            m_map_id_str_area[result->gwID][result->roomInfo.roomID] = pArea;
        }
        else if (atoi(result->mode.c_str()) == 2)
        {
            //–ﬁ∏ƒ
            strAreaID = result->roomInfo.roomID;
            ITER_MAP_STR_AREA iter = m_map_id_str_area[result->gwID].find(result->roomInfo.roomID);
            if (iter != m_map_id_str_area[result->gwID].end())
            {
                iter->second->m_strIcon = result->roomInfo.icon;
                iter->second->m_strName = result->roomInfo.name;
            }
        }
        else if (atoi(result->mode.c_str()) == 3)
        {
            //…æ≥˝
            ITER_MAP_STR_AREA iter = m_map_id_str_area[result->gwID].find(result->roomInfo.roomID);
            if (iter != m_map_id_str_area[result->gwID].end())
            {
                delete iter->second;
                m_map_id_str_area[result->gwID].erase(iter);
            }
        }
    }
    else if (fncode == SET_SCENE_INFO)
    {
        bScene = true;
        LP_SET_SCENE_INFO result = (LP_SET_SCENE_INFO)pdata;
        strID = result->gwID;
        if (atoi(result->mode.c_str()) == 0)
        {
            //◊¥Ã¨£¨”¶∏√÷ª”–◊¥Ã¨
            for (ITER_MAP_STR_SCENE iter = m_map_id_str_scene[result->gwID].begin(); iter != m_map_id_str_scene[result->gwID].end(); iter++)
            {
                if (iter->second->m_strID == (std::string)result->sceneInfo.sceneID)
                {
                    iter->second->m_strStatus = "2";
                }
                else
                {
                    iter->second->m_strStatus = "1";
                }
            }
        }
        else if (atoi(result->mode.c_str()) == 1)
        {
            //ÃÌº”
            strSceneID = result->sceneInfo.sceneID;
            CScene *pScene = new CScene;
            pScene->m_strGWID = result->gwID;
            pScene->m_strID = result->sceneInfo.sceneID;
            if (result->sceneInfo.name.bHasValue)
            {
                pScene->m_strName = result->sceneInfo.name.strValue;
            }
            if (result->sceneInfo.icon.bHasValue)
            {
                pScene->m_strIcon = result->sceneInfo.icon.strValue;
            }
            if (result->sceneInfo.status.bHasValue)
            {
                pScene->m_strStatus = result->sceneInfo.status.strValue;
            }
            m_map_id_str_scene[result->gwID][result->sceneInfo.sceneID] = pScene;
        }
        else if (atoi(result->mode.c_str()) == 2)
        {
            //–ﬁ∏ƒ£¨”¶∏√÷ª”–√˚≥∆∫ÕÕº±Í
            strSceneID = result->sceneInfo.sceneID;
            ITER_MAP_STR_SCENE iter = m_map_id_str_scene[result->gwID].find(result->sceneInfo.sceneID);
            if (iter != m_map_id_str_scene[result->gwID].end())
            {
                if (result->sceneInfo.name.bHasValue)
                {
                    iter->second->m_strName = result->sceneInfo.name.strValue;
                }
                if (result->sceneInfo.icon.bHasValue)
                {
                    iter->second->m_strIcon = result->sceneInfo.icon.strValue;
                }
            }
        }
        else if (atoi(result->mode.c_str()) == 3)
        {
            //…æ≥˝
            ITER_MAP_STR_SCENE iter = m_map_id_str_scene[result->gwID].find(result->sceneInfo.sceneID);
            if (iter != m_map_id_str_scene[result->gwID].end())
            {
                delete iter->second;
                m_map_id_str_scene[result->gwID].erase(iter);
            }
        }
    }
    else if (fncode == SET_TASK_INFO)
    {
        bScene = true;
        LP_SET_TASK_INFO result = (LP_SET_TASK_INFO)pdata;
        strID = result->gwID;
        strSceneID = result->sceneID;
        if (result->datacount == 0)
        {
            //…æ≥˝’‚∏ˆ…Ë±∏µƒ»ŒŒÒ
            ITER_MAP_STR_SCENE iter = m_map_id_str_scene[result->gwID].find(result->sceneID);
            if (iter != m_map_id_str_scene[result->gwID].end())
            {
                for (ITER_LIST_TASK ita = iter->second->m_mapStrListTask[result->devID].begin(); ita != iter->second->m_mapStrListTask[result->devID].end();)
                {
                    if (((*ita)->devID == (std::string)result->devID)&&((*ita)->ep == (std::string)result->ep))
                    {
                        iter->second->m_mapStrListTask[result->devID].erase(ita++);
                        continue;
                    }
                    ita++;
                }
                if (iter->second->m_mapStrListTask[result->devID].size() == 0)
                {
                    iter->second->m_mapStrListTask.erase(result->devID);
                }
            }
        }
        else
        {
            strDeviceID = result->devID;
            for (int i = 0; i < result->datacount; i++)
            {
                ITER_MAP_STR_SCENE iter = m_map_id_str_scene[result->gwID].find(result->sceneID);
                if (iter != m_map_id_str_scene[result->gwID].end())
                {
                    CTask *pTask = new CTask;
                    pTask->taskMode = result->pTaskData[i].taskMode;
                    pTask->sceneID = result->sceneID;
                    pTask->devID = result->devID;
                    pTask->type = result->type;
                    pTask->ep = result->ep;
                    pTask->epType = result->epType;
                    pTask->contentID = result->pTaskData[i].contentID;
                    pTask->epData = result->pTaskData[i].epData;
                    pTask->available = result->pTaskData[i].available;
                    pTask->sensorID = result->pTaskData[i].sensorID;
                    pTask->sensorEp = result->pTaskData[i].sensorEp;
                    pTask->sensorType = result->pTaskData[i].sensorType;
                    pTask->sensorName = result->pTaskData[i].sensorName;
                    pTask->sensorCond = result->pTaskData[i].sensorCond;
                    pTask->sensorData = result->pTaskData[i].sensorData;
                    pTask->delay = result->pTaskData[i].delay;
                    pTask->forward = result->pTaskData[i].forward;
                    pTask->time = result->pTaskData[i].time;
                    pTask->weekday = result->pTaskData[i].weekday;
                    ITER_LIST_TASK it = iter->second->m_mapStrListTask[result->devID].begin();
                    while (it != iter->second->m_mapStrListTask[result->devID].end())
                    {
                        if ((**it) == (*pTask))
                        {
                            (**it) = (*pTask);
                            delete pTask;
                            break;
                        }
                        it++;
                    }
                    if (it == iter->second->m_mapStrListTask[result->devID].end())
                    {
                        iter->second->m_mapStrListTask[result->devID].push_back(pTask);
                    }
                }
            }
        }
    }
    else if (fncode == GET_DEVICE_IR_INFO)
    {
        LP_GET_DEVICE_IR_INFO result = (LP_GET_DEVICE_IR_INFO)pdata;
        strID = result->gwID;
        strDeviceID = result->devID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            if (result->ep == EP_ONE)
            {
                iter->second->m_map_code_irkey1.clear();
                for (int i = 0; i < result->datacount; i++)
                {
                    int icode = atoi(result->pDeviceIrInfo[i].code.c_str());
                    iter->second->m_map_code_irkey1[icode].code = result->pDeviceIrInfo[i].code;
                    iter->second->m_map_code_irkey1[icode].keyset = result->pDeviceIrInfo[i].keyset;
                    iter->second->m_map_code_irkey1[icode].name = result->pDeviceIrInfo[i].name;
                    iter->second->m_map_code_irkey1[icode].status = result->pDeviceIrInfo[i].status;
                }
            }
        }
    }
    else if (fncode == SET_DEVICE_IR_INFO)
    {
        LP_SET_DEVICE_IR_INFO result = (LP_SET_DEVICE_IR_INFO)pdata;
        strID = result->gwID;
        strDeviceID = result->devID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            if (result->ep == EP_ONE)
            {
                iter->second->m_map_code_irkey1.clear();
                for (int i = 0; i < result->datacount; i++)
                {
                    int icode = atoi(result->pDeviceIrInfo[i].code.c_str());
                    iter->second->m_map_code_irkey1[icode].code = result->pDeviceIrInfo[i].code;
                    iter->second->m_map_code_irkey1[icode].keyset = result->pDeviceIrInfo[i].keyset;
                    iter->second->m_map_code_irkey1[icode].name = result->pDeviceIrInfo[i].name;
                    iter->second->m_map_code_irkey1[icode].status = result->pDeviceIrInfo[i].status;
                }
            }
        }
    }
    else if (fncode == GET_BIND_SCENE_INFO)
    {
        LP_GET_BIND_SCENE_INFO result = (LP_GET_BIND_SCENE_INFO)pdata;
        strID = result->gwID;
        strDeviceID = result->devID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            iter->second->m_map_ep_scenekey.clear();
            for (int i = 0; i < result->datacount; i++)
            {
                iter->second->m_map_ep_scenekey[result->pBindSceneInfo[i].ep].ep = result->pBindSceneInfo[i].ep;
                iter->second->m_map_ep_scenekey[result->pBindSceneInfo[i].ep].sceneID = result->pBindSceneInfo[i].sceneID;
            }
        }
    }
    else if (fncode == SET_BIND_SCENE_INFO)
    {
        LP_SET_BIND_SCENE_INFO result = (LP_SET_BIND_SCENE_INFO)pdata;
        strID = result->gwID;
        strDeviceID = result->devID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            iter->second->m_map_ep_scenekey.clear();
            for (int i = 0; i < result->datacount; i++)
            {
                iter->second->m_map_ep_scenekey[result->pBindSceneInfo[i].ep].ep = result->pBindSceneInfo[i].ep;
                iter->second->m_map_ep_scenekey[result->pBindSceneInfo[i].ep].sceneID = result->pBindSceneInfo[i].sceneID;
            }
        }
    }
    else if (fncode == GUERY_DEV_RSSI)
    {
        LP_GUERY_DEV_RSSI result = (LP_GUERY_DEV_RSSI)pdata;
        strID = result->gwID;
        strDeviceID = result->devID;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[result->gwID].find(result->devID);
        if (iter != m_map_id_str_device[result->gwID].end())
        {
            iter->second->m_strRSSI = result->data;
        }
        
    }
    else if(fncode == GET_AUTO_PROGRAM)
    {
        bAuto = true;
        LP_GET_AUTO_PROGRAM result = (LP_GET_AUTO_PROGRAM)pdata;
        strID = result->gwID;
        for (int i = 0; i < result->rulecount; i++)
        {
            ITER_MAP_STR_AUTOPROGRAM iter = m_map_id_str_autoProgram[result->gwID].find(result->pAutoProgram[i].programID);
            if (iter != m_map_id_str_autoProgram[result->gwID].end())
            {
                iter->second->m_strGWID = result->gwID;
                iter->second->m_strProgramID = result->pAutoProgram[i].programID;
                iter->second->m_strProgramName = result->pAutoProgram[i].programName;
                iter->second->m_strProgramDesc = result->pAutoProgram[i].programDesc;
                iter->second->m_strProgramType = result->pAutoProgram[i].programType;
                iter->second->m_strStatus = result->pAutoProgram[i].status;
            }
            else
            {
                CAutoProgram *pAuto = new CAutoProgram;
                pAuto->m_strGWID = result->gwID;
                pAuto->m_strProgramID = result->pAutoProgram[i].programID;
                pAuto->m_strProgramName = result->pAutoProgram[i].programName;
                pAuto->m_strProgramDesc = result->pAutoProgram[i].programDesc;
                pAuto->m_strProgramType = result->pAutoProgram[i].programType;
                pAuto->m_strStatus = result->pAutoProgram[i].status;
                
                m_map_id_str_autoProgram[result->gwID][result->pAutoProgram[i].programID] = pAuto;
            }
        }
    }
    else if(fncode == SET_AUTO_PROGRAM)
    {
        bAuto = true;
        LP_SET_AUTO_PROGRAM result = (LP_SET_AUTO_PROGRAM)pdata;
        strID = result->gwID;
        if (result->operType == "D")
        {
            //…æ≥˝µ•∂¿¥¶¿Ì
            m_map_id_str_autoProgram[result->gwID].erase(std::string(result->programID));
            m_map_id_str_autoProgramDetail[result->gwID].erase(std::string(result->programID));
        }
        else if (result->operType == "S")
        {
            //–ﬁ∏ƒ◊¥Ã¨“≤“™µ•∂¿¥¶¿Ì
            ITER_MAP_STR_AUTOPROGRAM it =  m_map_id_str_autoProgram[result->gwID].find(result->programID);
            if (it != m_map_id_str_autoProgram[result->gwID].end())
            {
                m_map_id_str_autoProgram[result->gwID][result->programID]->m_strStatus = result->status;
            }
            ITER_MAP_STR_AUTOPROGRAMDETAIL it2 =  m_map_id_str_autoProgramDetail[result->gwID].find(result->programID);
            if (it2 != m_map_id_str_autoProgramDetail[result->gwID].end())
            {
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_strStatus = result->status;
            }
        }
        else if(result->operType == "C")
        {
            CAutoProgramDetail *pAutoDetail = new CAutoProgramDetail();
            
            pAutoDetail->m_strGWID = result->gwID;
            pAutoDetail->m_strProgramID = result->programID;
            pAutoDetail->m_strOperType = result->operType;
            pAutoDetail->m_strProgramName = result->programName;
            pAutoDetail->m_strProgramDesc = result->programDesc;
            pAutoDetail->m_strProgramType = result->programType;
            pAutoDetail->m_strStatus = result->status.c_str();
            
            for (int i = 0; i < result->triggercount; i++)
            {
                CAutoTrigger *at = new CAutoTrigger();
                at->type = result->pAPTrigger[i].type;
                at->object = result->pAPTrigger[i].object;
                at->exp = result->pAPTrigger[i].exp;
                pAutoDetail->m_list_trigger.push_back(at);
            }
            for (int i = 0; i < result->conditioncount; i++)
            {
                CAutoCondition *ac = new CAutoCondition();
                ac->exp = result->pAPCondition[i].exp;
                pAutoDetail->m_list_condition.push_back(ac);
            }
            for (int i = 0; i < result->actioncount; i++)
            {
                CAutoAction *aa = new CAutoAction();
                aa->sortNum = result->pAPAction[i].sortNum;
                aa->type = result->pAPAction[i].type;
                aa->object = result->pAPAction[i].object;
                aa->epData = result->pAPAction[i].epData;
                aa->description = result->pAPAction[i].description;
                aa->delay = result->pAPAction[i].delay;
                pAutoDetail->m_list_action.push_back(aa);
            }
            m_map_id_str_autoProgramDetail[result->gwID][result->programID] = pAutoDetail;
            
            CAutoProgram *pAuto = new CAutoProgram();
            pAuto->m_strGWID = result->gwID;
            pAuto->m_strProgramID = result->programID;
            pAuto->m_strProgramName = result->programName;
            pAuto->m_strProgramDesc = result->programDesc;
            pAuto->m_strStatus = result->status;
            pAuto->m_strProgramType = result->programType;
            m_map_id_str_autoProgram[result->gwID][result->programID] = pAuto;
        }
        else if(result->operType == "U" || result->operType == "R")
        {
            
            ITER_MAP_STR_AUTOPROGRAM it =  m_map_id_str_autoProgram[result->gwID].find(result->programID);
            if (it != m_map_id_str_autoProgram[result->gwID].end())
            {
                m_map_id_str_autoProgram[result->gwID][result->programID]->m_strGWID = result->gwID;
                m_map_id_str_autoProgram[result->gwID][result->programID]->m_strProgramID = result->programID;
                m_map_id_str_autoProgram[result->gwID][result->programID]->m_strProgramName = result->programName;
                m_map_id_str_autoProgram[result->gwID][result->programID]->m_strProgramDesc = result->programDesc;
                m_map_id_str_autoProgram[result->gwID][result->programID]->m_strProgramType = result->programType;
                m_map_id_str_autoProgram[result->gwID][result->programID]->m_strStatus = result->status;
            }
            
            ITER_MAP_STR_AUTOPROGRAMDETAIL it2 =  m_map_id_str_autoProgramDetail[result->gwID].find(result->programID);
            
            if (it2 != m_map_id_str_autoProgramDetail[result->gwID].end())
            {
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_strGWID = result->gwID;
                
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_strOperType = result->operType;
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_strProgramID = result->programID;
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_strProgramName = result->programName;
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_strProgramDesc = result->programDesc;
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_strProgramType = result->programType;
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_strStatus = result->status;
                
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_list_trigger.erase(it2->second->m_list_trigger.begin(), it2->second->m_list_trigger.end());
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_list_condition.erase(it2->second->m_list_condition.begin(), it2->second->m_list_condition.end());
                m_map_id_str_autoProgramDetail[result->gwID][result->programID]->m_list_action.erase(it2->second->m_list_action.begin(), it2->second->m_list_action.end());
                
                for (int i = 0; i < result->triggercount; i++)
                {
                    CAutoTrigger *at = new CAutoTrigger();
                    at->type = result->pAPTrigger[i].type.c_str();
                    at->object = result->pAPTrigger[i].object.c_str();
                    at->exp = result->pAPTrigger[i].exp.c_str();
                    it2->second->m_list_trigger.push_back(at);
                }
                for (int i = 0; i < result->conditioncount; i++)
                {
                    CAutoCondition *ac = new CAutoCondition();
                    ac->exp = result->pAPCondition[i].exp.c_str();
                    it2->second->m_list_condition.push_back(ac);
                }
                for (int i = 0; i < result->actioncount; i++)
                {
                    CAutoAction *aa = new CAutoAction();
                    aa->sortNum = result->pAPAction[i].sortNum.c_str();
                    aa->type = result->pAPAction[i].type.c_str();
                    aa->object = result->pAPAction[i].object.c_str();
                    aa->epData = result->pAPAction[i].epData.c_str();
                    aa->description = result->pAPAction[i].description.c_str();
                    aa->delay = result->pAPAction[i].delay.c_str();
                    it2->second->m_list_action.push_back(aa);
                }
                
            }
            else
            {
                CAutoProgramDetail *pAutoDetail = new CAutoProgramDetail();
                
                pAutoDetail->m_strGWID = result->gwID;
                pAutoDetail->m_strProgramID = result->programID;
                pAutoDetail->m_strOperType = result->operType;
                pAutoDetail->m_strProgramName = result->programName;
                pAutoDetail->m_strProgramDesc = result->programDesc;
                pAutoDetail->m_strProgramType = result->programType;
                pAutoDetail->m_strStatus = result->status.c_str();
                
                for (int i = 0; i < result->triggercount; i++)
                {
                    CAutoTrigger *at = new CAutoTrigger();
                    at->type = result->pAPTrigger[i].type;
                    at->object = result->pAPTrigger[i].object;
                    at->exp = result->pAPTrigger[i].exp;
                    pAutoDetail->m_list_trigger.push_back(at);
                }
                for (int i = 0; i < result->conditioncount; i++)
                {
                    CAutoCondition *ac = new CAutoCondition();
                    ac->exp = result->pAPCondition[i].exp;
                    pAutoDetail->m_list_condition.push_back(ac);
                }
                for (int i = 0; i < result->actioncount; i++)
                {
                    CAutoAction *aa = new CAutoAction();
                    aa->sortNum = result->pAPAction[i].sortNum;
                    aa->type = result->pAPAction[i].type;
                    aa->object = result->pAPAction[i].object;
                    aa->epData = result->pAPAction[i].epData;
                    aa->description = result->pAPAction[i].description;
                    aa->delay = result->pAPAction[i].delay;
                    pAutoDetail->m_list_action.push_back(aa);
                }
                m_map_id_str_autoProgramDetail[result->gwID][result->programID] = pAutoDetail;
            }
        }
    }
    else if(fncode == UPDATE_AUTO_PROGRAM)
    {
        //需要修改还没想好怎么改
    }
    else if (fncode == HANDLE_EXCEPTION)
    {
        LP_HANDLE_EXCEPTION result =  (LP_HANDLE_EXCEPTION)pdata;
        printf("exception gwID:%s cmd:%s", result->gwID.c_str(), result->cmd.c_str());
    }
    if (strID.length() > 0)
    {
        PackageMessage *msg = [[PackageMessage alloc] init];
        msg.m_strID = strID;
        msg.m_strAreaID = strAreaID;
        msg.m_strDeviceID = strDeviceID;
        msg.m_strSceneID = strSceneID;
        NSDictionary * notificationUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:msg,@"MSG",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:REVIEW_GATEWAY object:nil userInfo:notificationUserInfo];
        if (strID == m_strCurID)
        {
            if (bArea)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REVIEW_AREA object:nil userInfo:notificationUserInfo];
            }
            if (bDevice)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REVIEW_DEVICE object:nil userInfo:notificationUserInfo];
            }
            if (bScene)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REVIEW_SCENE object:nil userInfo:notificationUserInfo];
            }
            if (bAuto)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:REVIEW_AUTO object:nil userInfo:notificationUserInfo];
            }
            
        }
        //[msg release];
    }
}

@implementation AppDelegate

- (void)dealloc
{
    UnInit();
    std::for_each(m_map_str_gateway.begin(), m_map_str_gateway.end(), CCleanGateway());
    for (ITER_MAP_ID_STR_DEVICE iter = m_map_id_str_device.begin(); iter != m_map_id_str_device.end(); iter++)
    {
        std::for_each(iter->second.begin(), iter->second.end(), CCleanDevice());
    }
    for (ITER_MAP_ID_STR_AREA iter = m_map_id_str_area.begin(); iter != m_map_id_str_area.end(); iter++)
    {
        std::for_each(iter->second.begin(), iter->second.end(), CCleanArea());
    }
    for (ITER_MAP_ID_STR_SCENE iter = m_map_id_str_scene.begin(); iter != m_map_id_str_scene.end(); iter++)
    {
        std::for_each(iter->second.begin(), iter->second.end(), CCleanScene());
    }
    
    for (ITER_MAP_ID_STR_AUTOPROGRAM iter = m_map_id_str_autoProgram.begin(); iter != m_map_id_str_autoProgram.end(); iter++)
    {
        std::for_each(iter->second.begin(), iter->second.end(), CCleanAutoProgram());
    }
    
    for (ITER_MAP_ID_STR_AUTOPROGRAMDETAIL iter = m_map_id_str_autoProgramDetail.begin(); iter != m_map_id_str_autoProgramDetail.end(); iter++)
    {
        std::for_each(iter->second.begin(), iter->second.end(), CCleanAutoProgramDetail());
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //AddGateWayViewController *masterViewController = [[AddGateWayViewController alloc] init];
    //self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.backgroundColor=[UIColor whiteColor]; //.............
    self.window.rootViewController = [[AddGateWayViewController alloc]init];
    [self.window makeKeyAndVisible];
    //self.window.rootViewController = self.navigationController;
    //[self.window makeKeyAndVisible];
    
    NSString *appID = [OpenUDID value];
    m_strAppID = [appID UTF8String];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    m_strAppVer = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] UTF8String];
    
    srand((unsigned int)time(NULL));
    Init(myMessageCallback, NULL);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
