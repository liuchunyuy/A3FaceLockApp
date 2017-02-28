#pragma once

#include <map>
#include <list>
#include <algorithm>
#include <string>
#include <iostream>
#include <vector>

#define EP_ONE		"14"
#define EP_TWO		"15"
#define EP_THREE	"16"
#define EP_FOUR		"17"

#define CString             std::string
#define REVIEW_GATEWAY      @"Reviewgateway"
#define REVIEW_AREA         @"Reviewarea"
#define REVIEW_DEVICE       @"Reviewdevice"
#define REVIEW_SCENE        @"Reviewscene"
#define REVIEW_AUTO          @"ReviewAuto"
#define REVIEW_AUTO_DETTAIL   @"ReviewAutoDetail"

class CGateway
{
public:
	CGateway()
	{
		m_iServerStatus = -2;
		m_strData = "-2";
	}
	CString m_strID;
	CString m_strPW;
	CString m_strNewPW;
	CString m_strAppID;
	int m_iServerStatus;	//服务器状态：0连接成功,-1连接断开,-2连接中,-3初始化失败(connectDefault失败)
	CString m_strZone;
	CString m_strTime;
	CString m_strIP;
	CString m_strData;		//网关状态：0成功,-1失败,-2等待中,-3断开(调用了sendDisConnectGwMsg),11网关不在线,12网关ID错误,13密码错误,14更换新IP登录,21修改密码成功,22修改密码失败,31网关上线,32网关下线
};

class CCleanGateway
{
public:
	void operator()(std::pair<CString, CGateway*> getwaypair)
	{
		delete getwaypair.second;
	}
};

typedef std::map<CString, CGateway*> MAP_STR_GATEWAY;
typedef MAP_STR_GATEWAY::iterator ITER_MAP_STR_GATEWAY;

class CEPData
{
public:
	CString m_strEP;
	CString m_strEPType;
	CString m_strEPName;
	CString m_strEPData;
	CString m_strEPStatus;
};

class CIRKey
{
public:
	CIRKey()
	{
		status = "0";		//1为已学习，0为未学习
	}
	CString keyset;
	CString code;
	CString name;
	CString status;
};

class CBindSceneKey
{
public:
	CString ep;
	CString sceneID;
};

