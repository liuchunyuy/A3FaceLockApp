//
//  LockListViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/21.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "LockListViewController.h"
#import "SZKRoundScrollView.h"        //    轮播图
#import "ProductionViewController.h"
#import "LockListTableViewCell.h"

#import "SDSoundPlayer.h"

#import <AudioToolbox/AudioToolbox.h>

#import "DeviceSettingViewController.h"
@interface LockListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)NSArray *localImageArr;   //本地图片数组
@property(nonatomic,copy)SZKRoundScrollView *roundScrollView;

@property(nonatomic)BOOL isNeedPassWord;

@property(nonatomic,strong)NSString *passWordAlertTitle;
@property(nonatomic,strong)UITextField *openPassWord;

@property(nonatomic,strong)UITextField *nNameTextField;

@end

@implementation LockListViewController


//本地图片
-(NSArray *)localImageArr{
    
    _localImageArr=@[@"mv_00",@"mv_01",@"mv_02"];
    //轮播图图片数组
    return _localImageArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _isNeedPassWord = YES;
    _passWordAlertTitle = @"关闭密码";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jisshouopen:) name:@"openPsaaword" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jisshoushutDown:) name:@"shutDownPsaaword" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    self.title = @"设备";
   // self.tableView.frame = CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT/3);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReViewDevice:) name:REVIEW_DEVICE object:nil];
    
    [self creatTableView];
    
    [self createScrollView];

}

-(void)jisshouopen:(NSNotification *)notification{
    
    NSDictionary *nameDictionary = [notification userInfo];
    _passWordAlertTitle = [nameDictionary objectForKey:@"name"];
    return;
}
-(void)jisshoushutDown:(NSNotification *)notification{
    
    NSDictionary *nameDictionary = [notification userInfo];
    _passWordAlertTitle = [nameDictionary objectForKey:@"name"];
    return;
}


-(void)createScrollView{
    
    //展示图
    _roundScrollView=[SZKRoundScrollView roundScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3) imageArr:self.localImageArr timerWithTimeInterval:2 imageClick:^(NSInteger imageIndex) {
        NSLog(@"imageIndex:第%ld个",(long)imageIndex);
        self.hidesBottomBarWhenPushed = YES;
        ProductionViewController *productionVc = [[ProductionViewController alloc]init];
        [self.navigationController pushViewController:productionVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }];
    [self.view addSubview:_roundScrollView];
    //小圆点控制器位置
    _roundScrollView.pageControlAlignment=NSPageControlAlignmentCenter;
    //当前小圆点颜色
    _roundScrollView.curPageControlColor=[UIColor yellowColor];
    //其余小圆点颜色
    _roundScrollView.otherPageControlColor=[UIColor orangeColor];
    
}

-(void)creatTableView{
        
    _tableView  = [MyUtiles createTableView:CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_HEIGHT/3-49-64) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor clearColor] separatorColor:[UIColor lightGrayColor] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    [_tableView registerNib:[UINib nibWithNibName:@"LockListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LockListTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //UIImageView *backImageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    UIImageView*imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noDevice"]];
    
    _tableView.backgroundView = imageView;
    
    //_tableView.backgroundView=backImageView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [self.view addSubview:_tableView];
    
}

-(void)createNavRightBtn{
    
    UIBarButtonItem *rightSharBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(setUp)];
    //NSArray *buttonItem = @[rightSharBt,rightMaxBt];
    self.navigationItem.rightBarButtonItem = rightSharBt;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (m_map_id_str_device[m_pGateway->m_strID].size() == 1) {
        return SCREEN_HEIGHT-SCREEN_HEIGHT/3-49-64;
    }else
        return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return m_map_id_str_device[m_pGateway->m_strID].size();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        _cell = [tableView dequeueReusableCellWithIdentifier:@"LockListTableViewCell" forIndexPath:indexPath];
