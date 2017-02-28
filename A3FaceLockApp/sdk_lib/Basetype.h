#pragma once

#include <assert.h>
#include <string>
#include <string.h>

#define DEV_ID_LENGTH	16		//设备ID的长度目前都是16位
#define DEV_ID_LENGTH_WITH_EP	18		//设备ID+EP的长度目前都是18位

typedef const char *  CPCHAR;
typedef char * PCHAR;

typedef struct _tag_chString
{
	static void copystr(char *dst, char *src, int size)
	{
		if (size > 0)
		{
			memcpy(dst, src, size);
		}
	}
protected:
	_tag_chString(const _tag_chString &obj, unsigned int start, unsigned int count)
	{
		buf = new char[1];
		memset(buf, 0, 1);
		iLen = 0;
		
		if (obj.iLen == 0)
		{
			return;
		}
		if (count == 0)
		{
			count = obj.iLen - start;
		}
		if (start + count > obj.iLen)
		{
			count = obj.iLen - start;
		}
		growstr(count);
		copystr(buf, obj.buf + start, count);
		iLen = count;
	}
public:
	_tag_chString()
	{
		buf = new char[1];
		memset(buf, 0, 1);
		iLen = 0;
	}
	_tag_chString(const _tag_chString &obj)
	{
		buf = new char[1];
		memset(buf, 0, 1);
		iLen = 0;
		growstr(obj.iLen);
		copystr(buf, obj.buf, obj.iLen);
		iLen = obj.iLen;
	}
	~_tag_chString()
	{
		if (buf != NULL)
		{
			delete [] buf;
		}
	}
	bool operator != (const char *str)
	{
		assert(str != NULL);
		if (strcmp(buf, str) == 0)
		{
			return false;
		}
		return true;
	}
	bool operator == (const char *str)
	{
		assert(str != NULL);
		if (strcmp(buf, str) == 0)
		{
			return true;
		}
		return false;
	}
	bool operator != (const std::string &obj)
	{
		if (strcmp(buf, obj.c_str()) == 0)
		{
			return false;
		}
		return true;
	}
	bool operator == (const std::string &obj)
	{
		if (strcmp(buf, obj.c_str()) == 0)
		{
			return true;
		}
		return false;
	}
	_tag_chString& operator += (const char *str)
	{
		assert(str != NULL);
		unsigned int tempLen = strlen(str);
		growstr(tempLen);
		copystr(buf + iLen, (char*)str, tempLen);
		iLen += tempLen;
		return *this;
	}
	_tag_chString& operator = (const char *str)
	{
		assert(str != NULL);
		erasestr();
		unsigned int tempLen = strlen(str);
		growstr(tempLen);
		copystr(buf, (char*)str, tempLen);
		iLen = tempLen;
		return *this;
	}
	_tag_chString& operator += (const _tag_chString &obj)
	{
		_tag_chString tempstr = obj;
		unsigned int tempLen = tempstr.iLen;
		growstr(tempLen);
		copystr(buf + iLen, tempstr.buf, tempLen);
		iLen += tempLen;
		return *this;
	}
	_tag_chString& operator = (const _tag_chString &obj)
	{
		if (&obj == this)
		{
			return *this;
		}
		erasestr();
		growstr(obj.iLen);
		copystr(buf, obj.buf, obj.iLen);
		iLen = obj.iLen;
		return *this;
	}
	_tag_chString& operator += (const std::string &obj)
	{
		unsigned int tempLen = obj.length();
		growstr(tempLen);
		copystr(buf + iLen, (char*)obj.c_str(), tempLen);
		iLen += tempLen;
		return *this;
	}
	_tag_chString& operator = (const std::string &obj)
	{
		erasestr();
		growstr(obj.length());
		copystr(buf, (char*)obj.c_str(), obj.length());
		iLen = obj.length();
		return *this;
	}
	const char* c_str()
	{
		return buf;
	}
	unsigned int length()
	{
		return iLen;
	}
	_tag_chString substr(unsigned int start, unsigned int count = 0)
	{
		return _tag_chString(*this, start, count);
	}
	operator std::string()
	{
		return std::string(c_str());
	}
private:
	void growstr(int igrow)
	{
		if (igrow > 0)
		{
			char *tempBuf = new char[igrow + iLen + 1];
			memset(tempBuf, 0, igrow + iLen + 1);
			copystr(tempBuf, buf, iLen);
			delete[] buf;
			buf = tempBuf;
		}
	}
	void erasestr()
	{
		delete [] buf;
		buf = new char[1];
		memset(buf, 0, 1);
		iLen = 0;
	}
	char *buf;
	unsigned int iLen;
	
}chString,*LP_chString;