class CDevice
{
public:
	CString m_strGWID;
	CString m_strID;
	CString m_strType;
	CString m_strName;
	CString m_strCategory;
	CString m_strRoomID;
	bool m_bOnline;
	int m_iEPCount;
	std::map<CString, CEPData>	m_map_ep_data;				//<ep,数据>
	std::map<int, CIRKey>		m_map_code_irkey1;			//<code, irkey>,EP_ONE,有可能会有EP_TWO,EP_THREE,EP_FOUR
	std::map<CString, CBindSceneKey>	m_map_ep_scenekey;	//<ep, scenekey>
	CString m_strRSSI;
	bool Sceneable()
	{
		if ((m_strType == "02")||(m_strType == "03")||(m_strType == "04")||(m_strType == "05")||(m_strType == "07")||(m_strType == "09")
			||(m_strType == "11")||(m_strType == "12")||(m_strType == "13")||(m_strType == "15")||(m_strType == "16")
			||(m_strType == "22")||(m_strType == "26")||(m_strType == "27")||(m_strType == "28")
			||(m_strType == "50")||(m_strType == "51")||(m_strType == "52")
			||(m_strType == "57")||(m_strType == "58")||(m_strType == "59")
			||(m_strType == "61")||(m_strType == "62")||(m_strType == "63")||(m_strType == "64")
			||(m_strType == "65")||(m_strType == "66"))
		{
			return true;
		}
		return false;
	}
	bool Alarmable()
	{
		if ((m_strType == "02")||(m_strType == "03")||(m_strType == "04")||(m_strType == "05")||(m_strType == "07")||(m_strType == "09")
			||(m_strType == "10"))
		{
			return true;
		}
		return false;
	}
	bool Bindable()
	{
		if ((m_strType == "02")||(m_strType == "03")||(m_strType == "04")||(m_strType == "05")||(m_strType == "07")||(m_strType == "09")
			||(m_strType == "10")||(m_strType == "17")||(m_strType == "18")||(m_strType == "19")||(m_strType == "20")||(m_strType == "42"))
		{
			return true;
		}
		return false;
	}
	bool Safeable()
	{
		if ((m_strType == "02")||(m_strType == "03")||(m_strType == "04")||(m_strType == "05")||(m_strType == "07")||(m_strType == "09"))
		{
			return true;
		}
		return false;
	}
	bool Controlable()
	{
		if ((m_strType == "10")||(m_strType == "11")||(m_strType == "12")||(m_strType == "13")||(m_strType == "15")||(m_strType == "16")
			||(m_strType == "22")||(m_strType == "26")||(m_strType == "27")||(m_strType == "28")
			||(m_strType == "50")||(m_strType == "51")||(m_strType == "52")||(m_strType == "57")||(m_strType == "58")||(m_strType == "59")
			||(m_strType == "61")||(m_strType == "62")||(m_strType == "63")||(m_strType == "64")
			||(m_strType == "65")||(m_strType == "66")||(m_strType == "67")||(m_strType == "68"))
		{
			return true;
		}
		return false;
	}
	bool Sensorable()
	{
		if ((m_strType == "17")||(m_strType == "18")||(m_strType == "19")||(m_strType == "20")
			||(m_strType == "41")||(m_strType == "42")||(m_strType == "45")||(m_strType == "46"))
		{
			return true;
		}
		return false;
	}
	CString m_strOnData;
	CString m_strOffData;
	CString GetTaskData(const char *ep, bool bOn)
	{
		if (bOn)
		{
			if ((m_map_ep_data[ep].m_strEPType == "02")||(m_map_ep_data[ep].m_strEPType == "03")||(m_map_ep_data[ep].m_strEPType == "04")
				||(m_map_ep_data[ep].m_strEPType == "05")||(m_map_ep_data[ep].m_strEPType == "07")||(m_map_ep_data[ep].m_strEPType == "09"))
			{
				m_strOnData = "1";
			}
			else if ((m_map_ep_data[ep].m_strEPType == "11")||(m_map_ep_data[ep].m_strEPType == "12"))
			{
				m_strOnData = "100";
			}
			else if (m_map_ep_data[ep].m_strEPType == "15")
			{
				m_strOnData = "11";
			}
			else if (m_map_ep_data[ep].m_strEPType == "16")
			{
				m_strOnData = "1";
			}
			else if (m_map_ep_data[ep].m_strEPType == "22")
			{
				m_strOnData = "2511";
			}
			else if (m_map_ep_data[ep].m_strEPType == "26")
			{
				m_strOnData = "2";
			}
			else if (m_map_ep_data[ep].m_strEPType == "27")
			{
				m_strOnData = "2";
			}
			else if (m_map_ep_data[ep].m_strEPType == "28")
			{
				m_strOnData = "11";
			}
			else if ((m_strType == "50")||(m_strType == "51")||(m_strType == "52")
				||(m_strType == "57")||(m_strType == "58")||(m_strType == "59")
				||(m_strType == "61")||(m_strType == "62")||(m_strType == "63")||(m_strType == "64"))
			{
				m_strOnData = "1";
			}
			else if ((m_strType == "65")||(m_strType == "66"))
			{
				m_strOnData = "2";
			}
			else
			{
				m_strOnData = "";
			}
			return m_strOnData;
		}
		else
		{
			if ((m_map_ep_data[ep].m_strEPType == "02")||(m_map_ep_data[ep].m_strEPType == "03")||(m_map_ep_data[ep].m_strEPType == "04")
				||(m_map_ep_data[ep].m_strEPType == "05")||(m_map_ep_data[ep].m_strEPType == "07")||(m_map_ep_data[ep].m_strEPType == "09"))
			{
				m_strOffData = "0";
			}
			else if ((m_map_ep_data[ep].m_strEPType == "11")||(m_map_ep_data[ep].m_strEPType == "12"))
			{
				m_strOffData = "0";
			}
			else if (m_map_ep_data[ep].m_strEPType == "15")
			{
				m_strOffData = "10";
			}
			else if (m_map_ep_data[ep].m_strEPType == "16")
			{
				m_strOffData = "0";
			}
			else if (m_map_ep_data[ep].m_strEPType == "22")
			{
				m_strOffData = "2512";
			}
			else if (m_map_ep_data[ep].m_strEPType == "26")
			{
				m_strOffData = "3";
			}
			else if (m_map_ep_data[ep].m_strEPType == "27")
			{
				m_strOffData = "3";
			}
			else if (m_map_ep_data[ep].m_strEPType == "28")
			{
				m_strOffData = "10";
			}
			else if ((m_strType == "50")||(m_strType == "51")||(m_strType == "52")
				||(m_strType == "57")||(m_strType == "58")||(m_strType == "59")
				||(m_strType == "61")||(m_strType == "62")||(m_strType == "63")||(m_strType == "64"))
			{
				m_strOffData = "0";
			}
			else if ((m_strType == "65")||(m_strType == "66"))
			{
				m_strOffData = "3";
			}
			else
			{
				m_strOffData = "";
			}
			return m_strOffData;
		}
	}
};