//        // 设置圆角
//        _cell.statueLabel.layer.cornerRadius = _cell.statueLabel.bounds.size.width/2;
//        _cell.statueLabel.layer.masksToBounds=YES;
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
        advance(iter, indexPath.row);
        NSString *emptyNameStr = @"未命名";
        _cell.nameLabel.text = iter->second->m_strName == ""?emptyNameStr:[NSString stringWithUTF8String:iter->second->m_strName.c_str()];
        NSMutableString *devStatus = [NSMutableString stringWithString:@""];
        NSLog(@"self.deviceName.text is %@",_cell.nameLabel.text);
        std::map<CString, CEPData>::iterator it = iter->second->m_map_ep_data.begin();
        NSString *epStatus;
        if(iter->second->Alarmable()){
            epStatus = [NSString stringWithUTF8String:it->second.m_strEPStatus.c_str()];
        }else{
            epStatus = [NSString stringWithUTF8String:it->second.m_strEPData.c_str()];
        }
        [devStatus appendString:[NSString stringWithFormat:@"%@,",epStatus]];
        
        [devStatus deleteCharactersInRange:NSMakeRange(devStatus.length-1,1)];
    
    NSLog(@"锁返回状态 devStatus is %@",devStatus);
    NSArray *arr = @[@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84"];
        if ([devStatus isEqual: @"1"]) {
            NSString *message = [NSString stringWithFormat:@"%@远程开锁成功",_cell.nameLabel.text];
           // [ADAudioTool playSystemAudioWithSoundID:1007];   /播放系统提示音
            [self playNotifySound:message];
            [MBManager showBriefMessage:message InView:_roundScrollView];
            _cell.statueLabel.text = @"打开";
            _cell.statueLabel.textColor = [UIColor whiteColor];
            _cell.statueLabel.font = [UIFont systemFontOfSize:14];
            _cell.statueLabel.backgroundColor = [UIColor greenColor];
        }else if ([devStatus isEqual:@"2"]){
            //[self playNotifySound:@"门锁已关闭"];
            _cell.statueLabel.text = @"关闭";
            _cell.statueLabel.textColor = [UIColor whiteColor];
            _cell.statueLabel.font = [UIFont systemFontOfSize:14];
            _cell.statueLabel.backgroundColor = [UIColor redColor];
        }else if ([devStatus isEqual:@"145"]){
            _cell.statueLabel.text = @"密码验证失败";
            _cell.statueLabel.textColor = [UIColor whiteColor];
            _cell.statueLabel.font = [UIFont systemFontOfSize:10];
            _cell.statueLabel.backgroundColor = [UIColor grayColor];
        }else if ([arr containsObject:devStatus]){
            NSString *message = [NSString stringWithFormat:@"%@人脸扫描开锁成功",_cell.nameLabel.text];
            //[ADAudioTool playSystemAudioWithSoundID:1007];   /播放系统提示音
            [self playNotifySound:message];
            [MBManager showBriefMessage:message InView:_roundScrollView];
            _cell.statueLabel.text = @"人脸开门";
           // [self playNotifySound];
            _cell.statueLabel.textColor = [UIColor whiteColor];
            _cell.statueLabel.font = [UIFont systemFontOfSize:12];
            _cell.statueLabel.backgroundColor = [UIColor greenColor];
        }else if ([devStatus isEqual:@"30"]){
            NSString *message = [NSString stringWithFormat:@"%@密码验证开锁成功",_cell.nameLabel.text];
            //[ADAudioTool playSystemAudioWithSoundID:1007]; /播放系统提示音
            [self playNotifySound:message];
            [MBManager showBriefMessage:message InView:_roundScrollView];
            _cell.statueLabel.text = @"密码开门";
            _cell.statueLabel.textColor = [UIColor whiteColor];
            _cell.statueLabel.font = [UIFont systemFontOfSize:10];
            _cell.statueLabel.backgroundColor = [UIColor greenColor];
        }else if ([devStatus isEqual:@"138"]){
            NSString *message = [NSString stringWithFormat:@"%@钥匙开锁成功",_cell.nameLabel.text];
            //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
            [self playNotifySound:message];
            [MBManager showBriefMessage:message InView:_roundScrollView];
            _cell.statueLabel.text = @"钥匙开门";
            _cell.statueLabel.textColor = [UIColor whiteColor];
            _cell.statueLabel.font = [UIFont systemFontOfSize:10];
            _cell.statueLabel.backgroundColor = [UIColor greenColor];
        }
        return _cell;
}