typedef struct _tag_String
{
	_tag_String()
	{
		bHasValue = false;
	}
	_tag_String& operator = (const std::string &str)
	{
		bHasValue = true;
		strValue = str;
		return *this;
	}
	bool bHasValue;
	chString strValue;
}String,*LP_String;

//SDK函数操作返回
//ERR_SUCCESS表示操作成功，并不表示结果成功
//结果是否成功要看回调函数的iResult值
#define ERR_SUCCESS				(0)		//操作成功
#define ERR_NO_INIT				(-1)	//没有启动
#define ERR_ALREADY_INITED		(-2)	//已经启动
#define ERR_NO_MEMORY			(-3)	//内存不足
#define ERR_PARAM				(-4)	//参数错误
#define ERR_NO_CONNECT			(-5)	//未连接
#define ERR_CERTIFICATION		(-6)	//证书错误
#define ERR_LIMITED_CONN		(-7)	//只能有一个连接
#define ERR_ALREADY_CONN		(-8)	//已经连接
#define ERR_NONSUPPORT			(-9)	//不支持
#define ERR_TIMEOUT				(-10)	//超时
#define ERR_FALSE				(-11)	//就是单纯的失败

//基础结构体，所有类型从这里派生
typedef struct _tag_BASE_SDK
{
	chString appID;
	chString gwID;
}_BASE_SDK,*LP_BASE_SDK;

typedef struct _tag_SDK_DEBUG_MSG : public _tag_BASE_SDK
{
	chString cmdType;
	chString cmd;
}_SDK_DEBUG_MSG,*LP_SDK_DEBUG_MSG;

//回调函数的消息类型
//0.域名解析结果及结构
#define DOMAIN_RESOVLE			100						//域名解析结果消息
typedef struct _tag_DOMAIN_RESOVLE
{
	int iResult;
}_DOMAIN_RESOVLE,*LP_DOMAIN_RESOVLE;

//1.服务器连接消息及结构
#define CONNECT_SERVER			DOMAIN_RESOVLE+1		//服务器连接消息
typedef struct _tag_CONNECT_SERVER : public _tag_BASE_SDK
{
	int iResult;
}_CONNECT_SERVER,*LP_CONNECT_SERVER;

//DOMAIN_RESOVLE和CONNECT_SERVER的结果
#define CALLBACK_SUCCESS		(0)		//成功
#define CALLBACK_PROCESSING		(1)		//处理中
#define CALLBACK_FAILED			(-1)	//失败
#define CALLBACK_TIMEOUT		(-2)	//超时
#define CALLBACK_BREAK			(-3)	//断开

//2.网关连接消息及结构
#define CONNECT_GATEWAY			CONNECT_SERVER+1		//网关连接消息
typedef struct _tag_GATEWAY_INFO : public _tag_BASE_SDK
{
    _tag_GATEWAY_INFO()
    {
        gwSpan = 0;
    }
	chString gwIP;
	chString gwSerIP;
	chString gwRealSerIP;
	chString gwZone;
	chString gwTime;
	chString gwData;
    chString gwType;
    chString managerGWID;
	long gwSpan;
}_GATEWAY_INFO,*LP_GATEWAY_INFO;

//3.网关断开消息及结构
#define DISCONNECT_GATEWAY		CONNECT_GATEWAY+1		//网关断开消息
typedef struct _tag_DISCONNECT_GATEWAY : public _tag_BASE_SDK
{
	chString gwData;
}_DISCONNECT_GATEWAY,*LP_DISCONNECT_GATEWAY;

//4.修改网关密码消息及结构
#define CHANGE_GATEWAY_PW		DISCONNECT_GATEWAY+1		//修改网关密码消息
typedef struct _tag_CHANGE_GATEWAY_PW : public _tag_BASE_SDK
{
	chString gwData;
}_CHANGE_GATEWAY_PW,*LP_CHANGE_GATEWAY_PW;

//5.设备数据消息及结构
#define DEVICE_DATA				CHANGE_GATEWAY_PW+1		//设备数据消息
typedef struct _tag_DEVICE_DATA : public _tag_BASE_SDK
{
	chString devID;
	chString ep;
	chString epType;
	chString epData;
	chString time;
	chString epMsg;
}_DEVICE_DATA,*LP_DEVICE_DATA;