class CCleanDevice
{
public:
	void operator()(std::pair<CString, CDevice*> devicepair)
	{
		delete devicepair.second;
	}
};

typedef std::map<CString, CDevice*> MAP_STR_DEVICE;
typedef MAP_STR_DEVICE::iterator ITER_MAP_STR_DEVICE;
typedef std::map<CString, MAP_STR_DEVICE> MAP_ID_STR_DEVICE;
typedef MAP_ID_STR_DEVICE::iterator ITER_MAP_ID_STR_DEVICE;

class CArea
{
public:
	CString m_strGWID;
	CString m_strID;
	CString m_strName;
	CString m_strIcon;
};

class CCleanArea
{
public:
	void operator()(std::pair<CString, CArea*> areapair)
	{
		delete areapair.second;
	}
};

typedef std::map<CString, CArea*> MAP_STR_AREA;
typedef MAP_STR_AREA::iterator ITER_MAP_STR_AREA;
typedef std::map<CString, MAP_STR_AREA> MAP_ID_STR_AREA;
typedef MAP_ID_STR_AREA::iterator ITER_MAP_ID_STR_AREA;

class CScene;
class CTask
{
public:
	CTask(){}
	~CTask(){}
	CTask(CTask &obj)
	{
		this->taskMode = obj.taskMode;
		this->sceneID = obj.sceneID;
		this->devID = obj.devID;
		this->type = obj.type;
		this->ep = obj.ep;
		this->epType = obj.epType;
		this->contentID = obj.contentID;
		this->epData = obj.epData;
		this->available = obj.available;
		this->sensorID = obj.sensorID;
		this->sensorEp = obj.sensorEp;
		this->sensorType = obj.sensorType;
		this->sensorName = obj.sensorName;
		this->sensorCond = obj.sensorCond;
		this->sensorData = obj.sensorData;
		this->delay = obj.delay;
		this->forward = obj.forward;
		this->time = obj.time;
		this->weekday = obj.weekday;
	}
	CTask& operator = (CTask &obj)
	{
		if (this == &obj)
		{
			return *this;
		}
		this->taskMode = obj.taskMode;
		this->sceneID = obj.sceneID;
		this->devID = obj.devID;
		this->type = obj.type;
		this->ep = obj.ep;
		this->epType = obj.epType;
		this->contentID = obj.contentID;
		this->epData = obj.epData;
		this->available = obj.available;
		this->sensorID = obj.sensorID;
		this->sensorEp = obj.sensorEp;
		this->sensorType = obj.sensorType;
		this->sensorName = obj.sensorName;
		this->sensorCond = obj.sensorCond;
		this->sensorData = obj.sensorData;
		this->delay = obj.delay;
		this->forward = obj.forward;
		this->time = obj.time;
		this->weekday = obj.weekday;
		return *this;
	}
	bool operator == (CTask &obj)
	{
		if (this == &obj)
		{
			return true;
		}
		if ((this->sceneID == obj.sceneID)
			&&(this->devID == obj.devID)
			&&(this->ep == obj.ep)
			&&(this->contentID == obj.contentID)
			&&(this->taskMode == obj.taskMode))
		{
			return true;
		}
		return false;
	}
	void Clean(const char *taskMode, const char *sceneID, CDevice *pDevice, const char *ep, bool bOn)
	{
		this->taskMode = taskMode;
		this->sceneID = sceneID;
		this->devID = pDevice->m_strID;
		this->type = pDevice->m_strType;
		this->ep = ep;
		this->epType = pDevice->m_map_ep_data[ep].m_strEPType;
		this->contentID = bOn?"2":"3";
		this->epData = pDevice->GetTaskData(ep, bOn);
		this->available = "0";
		this->sensorID = "-1";
		this->sensorEp = "";
		this->sensorType = "";
		this->sensorName = "";
		this->sensorCond = "";
		this->sensorData = "";
		this->delay = "0";
		this->forward = "0";
		if (strcmp(taskMode, "2") == 0)		//定时任务
		{
			this->time = "00:00:00";
			this->weekday = "0,0,0,0,0,0,0";
		}
		else
		{
			this->time = "";
			this->weekday = "";
		}
	}
	CString taskMode;
	CString sceneID;
	CString devID;
	CString type;
	CString ep;
	CString epType;
	CString contentID;
	CString epData;
	CString available;
	CString sensorID;
	CString sensorEp;
	CString sensorType;
	CString sensorName;
	CString sensorCond;
	CString sensorData;
	CString delay;
	CString forward;
	CString time;
	CString weekday;
};