//播放门锁状态
- (void)playNotifySound:(NSString *)message {
    SDSoundPlayer *player = [SDSoundPlayer SDSoundPlayerInit];    
    [player setDefaultWithVolume:-1.0 rate:0.5 pitchMultiplier:-1.0];
    [player play:message];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isNeedPassWord == YES) {    //需要开门密码
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"开门" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];    //移除观察者
            _openPassWord = alertController.textFields.firstObject;
            NSLog(@"openPassWord is %@",_openPassWord.text);
            
           // [MBProgressHUD showHUDAddedTo:_tableView animated:YES];
            
            ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
            advance(iter, indexPath.row);
            std::map<CString, CEPData>::iterator it = iter->second->m_map_ep_data.begin();
            if(iter->second->Alarmable()){
                while (it != iter->second->m_map_ep_data.end()){
                    CString epStatus = it->second.m_strEPStatus.c_str();
                    epStatus = epStatus == "1"?"0":"1";
                    sendSetDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), 0, iter->second->m_strID.c_str(), iter->second->m_strType.c_str(), it->first.c_str(), it->second.m_strEPType.c_str(), 0, 0, 0, 0, epStatus.c_str());
                    it++;
                }
            }
            /*
             开锁实现需进行两步：1.验证密码 2.发送开锁指令
             */
            //发送开锁密码
            //while (it != iter->second->m_map_ep_data.end()){
            CString epData1 = it->second.m_strEPData.c_str();
            epData1 = [_openPassWord.text UTF8String];;   //96111111
            int result = sendControlDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), iter->second->m_strID.c_str(), it->first.c_str(), it->second.m_strEPType.c_str(), epData1.c_str());
            NSLog(@"密码验证");
            NSLog(@"验证密码结果result is %d",result);
            //      it++;
            //}
            //发送开锁指令11为开锁，12为锁定
            CString epData = it->second.m_strEPData.c_str();
            epData = epData == "11"?"12":"11";
            sendControlDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), iter->second->m_strID.c_str(), it->first.c_str(), it->second.m_strEPType.c_str(), epData.c_str());
            NSLog(@"发送开门指令成功");
            
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancleAction];
        [alertController addAction:okAction];
        //密码添加输入框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"开门密码";
            textField.clearButtonMode = UITextFieldViewModeAlways;
            //监听输入框
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        alertController.actions.lastObject.enabled = NO;//冻结确定按钮
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (_isNeedPassWord == NO){     //不需要开门密码

        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
        advance(iter, indexPath.row);
        std::map<CString, CEPData>::iterator it = iter->second->m_map_ep_data.begin();
        
        if(iter->second->Alarmable()){
            while (it != iter->second->m_map_ep_data.end()){
                CString epStatus = it->second.m_strEPStatus.c_str();
                epStatus = epStatus == "1"?"0":"1";
                sendSetDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), 0, iter->second->m_strID.c_str(), iter->second->m_strType.c_str(), it->first.c_str(), it->second.m_strEPType.c_str(), 0, 0, 0, 0, epStatus.c_str());
                it++;
            }
        }
        while (it != iter->second->m_map_ep_data.end()){
            //发送开锁指令11为开锁，12为锁定
            CString epData = it->second.m_strEPData.c_str();
            epData = epData == "11"?"12":"11";
            sendControlDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), iter->second->m_strID.c_str(), it->first.c_str(), it->second.m_strEPType.c_str(), epData.c_str());
            it++;
        }
    }
    //int sendControlDevMsg(CPCHAR appID, CPCHAR gwID, CPCHAR devID, CPCHAR ep, CPCHAR epType, CPCHAR epData);
    //int sendGetDeviceAlarmData(CPCHAR appID, CPCHAR gwID,CPCHAR devID, CPCHAR time, CPCHAR pageSize);
    return;
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndex = indexPath.row;
    //删除设备
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除设备后,您将不能操控此设备" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
            advance(iter, _selectIndex);
            NSLog(@"确认删除");
            sendSetDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), 3, iter->second->m_strID.c_str(), 0, 0, 0, 0, 0, 0, 0, 0);
            
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancleAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    //设备重命名
    UITableViewRowAction *rowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"重命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
        advance(iter, _selectIndex);
        DeviceSettingViewController *deviceSetVc = [[DeviceSettingViewController alloc]init];
        deviceSetVc.m_pDevice = iter->second;
        deviceSetVc.m_pGateway = m_pGateway;
       // [self presentModalViewController:deviceSetVc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:deviceSetVc animated:YES];
        self.hidesBottomBarWhenPushed = NO;
        
        return ;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"重命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];    //移除观察者
            _nNameTextField = alertController.textFields.firstObject;
            NSLog(@"newName is %@",_nNameTextField.text);
            
            //std::map<CString, CEPData>::iterator iter = _m_pDevice->m_map_ep_data.begin();
            //advance(iter, _selectIndex);
            
            ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
            advance(iter, indexPath.row);
            std::map<CString, CEPData>::iterator it = iter->second->m_map_ep_data.begin();
            sendSetDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), 2, _m_pDevice->m_strID.c_str(), _m_pDevice->m_strType.c_str(), iter->first.c_str(), it->second.m_strEPType.c_str(), [_nNameTextField.text UTF8String], nil, 0, 0, 0);
            
        }];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancleAction];
        [alertController addAction:okAction];
        //添加输入框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"输入名字";
            textField.clearButtonMode = UITextFieldViewModeAlways;
            //监听输入框
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldNameDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
        }];
        alertController.actions.lastObject.enabled = NO;//冻结确定按钮
        [self presentViewController:alertController animated:YES completion:nil];
        NSLog(@"重命名");
    }];
    
    //关闭开门密码
    UITableViewRowAction *rowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:_passWordAlertTitle handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        if (_isNeedPassWord == YES) {
            NSLog(@"打开密码");
            _isNeedPassWord = NO;
            _passWordAlertTitle = @"打开密码";
            [tableView reloadData];
        }else if (_isNeedPassWord == NO){
            NSLog(@"关闭密码");
            _isNeedPassWord = YES;
            _passWordAlertTitle = @"关闭密码";
            [tableView reloadData];
        }
    }];
    rowAction1.backgroundColor = [UIColor orangeColor];
    rowAction2.backgroundColor = [UIColor grayColor];
    NSArray *arr = @[rowAction,rowAction1,rowAction2];
    return arr;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"openPsaaword" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shutDownPsaaword" object:nil];
    
}

- (void)alertTextFieldNameDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *pass = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = pass.text.length >= 1;   //输入框长度大于等于6，解冻确定按钮
    }
}


- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *pass = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = pass.text.length >= 4;   //输入框长度大于等于6，解冻确定按钮
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
    advance(iter, _selectIndex);
    if(buttonIndex == 1){
        sendSetDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), 3, iter->second->m_strID.c_str(), 0, 0, 0, 0, 0, 0, 0, 0);
    }
}


-(void)setUp{
    
    NSLog(@"设置门锁：重命名、删除、关闭开门密码");
}

- (void)ReViewDevice:(NSNotification *)notification{
    
    if (NO == [NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(ReViewDevice:) withObject:notification waitUntilDone:NO];
        return;
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setM_pGateway:(CGateway *)pGateway{
    
    m_pGateway = pGateway;
}

- (CGateway*)m_pGateway{
    
    return m_pGateway;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