//6.网关上线
#define GATEWAY_UP				DEVICE_DATA+1		//网关上线消息
typedef struct _tag_GATEWAY_UP : public _tag_BASE_SDK
{
	chString gwVer;
}_GATEWAY_UP,*LP_GATEWAY_UP;

//7.网关下线
#define GATEWAY_DOWN				GATEWAY_UP+1		//网关下线消息
typedef struct _tag_GATEWAY_DOWN : public _tag_BASE_SDK
{
}_GATEWAY_DOWN,*LP_GATEWAY_DOWN;

//8.设备上线
#define DEVICE_UP					GATEWAY_DOWN+1		//设备上线消息
#define OFFLINE_DEVICE_UP			DEVICE_UP+1			//断线设备上线消息
typedef struct _tag_DEVICE_EP_DATA
{
	chString ep;
	chString epType;
	chString epName;
	chString epData;
	chString epStatus;
}_DEVICE_EP_DATA,*LP_DEVICE_EP_DATA;
typedef struct _tag_DEVICE_UP : public _tag_BASE_SDK
{
	_tag_DEVICE_UP()
	{
		datacount = 0;
		pEpData = NULL;
	}
	chString devID;
	chString type;
	chString name;
	chString category;
	chString roomID;
	String isNew;
	String isDreamflower;
	int datacount;
	LP_DEVICE_EP_DATA pEpData;
}_DEVICE_UP,*LP_DEVICE_UP;

//9.设备下线
#define DEVICE_DOWN				OFFLINE_DEVICE_UP+1		//设备下线消息
typedef struct _tag_DEVICE_DOWN : public _tag_BASE_SDK
{
	chString devID;
}_DEVICE_DOWN,*LP_DEVICE_DOWN;

//10.获取房间列表信息
#define GET_ROOM_INFO			DEVICE_DOWN+1		//获取房间列表信息消息
typedef struct _tag_ROOM_INFO
{
	chString roomID;
	chString name;
	chString icon;
}_ROOM_INFO, *LP_ROOM_INFO;
typedef struct _tag_GET_ROOM_INFO : public _tag_BASE_SDK
{
	_tag_GET_ROOM_INFO()
	{
		datacount = 0;
		pRoomInfo = NULL;
	}
	int datacount;
	LP_ROOM_INFO pRoomInfo;
}_GET_ROOM_INFO,*LP_GET_ROOM_INFO;

//11.获取场景列表信息
#define GET_SCENE_INFO			GET_ROOM_INFO+1		//获取场景列表信息消息
typedef struct _tag_SCENE_INFO
{
	chString sceneID;
	String name;
	String status;
	String icon;
}_SCENE_INFO, *LP_SCENE_INFO;
typedef struct _tag_GET_SCENE_INFO : public _tag_BASE_SDK
{
	_tag_GET_SCENE_INFO()
	{
		datacount = 0;
		pSceneInfo = NULL;
	}
	int datacount;
	LP_SCENE_INFO pSceneInfo;
}_GET_SCENE_INFO,*LP_GET_SCENE_INFO;

//12.获取任务列表信息
#define GET_TASK_INFO			GET_SCENE_INFO+1		//获取任务列表信息消息
typedef struct _tag_TASK_INFO
{
	chString taskMode;
	chString sceneID;
	chString devID;
	chString type;
	chString ep;
	chString epType;
	chString contentID;
	chString epData;
	chString available;
	String	 mutilLinkage;
	chString sensorID;
	chString sensorEp;
	chString sensorType;
	chString sensorName;
	chString sensorCond;
	chString sensorData;
	chString delay;
	chString forward;
	chString time;
	chString weekday;
}_TASK_INFO, *LP_TASK_INFO;
typedef struct _tag_GET_TASK_INFO : public _tag_BASE_SDK
{
	_tag_GET_TASK_INFO()
	{
		datacount = 0;
		pTaskInfo = NULL;
	}
	chString version;
	String sceneID;
	int datacount;
	LP_TASK_INFO pTaskInfo;
}_GET_TASK_INFO,*LP_GET_TASK_INFO;

//13.设置设备信息
#define SET_DEVICE_INFO			GET_TASK_INFO+1		//设置设备信息消息
typedef struct _tag_SET_DEVICE_INFO : public _tag_BASE_SDK
{
	chString mode;
	chString devID;
	chString type;
	String name;
	String category;
	String roomID;
	chString ep;
	chString epType;
	String epName;
	String epStatus;
}_SET_DEVICE_INFO,*LP_SET_DEVICE_INFO;