class CCleanTask
{
public:
	void operator()(CTask *pTask)
	{
		delete pTask;
	}
};

typedef std::list<CTask*> LIST_TASK;
typedef LIST_TASK::iterator ITER_LIST_TASK;
typedef std::map<CString, LIST_TASK> MAP_STR_LIST_TASK;		//设备ID和它的所有ep动作
typedef MAP_STR_LIST_TASK::iterator ITER_MAP_STR_LIST_TASK;

class CScene
{
public:
	CString m_strGWID;
	CString m_strID;
	CString m_strName;
	CString m_strIcon;
	CString m_strStatus;
	MAP_STR_LIST_TASK m_mapStrListTask;
};


class CCleanScene
{
public:
	void operator()(std::pair<CString, CScene*> scenepair)
	{
		for (ITER_MAP_STR_LIST_TASK iter = scenepair.second->m_mapStrListTask.begin(); iter != scenepair.second->m_mapStrListTask.end(); iter++)
		{
			std::for_each(iter->second.begin(), iter->second.end(), CCleanTask());
		}
		delete scenepair.second;
	}
};


typedef std::map<CString, CScene*> MAP_STR_SCENE;
typedef MAP_STR_SCENE::iterator ITER_MAP_STR_SCENE;
typedef std::map<CString, MAP_STR_SCENE> MAP_ID_STR_SCENE;
typedef MAP_ID_STR_SCENE::iterator ITER_MAP_ID_STR_SCENE;

class CTimedSceneData
{
public:
    CString sceneID;
    CString time;
    CString weekday;
};

typedef std::vector<CTimedSceneData> vec_CTimedSceneData;

class CTimedScene
{
public:
    CString groupID;
    CString groupName;
    CString m_strGWID;
    //static CString m_strActiveID;
    vec_CTimedSceneData vec_data;
};

//class CCleanTimedScene
//{
//public:
//    void operator()(std::pair<CString, CTimedScene*> scenepair)
//    {
//        for (ITER_MAP_STR_LIST_TASK iter = scenepair.second->m_mapStrListTask.begin(); iter != scenepair.second->m_mapStrListTask.end(); iter++)
//        {
//            std::for_each(iter->second.begin(), iter->second.end(), CCleanTask());
//        }
//        delete scenepair.second;
//    }
//};


typedef std::map<CString, CTimedScene*> MAP_STR_TIME_SCENE;
typedef MAP_STR_TIME_SCENE::iterator ITER_MAP_STR_TIME_SCENE;
typedef std::map<CString, MAP_STR_TIME_SCENE> MAP_ID_STR_TIME_SCENE;
typedef MAP_ID_STR_TIME_SCENE::iterator ITER_MAP_ID_STR_TIME_SCENE;




class CAutoTrigger
{
public:
    CString type;
    CString object;
    CString exp;
};

class CCleanAutoTrigger
{
public:
    void operator()(CAutoTrigger *pTrigger)
    {
        delete pTrigger;
    }
};

typedef std::list<CAutoTrigger*> LIST_AUTOTRIGGER;
typedef LIST_AUTOTRIGGER::iterator ITER_LIST_AUTOTRIGGER;
typedef std::map<CString, LIST_AUTOTRIGGER> MAP_STR_LIST_AUTOTRIGGER;
typedef MAP_STR_LIST_AUTOTRIGGER::iterator ITER_MAP_STR_LIST_AUTOTRIGGER;

class CAutoCondition
{
public:
    CString exp;
};

class CCleanAutoCondition
{
public:
    void operator()(CAutoCondition *pCondition)
    {
        delete pCondition;
    }
};