//14.设置房间信息
#define SET_ROOM_INFO			SET_DEVICE_INFO+1		//设置房间信息消息
typedef struct _tag_SET_ROOM_INFO : public _tag_BASE_SDK
{
	chString mode;
	_ROOM_INFO roomInfo;
}_SET_ROOM_INFO,*LP_SET_ROOM_INFO;

//15.设置场景信息
#define SET_SCENE_INFO			SET_ROOM_INFO+1		//设置场景信息消息
typedef struct _tag_SET_SCENE_INFO : public _tag_BASE_SDK
{
	chString mode;
	_SCENE_INFO sceneInfo;
}_SET_SCENE_INFO,*LP_SET_SCENE_INFO;

//16.设置任务信息
#define SET_TASK_INFO			SET_SCENE_INFO+1		//设置任务信息消息
typedef struct _tag_TASK_DATA
{
	chString mode;
	chString taskMode;
	chString contentID;
	chString epData;
	chString available;
	String	 mutilLinkage;
	chString sensorID;
	chString sensorEp;
	chString sensorType;
	chString sensorName;
	chString sensorCond;
	chString sensorData;
	chString delay;
	chString forward;
	chString time;
	chString weekday;
}_TASK_DATA,*LP_TASK_DATA;
typedef struct _tag_SET_TASK_INFO : public _tag_BASE_SDK
{
	_tag_SET_TASK_INFO()
	{
		datacount = 0;
		pTaskData = NULL;
		version = "-1";		//如果服务器没有返回ver，统统都改为"-1"
	}
	chString version;
	chString sceneID;
	chString devID;
	chString type;
	chString ep;
	chString epType;
	int datacount;
	LP_TASK_DATA pTaskData;
}_SET_TASK_INFO,*LP_SET_TASK_INFO;

//17.获取红外转发按键信息
#define GET_DEVICE_IR_INFO		SET_TASK_INFO+1			//获取红外转发按键信息消息
typedef struct _tag_DEVICE_IR_INFO
{
	chString keyset;
	chString irType;
	chString code;
	chString name;
	chString status;
}_DEVICE_IR_INFO,*LP_DEVICE_IR_INFO;
typedef struct _tag_GET_DEVICE_IR_INFO : public _tag_BASE_SDK
{
	_tag_GET_DEVICE_IR_INFO()
	{
		datacount = 0;
		pDeviceIrInfo = NULL;
	}
	chString devID;
	chString ep;
	chString mode;
	chString irType;
	int datacount;
	LP_DEVICE_IR_INFO pDeviceIrInfo;
}_GET_DEVICE_IR_INFO,*LP_GET_DEVICE_IR_INFO;

//18.设置红外转发按键信息
#define SET_DEVICE_IR_INFO		GET_DEVICE_IR_INFO+1	//设置红外转发按键信息消息
typedef struct _tag_SET_DEVICE_IR_INFO : public _tag_BASE_SDK
{
	_tag_SET_DEVICE_IR_INFO()
	{
		datacount = 0;
		pDeviceIrInfo = NULL;
	}
	chString devID;
	chString ep;
	chString mode;
	chString irType;
	int datacount;
	LP_DEVICE_IR_INFO pDeviceIrInfo;
}_SET_DEVICE_IR_INFO,*LP_SET_DEVICE_IR_INFO;

//19.获取绑定场景信息
#define GET_BIND_SCENE_INFO		SET_DEVICE_IR_INFO+1	//获取绑定场景信息消息
typedef struct _tag_BIND_SCENE_INFO
{
	chString ep;
	chString sceneID;
	chString devID;
	chString devEP;
	chString devData;
}_BIND_SCENE_INFO,*LP_BIND_SCENE_INFO;
typedef struct _tag_GET_BIND_SCENE_INFO : public _tag_BASE_SDK
{
	_tag_GET_BIND_SCENE_INFO()
	{
		datacount = 0;
		pBindSceneInfo = NULL;
	}
	chString devID;
	int datacount;
	LP_BIND_SCENE_INFO pBindSceneInfo;
}_GET_BIND_SCENE_INFO,*LP_GET_BIND_SCENE_INFO;

//20.设置绑定场景信息
#define SET_BIND_SCENE_INFO		GET_BIND_SCENE_INFO+1	//设置绑定场景信息消息
typedef struct _tag_SET_BIND_SCENE_INFO : public _tag_BASE_SDK
{
	_tag_SET_BIND_SCENE_INFO()
	{
		datacount = 0;
		pBindSceneInfo = NULL;
	}
	chString devID;
	int datacount;
	LP_BIND_SCENE_INFO pBindSceneInfo;
}_SET_BIND_SCENE_INFO,*LP_SET_BIND_SCENE_INFO;

//21.查询设备信号值
#define GUERY_DEV_RSSI			SET_BIND_SCENE_INFO+1	//查询设备信号值消息
typedef struct _tag_GUERY_DEV_RSSI : public _tag_BASE_SDK
{
	chString devID;
	chString data;
    chString uplink;
}_GUERY_DEV_RSSI,*LP_GUERY_DEV_RSSI;

//21_1.设备状态上报：欠压、拆除
#define DEV_ALARM_STATUS			GUERY_DEV_RSSI+1	//查询设备信号值消息
typedef struct _tag_DEV_ALARM_STATUS : public _tag_BASE_SDK
{
	chString devID;
	chString data;
}_DEV_ALARM_STATUS,*LP_DEV_ALARM_STATUS;

//22.异常
#define HANDLE_EXCEPTION		DEV_ALARM_STATUS+1		//异常消息
typedef struct _tag_HANDLE_EXCEPTION : public _tag_BASE_SDK
{
	chString cmd;
}_HANDLE_EXCEPTION,*LP_HANDLE_EXCEPTION;

//23.设置定时场景
#define SET_TIMED_SCENE			HANDLE_EXCEPTION+1		//设置定时场景消息
typedef struct _tag_TD_DATA
{
	chString sceneID;
	chString time;
	chString weekday;
}_TD_DATA,*LP_TD_DATA;
typedef struct _tag_SET_TIMED_SCENE : public _tag_BASE_SDK
{
	_tag_SET_TIMED_SCENE()
	{
		datacount = 0;
		pTDData = NULL;
	}
	chString mode;
	String groupID;
	String groupName;
	String status;
	int datacount;
	LP_TD_DATA pTDData;
}_SET_TIMED_SCENE,*LP_SET_TIMED_SCENE;

//24.获取定时场景
#define GET_TIMED_SCENE			SET_TIMED_SCENE+1		//获取定时场景消息
typedef struct _tag_TD_INFO
{
	chString groupID;
	chString groupName;
	chString status;
	chString sceneID;
	chString time;
	chString weekday;
}_TD_INFO,*LP_TD_INFO;
typedef struct _tag_GET_TIMED_SCENE : public _tag_BASE_SDK
{
	_tag_GET_TIMED_SCENE()
	{
		datacount = 0;
		pTDInfo = NULL;
	}
	int datacount;
	LP_TD_INFO pTDInfo;
}_GET_TIMED_SCENE,*LP_GET_TIMED_SCENE;

//25.定时场景执行
#define NOTIFY_TIMED_SCENE		GET_TIMED_SCENE+1		//定时场景执行消息，这个结构和获取定时场景消息的结构相同
typedef struct _tag_TD_EXEC
{
	String groupID;
	String groupName;
	String status;
	chString sceneID;
	String time;
	String weekday;
}_TD_EXEC,*LP_TD_EXEC;
typedef struct _tag_NOTIFY_TIMED_SCENE : public _tag_BASE_SDK
{
	_tag_NOTIFY_TIMED_SCENE()
	{
		datacount = 0;
		pTDExec = NULL;
	}
	int datacount;
	LP_TD_EXEC pTDExec;
}_NOTIFY_TIMED_SCENE,*LP_NOTIFY_TIMED_SCENE;

//26.命令发送错误
#define SEND_ERROR				NOTIFY_TIMED_SCENE+1	//发送到服务器的命令错误
typedef struct _tag_SEND_ERROR : public _tag_BASE_SDK
{
	chString cmd;
}_SEND_ERROR,*LP_SEND_ERROR;

//27.搜索407网关
#define SEARTCH_GATEWAY			SEND_ERROR+1			//搜索407网关消息
typedef struct _tag_SEARCH_GATEWAY : public _tag_BASE_SDK
{
	chString gwIP;
}_SEARCH_GATEWAY,*LP_SEARCH_GATEWAY;

//28.接受社交信息
#define GET_SOCIAL_MSG			SEARTCH_GATEWAY+1			//接受社交信息消息
typedef struct _tag_GET_SICIAL_MSG : public _tag_BASE_SDK
{
	String userType;
	String userID;
	chString from;
	chString alias;
	String to;
	chString data;
	chString time;
}_GET_SICIAL_MSG,*LP_GET_SICIAL_MSG;