typedef std::list<CAutoCondition*> LIST_AUTOCONDITION;
typedef LIST_AUTOCONDITION::iterator ITER_LIST_AUTOCONDITION;
typedef std::map<CString, LIST_AUTOCONDITION> MAP_STR_LIST_AUTOCONDITION;
typedef MAP_STR_LIST_AUTOCONDITION::iterator ITER_MAP_STR_LIST_AUTOCONDITION;

class CAutoAction
{
public:
    CString sortNum;
    CString type;
    CString object;
    CString epData;
    CString description;
    CString delay;
};

class CCleanAutoAction
{
public:
    void operator()(CAutoAction *pAction)
    {
        delete pAction;
    }
};


typedef std::list<CAutoAction*> LIST_AUTOACTION;
typedef LIST_AUTOACTION::iterator ITER_LIST_AUTOACTION;
typedef std::map<CString, LIST_AUTOACTION> MAP_STR_LIST_AUTOACTION;
typedef MAP_STR_LIST_AUTOACTION::iterator ITER_MAP_STR_LIST_AUTOACTION;


class CAutoProgram
{
public:
    CString m_strGWID;
    CString m_strProgramID;
    CString m_strProgramName;
    CString m_strProgramDesc;
    CString m_strProgramType;
    CString m_strStatus;
};
class CCleanAutoProgram
{
public:
    void operator()(std::pair<CString, CAutoProgram*> autoProgramPair)
    {
        delete autoProgramPair.second;
    }
};



typedef std::map<CString, CAutoProgram*> MAP_STR_AUTOPROGRAM;
typedef MAP_STR_AUTOPROGRAM::iterator ITER_MAP_STR_AUTOPROGRAM;
typedef std::map<CString, MAP_STR_AUTOPROGRAM> MAP_ID_STR_AUTOPROGRAM;
typedef MAP_ID_STR_AUTOPROGRAM::iterator ITER_MAP_ID_STR_AUTOPROGRAM;


class CAutoProgramDetail
{
public:
    CString m_strGWID;
    CString m_strOperType;
    CString m_strProgramID;
    CString m_strProgramName;
    CString m_strProgramDesc;
    CString m_strProgramType;
    CString m_strStatus;
    
    LIST_AUTOTRIGGER m_list_trigger;
    LIST_AUTOCONDITION m_list_condition;
    LIST_AUTOACTION m_list_action;
    
    //MAP_STR_LIST_AUTOTRIGGER m_map_str_trigger;
    //MAP_STR_LIST_AUTOCONDITION m_map_str_condition;
    //MAP_STR_LIST_AUTOACTION m_map_str_action;
    
};

class CCleanAutoProgramDetail
{
public:
    void operator()(std::pair<CString, CAutoProgramDetail*> autoProgramPair)
    {
       
            std::for_each(autoProgramPair.second->m_list_trigger.begin(), autoProgramPair.second->m_list_trigger.end(), CCleanAutoTrigger());
      
      
            std::for_each(autoProgramPair.second->m_list_condition.begin(), autoProgramPair.second->m_list_condition.end(), CCleanAutoCondition());
      
      
            std::for_each(autoProgramPair.second->m_list_action.begin(), autoProgramPair.second->m_list_action.end(), CCleanAutoAction());
        
        delete autoProgramPair.second;
    }
};


typedef std::map<CString, CAutoProgramDetail*> MAP_STR_AUTOPROGRAMDETAIL;
typedef MAP_STR_AUTOPROGRAMDETAIL::iterator ITER_MAP_STR_AUTOPROGRAMDETAIL;
typedef std::map<CString, MAP_STR_AUTOPROGRAMDETAIL> MAP_ID_STR_AUTOPROGRAMDETAIL;
typedef MAP_ID_STR_AUTOPROGRAMDETAIL::iterator ITER_MAP_ID_STR_AUTOPROGRAMDETAIL;



extern MAP_STR_GATEWAY m_map_str_gateway;
extern MAP_ID_STR_DEVICE m_map_id_str_device;
extern MAP_ID_STR_AREA m_map_id_str_area;
extern MAP_ID_STR_SCENE m_map_id_str_scene;
extern MAP_ID_STR_AUTOPROGRAM m_map_id_str_autoProgram;
extern MAP_ID_STR_AUTOPROGRAMDETAIL m_map_id_str_autoProgramDetail;
extern std::string m_strCurID;
extern std::string m_strAppID;
extern std::string m_strAppVer;
extern std::string m_strChangePw;