//29.网络使用状况，注意，这个网络状态的回调没有判断appcliant是否停止，要成对的调用
#define NETWORK_USE_STATUS		GET_SOCIAL_MSG+1			//网络使用状况消息
typedef struct _tag_NETWORK_USE_STATUS
{
	int iDirection;			//0是收，1是发
	int iProc;				//0是开始，1是结束(iSize=0)
	int iSize;				//发送字节数
}_NETWORK_USE_STATUS,*LP_NETWORK_USE_STATUS;


//30.网关允许加网的状态
#define JION_GATEWAY_STATUS			NETWORK_USE_STATUS+1	//允许(禁止)网关加网
typedef struct _tag_JION_GATEWAY_STATUS : public _tag_BASE_SDK
{
	//chString devID;
	chString data;
}_JION_GATEWAY_STATUS,*LP_JION_GATEWAY_STATUS;

//31.网关信息
#define GATEWAY_MSG			JION_GATEWAY_STATUS+1
typedef struct _tag_GATEWAY_MSG : public _tag_BASE_SDK
{
	chString mode;
	chString gwVer;
	chString gwName;
	chString gwLocation;
	chString gwPath;
	chString gwChannel;
	chString gwRoomID;
    chString tutkUID;
    chString tutkPASSWD;
}_GATEWAY_MSG,*LP_GATEWAY_MSG;

//32.路由设置
#define ROUTER_MSG			GATEWAY_MSG+1
typedef struct _tag_ROUTER_MSG : public _tag_BASE_SDK
{
	chString jsondata;
}_ROUTER_MSG,*LP_ROUTER_MSG;

//33.梦想之花
#define DREAM_FLOWER		ROUTER_MSG+1
typedef struct _tag_DREAM_FLOWER : public _tag_BASE_SDK
{
	chString jsondata;
}_DREAM_FLOWER,*LP_DREAM_FLOWER;

//34.获取管家列表
#define GET_AUTO_PROGRAM		DREAM_FLOWER+1
typedef struct _tag_AUTO_PROGRAM
{
	chString programID;
	chString programName;
	chString programDesc;
	chString programType;
	chString status;
}_AUTO_PROGRAM,*LP_AUTO_PROGRAM;

typedef struct _tag_GET_AUTO_PROGRAM : public _tag_BASE_SDK
{
	_tag_GET_AUTO_PROGRAM()
	{
		rulecount = 0;
		pAutoProgram = NULL;
	}
	int rulecount;
	LP_AUTO_PROGRAM pAutoProgram;
}_GET_AUTO_PROGRAM,*LP_GET_AUTO_PROGRAM;

//35.设置管家信息
#define SET_AUTO_PROGRAM		GET_AUTO_PROGRAM+1
typedef struct _tag_AP_TRIGGER
{
	chString type;
	chString object;
	chString exp;
}_AP_TRIGGER,*LP_AP_TRIGGER;

typedef struct _tag_AP_CONDITION
{
	chString exp;
}_AP_CONDITION,*LP_AP_CONDITION;

typedef struct _tag_AP_ACTION
{
	chString sortNum;
	chString type;
	chString object;
	chString epData;
	chString description;
	chString delay;
}_AP_ACTION,*LP_AP_ACTION;

typedef struct _tag_SET_AUTO_PROGRAM : public _tag_BASE_SDK
{
	_tag_SET_AUTO_PROGRAM()
	{
		triggercount = 0;
		pAPTrigger = NULL;

		conditioncount = 0;
		pAPCondition = NULL;

		actioncount = 0;
		pAPAction = NULL;
	}
	chString operType;
	chString programID;
	chString programName;
	chString programDesc;
	chString programType;
	chString status;
	
	int triggercount;
	LP_AP_TRIGGER pAPTrigger;

	int conditioncount;
	LP_AP_CONDITION pAPCondition;	//条件是一个二叉树数组

	int actioncount;
	LP_AP_ACTION pAPAction;
}_SET_AUTO_PROGRAM,*LP_SET_AUTO_PROGRAM;


//36.管家升级信息
#define UPDATE_AUTO_PROGRAM		SET_AUTO_PROGRAM+1
typedef struct _tag_UPDATE_AUTO_PROGRAM : public _tag_BASE_SDK
{
	chString data;
}_UPDATE_AUTO_PROGRAM,*LP_UPDATE_AUTO_PROGRAM;

//37.网关时区同步
#define GATEWAY_TIMEZONE_SYNC		UPDATE_AUTO_PROGRAM+1  
typedef struct _tag_GATEWAY_TIMEZONE_SYNC : public _tag_BASE_SDK
{
	chString zoneID;
	chString time;
}_GATEWAY_TIMEZONE_SYNC,*LP_GATEWAY_TIMEZONE_SYNC;


//37.规则生效状态分组设置
#define RULE_GROUP_ENABLE_AUTO_PROGRAM		GATEWAY_TIMEZONE_SYNC+1  
typedef struct _tag_RULE_GROUP_ENABLE_AUTO_PROGRAM : public _tag_BASE_SDK
{
	chString jsondata;
}_RULE_GROUP_ENABLE_AUTO_PROGRAM,*LP_RULE_GROUP_ENABLE_AUTO_PROGRAM;

//38.梦想之花文件管理
#define DREAM_FLOWER_FILE		RULE_GROUP_ENABLE_AUTO_PROGRAM+1
typedef struct _tag_DREAM_FLOWER_FILE : public _tag_BASE_SDK
{
	chString jsondata;
}_DREAM_FLOWER_FILE,*LP_DREAM_FLOWER_FILE;


//39.获取OP门锁用户管理接口
#define OP_LOCK_USER_MANAGER		DREAM_FLOWER_FILE+1

typedef struct _tag_OP_LOCK_DATA
{
	chString token;
	chString userID;
	chString userType;
	chString password;
	chString peroid;
	chString unlocktype;
	chString menace;
}_OP_LOCK_DATA,*LP_OP_LOCK_DATA;



typedef struct _tag_OP_LOCK_USER_MANAGER : public _tag_BASE_SDK
{
	chString devID;
	chString operType;
	chString data;
}_OP_LOCK_USER_MANAGER,*LP_OP_LOCK_USER_MANAGER;

//39.
#define DEVICE_HISTORY_DATA		OP_LOCK_USER_MANAGER+1

typedef struct _tag_DEVICE_HISTORY_DATA
{
    chString data;
    chString gwid;
}_DEVICE_HISTORY_DATA,*LP_DEVICE_HISTORY_DATA;

//406
#define DEVICE_GENERAL_CONFIGURE_DATA		DEVICE_HISTORY_DATA+1
typedef struct _tag_DEVICE_GENERAL_CONFIGURE_DATA : public _tag_BASE_SDK
{
    chString devID;
	chString mode;
    chString time;
    chString key;
    chString value;
}_DEVICE_GENERAL_CONFIGURE_DATA,*LP_DEVICE_GENERAL_CONFIGURE_DATA;


// 330Mini网关中继设置返回数据：
#define MINI_GATEWAY_REPEATER		DEVICE_GENERAL_CONFIGURE_DATA+1
typedef struct _tag_MINI_GATEWAY_REPEATER : public _tag_BASE_SDK
{
    chString jsondata;
}_MINI_GATEWAY_REPEATER,*LP_MINI_GATEWAY_REPEATER;


// 407查找设置wifi复合设备信息：
#define WIFI_DEVICE_MSG		MINI_GATEWAY_REPEATER+1
typedef struct _tag_WIFI_DEVICE_MSG : public _tag_BASE_SDK
{
    chString devID;
    chString mode;
    chString wdevID;
    chString wifiS;
    chString wifiN;
}_WIFI_DEVICE_MSG,*LP_WIFI_DEVICE_MSG;


// 53设置绑定场景信息
#define GET_BIND_DEVICE_INFO		WIFI_DEVICE_MSG+1	//获取绑定设备信息消息
typedef struct _tag_BIND_DEVICE_INFO
{
    chString ep;
    chString devID;
    chString devEP;
}_BIND_DEVICE_INFO,*LP_BIND_DEVICE_INFO;


typedef struct _tag_GET_BIND_DEVICE_INFO : public _tag_BASE_SDK
{
    _tag_GET_BIND_DEVICE_INFO()
    {
        datacount = 0;
        pBindDeviceInfo = NULL;
    }
    chString devID;
    int datacount;
    LP_BIND_DEVICE_INFO pBindDeviceInfo;
}_GET_BIND_DEVICE_INFO,*LP_GET_BIND_DEVICE_INFO;

// 54设置绑定场景信息
#define SET_BIND_DEVICE_INFO		GET_BIND_DEVICE_INFO+1	//获取绑定设备信息消息
typedef struct _tag_SET_DEVICE_SCENE_INFO : public _tag_BASE_SDK
{
    _tag_SET_DEVICE_SCENE_INFO()
    {
        datacount = 0;
        pBindDeviceInfo = NULL;
    }
    chString devID;
    int datacount;
    LP_BIND_DEVICE_INFO pBindDeviceInfo;
}_SET_BIND_DEVICE_INFO,*LP_SET_BIND_DEVICE_INFO;

// 201绑定解绑子网关：
#define SubGW_Bind_ManagerGW		SET_BIND_DEVICE_INFO+1 //201
typedef struct _tag_SubGW_Bind_ManagerGW : public _tag_BASE_SDK
{
    chString subGWID;
    chString subGWPwd;
    chString type;
    chString result;
}_SubGW_Bind_ManagerGW,*LP_SubGW_Bind_ManagerGW;


//203.获取修改子网关信息
#define SUBGATEWAY_MSG			SubGW_Bind_ManagerGW+1
typedef struct _tag_SUB_GATEWAY_MSG : public _tag_BASE_SDK
{
    chString subGWID;
    chString mode;
    chString gwVer;
    chString gwName;
    chString gwRoomID;
}_SUB_GATEWAY_MSG,*LP_SUB_GATEWAY_MSG;

//39.
#define QuerySubGatewayData		SUBGATEWAY_MSG+1

typedef struct _tag_QuerySubGatewayData : public _tag_BASE_SDK
{
    chString data;
}_QuerySubGatewayData,*LP_QuerySubGatewayData;


//函数mode参数解释
//1.sendSetBindSceneMsg，必需参数gwID、mode、devID、type
//mode == 1表示设置绑定，需要提供data和datacount参数，data为_BIND_SCENE_INFO结构数组，datacount表示数组长度
//mode == 3表示删除绑定，data和datacount参数忽略，可以传入0

//2.sendSetDevIRMsg，必需参数gwID、mode、devID、ep
//mode == 1表示设置红外转发器的按键，需要提供data和datacount参数，data为_DEVICE_IR_INFO结构数组，datacount表示数组长度

//3.sendSetDevMsg，必需参数gwID、mode、devID
//mode == 0表示设置安防类设备布防撤防状态，需要提供ep和epStatus参数，epStatus为1表示布防、为1表示撤防，其他参数忽略，可以传入0
//mode == 2表示设置设备名称、类型、房间、子设备名称，需要提供ep参数，name、category、roomID、epName可选择一个或多个，其他参数忽略，可以传入0
//mode == 3表示删除设备，其他参数忽略，可以传入0

//4.sendSetRoomMsg，必需参数gwID、mode
//mode == 1表示添加新房间，需要提供name和icon参数，其他参数忽略，可以传入0
//mode == 2表示修改房间，需要提供roomID、name、icon参数，其他参数忽略，可以传入0
//mode == 3表示删除房间，需要提供roomID参数，其他参数忽略，可以传入0

//5.sendSetSceneMsg，必需参数gwID、mode
//mode == 0表示激活场景，需要提供sceneID，其他参数忽略，可以传入0
//mode == 1表示添加新场景，需要提供name和icon参数，其他参数忽略，可以传入0
//mode == 2表示修改场景，需要提供sceneID、name、icon参数，其他参数忽略，可以传入0
//mode == 3表示删除场景，需要提供sceneID参数，其他参数忽略，可以传入0

//6.sendSetTaskMsg，必需参数gwID、sceneID、devID、type、ep、epType
//data为_TASK_DATA结构数组，datacount表示数组长度
//若data和datacount为0表示删除这个设备的对应的任务
//若data和datacount不为0，那么：
//data数组结构中的mode == 1时表示添加新任务
//data数组结构中的mode == 2时表示修改任务
//data数组结构中mode、taskMode、contentID、epData、available为必需字段
//若taskMode == 1表示即时任务，sensorID、sensorEp、sensorType、sensorName、sensorCond、sensorData、delay、forward为必需字段
//若taskMode == 2表示定时件任务，time、weekday为必需字段

//7.sendSetTimedScene，必需参数gwID、mode
//mode == 0表示切换定时场景状态，需要提供groupID和status，其他参数忽略，可以传入0
//mode == 1表示设置定时场景，需要提供groupID、groupName、data、datacount，其他参数忽略，可以传入0
//mode == 3表示删除定时场景，需要提供groupID，其他参数忽略，可以传入0
