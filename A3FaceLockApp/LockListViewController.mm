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

#import "YCXMenu.h"      // 右上角按钮

#import "model.h"
@interface LockListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)NSArray *localImageArr;   //本地图片数组
@property(nonatomic,copy)SZKRoundScrollView *roundScrollView;

@property(nonatomic)BOOL isNeedPassWord;     //是否需要开门密码

@property(nonatomic,strong)NSString *passWordAlertTitle;
@property(nonatomic,strong)UITextField *openPassWord;   //开门密码

@property(nonatomic,strong)UIButton *setUpButton;  //单锁页面右上角设置按钮
@property(nonatomic,strong)UILabel *noDeviceLabel;  //无设备label
@property (nonatomic , strong) NSMutableArray *items;   //单锁测试按钮的列表item

@property (nonatomic,strong) NSMutableArray *closePWDArr;

@end

@implementation LockListViewController
@synthesize items = _items;

//本地图片
-(NSArray *)localImageArr{
    
    _localImageArr=@[@"scroll_1",@"scroll_2",@"scroll_3"];
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
    
    //导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    _isNeedPassWord = YES;
    _passWordAlertTitle = @"关闭密码";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jisshouopen:) name:@"openPsaaword" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jisshoushutDown:) name:@"shutDownPsaaword" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    self.title = @"门锁";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReViewDevice:) name:REVIEW_DEVICE object:nil];
    [self createRightSetUpButton];
    [self creatTableView];
    [self createScrollView];

}

-(void)createRightSetUpButton{

    _setUpButton = [MyUtiles createBtnWithFrame:CGRectMake(0, 0, 100, 50) title:@"设置" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(monitorClick:)];
    [_setUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_setUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    _setUpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:_setUpButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)monitorClick:(UIButton *)sender{
    
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {

        _items = [@[
                    [YCXMenuItem menuItem:_passWordAlertTitle
                                    image:nil
                                      tag:100
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"重命名"
                                    image:nil
                                      tag:101
                                 userInfo:@{@"title":@"Menu"}],
                    [YCXMenuItem menuItem:@"删除"
                                    image:nil
                                      tag:102
                                 userInfo:@{@"title":@"Menu"}],
                        ] mutableCopy];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 0, 50, 0) menuItems:_items selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"index is %ld",(long)index);
            if (index == 0) {
               // NSLog(@"关闭密码");
                if (_isNeedPassWord == YES) {
                    NSLog(@"打开密码");
                    _isNeedPassWord = NO;
                    _passWordAlertTitle = @"打开密码";
                    [_tableView reloadData];
                    _isNeedPassWord = NO;
                }else if (_isNeedPassWord == NO){
                    NSLog(@"关闭密码");
                    _isNeedPassWord = YES;
                    _passWordAlertTitle = @"关闭密码";
                    [_tableView reloadData];
                    _isNeedPassWord = YES;
                }
            }else if (index == 1){
                NSLog(@"单锁重命名");
                [self reName:0];
            }else if (index == 2){
                NSLog(@"单锁删除");
                [self deleteDevice:0];
            }
        }];
    }
}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);
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
    
    _closePWDArr = [[NSMutableArray alloc]init];
    for (int index = 0; index < 2 ; index ++) {
        model *m = [[model alloc]init];
        m.isNeedPWD = YES;
        [_closePWDArr addObject:m];
    }
    
    _tableView  = [MyUtiles createTableView:CGRectMake(0, SCREEN_HEIGHT/3, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_HEIGHT/3-49-64) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor whiteColor] separatorColor:[UIColor lightGrayColor] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    [_tableView registerNib:[UINib nibWithNibName:@"LockListTableViewCell" bundle:nil] forCellReuseIdentifier:@"LockListTableViewCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [self.view addSubview:_tableView];
    
    _noDeviceLabel = [MyUtiles createLabelWithFrame:CGRectMake(SCREEN_WIDTH/3, 100, SCREEN_WIDTH/3, 40) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter color:[UIColor lightGrayColor] text:@"暂无设备"];
    _noDeviceLabel.backgroundColor = [UIColor orangeColor];
    [_tableView addSubview:_noDeviceLabel];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (m_map_id_str_device[m_pGateway->m_strID].size() == 0) {
        _noDeviceLabel.hidden = NO;
        _setUpButton.hidden = YES;
        
    }else if (m_map_id_str_device[m_pGateway->m_strID].size() == 1) {
        _setUpButton.hidden = NO;
        _noDeviceLabel.hidden = YES;
        _cell.nameLabel.hidden = YES;
        _cell.danSuoLabel.hidden = NO;
        _tableView.scrollEnabled = NO;
        return SCREEN_HEIGHT-SCREEN_HEIGHT/3-49-64;
    }else
        _setUpButton.hidden = YES;
        _noDeviceLabel.hidden = YES;
        _cell.nameLabel.hidden = NO;
        _cell.danSuoLabel.hidden = YES;
        _tableView.scrollEnabled = YES;
        return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (m_map_id_str_device[m_pGateway->m_strID].size() == 0) {
        _setUpButton.hidden = YES;
    }
    return m_map_id_str_device[m_pGateway->m_strID].size();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _cell = [tableView dequeueReusableCellWithIdentifier:@"LockListTableViewCell" forIndexPath:indexPath];
    ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
    advance(iter, indexPath.row);
    NSString *emptyNameStr = @"未命名";
    _cell.nameLabel.text = iter->second->m_strName == ""?emptyNameStr:[NSString stringWithUTF8String:iter->second->m_strName.c_str()];
    _cell.danSuoLabel.text = iter->second->m_strName == ""?emptyNameStr:[NSString stringWithUTF8String:iter->second->m_strName.c_str()];
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
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        NSString *message = [NSString stringWithFormat:@"%@远程开锁成功",_cell.nameLabel.text];
        // [ADAudioTool playSystemAudioWithSoundID:1007];   /播放系统提示音
        [self playNotifySound:message];
        [MBManager hideAlert];
        [MBManager showBriefMessage:message InView:_roundScrollView];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"app2@2x"];
    }else if ([devStatus isEqual:@"2"] || [devStatus isEqual:@"00"]){
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        //[self playNotifySound:@"门锁已关闭"];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        [MBManager hideAlert];
        _cell.statueImage.image = [UIImage imageNamed:@"关门2@2x"];
    }else if ([devStatus isEqual:@"145"]){
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        _cell.statueLabel.text = @"密码失败";
        _cell.statueImage.image = [UIImage imageNamed:@"密码错误2@2x"];
        _cell.statueLabel.backgroundColor = [UIColor redColor];
        _cell.statueLabel.tintColor = [UIColor whiteColor];
        [MBManager hideAlert];
    }else if ([arr containsObject:devStatus]){
        NSString *message = [NSString stringWithFormat:@"%@人脸扫描开锁成功",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        //[ADAudioTool playSystemAudioWithSoundID:1007];   /播放系统提示音
        [self playNotifySound:message];
        [MBManager hideAlert];
        [MBManager showBriefMessage:message InView:_roundScrollView];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"人脸2@2x"];
    }else if ([devStatus isEqual:@"30"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@密码验证开锁成功",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        //[ADAudioTool playSystemAudioWithSoundID:1007]; /播放系统提示音
        [self playNotifySound:message];
        [MBManager showBriefMessage:message InView:_roundScrollView];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"密码2@2x"];
    }else if ([devStatus isEqual:@"138"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@钥匙开锁成功",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        [self playNotifySound:message];
        [MBManager showBriefMessage:message InView:_roundScrollView];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"钥匙2@2x"];
    }else if ([devStatus isEqual:@"28"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@电量低",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"电量低2@2x"];
    }else if ([devStatus isEqual:@"10"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@上保险",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"上保险2@2x"];
    }else if ([devStatus isEqual:@"11"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@解除保险",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"解除保险2@2x"];
    }else if ([devStatus isEqual:@"20"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@反锁",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"反锁2@2x"];
    }else if ([devStatus isEqual:@"23"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@入侵警报",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"入侵警报2@2x"];
    }else if ([devStatus isEqual:@"24"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@报警解除",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"报警解除2@2x"];
    }else if ([devStatus isEqual:@"25"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@强制上锁",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"强制上锁2@2x"];
    }else if ([devStatus isEqual:@"29"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@破坏报警",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"破坏报警2@2x"];
    }else if ([devStatus isEqual:@"31"]){
        [MBManager hideAlert];
        NSString *message = [NSString stringWithFormat:@"%@密码连续输入错误",_cell.nameLabel.text];
        _cell.statueLabel.hidden = YES;
        _cell.statueImage.hidden = NO;
        [MBManager showBriefMessage:message InView:_roundScrollView];
        //[ADAudioTool playSystemAudioWithSoundID:1007];   //播放系统提示音
        // [self playNotifySound:message];
        _cell.statueLabel.backgroundColor = [UIColor clearColor];
        _cell.statueImage.image = [UIImage imageNamed:@"密码连续错误2@2x"];
    }else if ([devStatus isEqual:@"144"]){
        CString epData = it->second.m_strEPData.c_str();
        epData = epData == "11"?"12":"11";
        sendControlDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), iter->second->m_strID.c_str(), it->first.c_str(), it->second.m_strEPType.c_str(), epData.c_str());
        NSLog(@"发送密码开门指令成功");
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
    model *m = self.closePWDArr[indexPath.row];
    if (m.isNeedPWD == YES) {    //需要开门密码
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"开门" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [MBManager showLoadingInView:_roundScrollView];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];    //移除观察者
            _openPassWord = alertController.textFields.firstObject;
            NSLog(@"openPassWord is %@",_openPassWord.text);
            
            ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
            advance(iter, indexPath.row);
            std::map<CString, CEPData>::iterator it = iter->second->m_map_ep_data.begin();
//            if(iter->second->Alarmable()){
//                while (it != iter->second->m_map_ep_data.end()){
//                    CString epStatus = it->second.m_strEPStatus.c_str();
//                    epStatus = epStatus == "1"?"0":"1";
//                    sendSetDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), 0, iter->second->m_strID.c_str(), iter->second->m_strType.c_str(), it->first.c_str(), it->second.m_strEPType.c_str(), 0, 0, 0, 0, epStatus.c_str());
//                    it++;
//                }
//            }
            
            /*
             开锁实现需进行两步：1.验证密码 2.发送开锁指令
             */
            //发送开锁密码
            //while (it != iter->second->m_map_ep_data.end()){
            CString epData1 = it->second.m_strEPData.c_str();
            NSString *passwordStr = [NSString stringWithFormat:@"9%lu%@",_openPassWord.text.length,_openPassWord.text];
            epData1 = [passwordStr UTF8String];;   //96111111
            int result = sendControlDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), iter->second->m_strID.c_str(), it->first.c_str(), it->second.m_strEPType.c_str(), epData1.c_str());

            NSLog(@"验证密码结果result is %d",result);            
            
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
        
    }else if (m.isNeedPWD == NO){     //不需要开门密码

        [MBManager showLoadingInView:_roundScrollView];
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
    return;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (m_map_id_str_device[m_pGateway->m_strID].size() == 1) {    //一个cell，不允许侧滑编辑
     return NO;
    }else
     return YES;
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectIndex = indexPath.row;
    //删除设备
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
        [MBManager showBriefMessage:@"当前版不提供此方法" InView:self.view];
        return ;
        [self deleteDevice:_selectIndex];             //  删除
    }];
    //设备重命名
    UITableViewRowAction *rowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"重命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self reName:_selectIndex];                   //  重命名
    }];
    //关闭开门密码
    model *m = self.closePWDArr[indexPath.row];
    UITableViewRowAction *rowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:m.isNeedPWD ? @"关闭密码":@"打开密码" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       // [self openOrShutDownPassWord:_selectIndex];   //打开／关闭密码
        if (m.isNeedPWD == YES ) {
            NSLog(@"打开密码");
            _isNeedPassWord = NO;
            m.isNeedPWD = NO;
            _passWordAlertTitle = @"打开密码";
            [_tableView reloadData];
        }else if (m.isNeedPWD == NO ){
            NSLog(@"关闭密码");
            _isNeedPassWord = YES;
            m.isNeedPWD = YES;
            _passWordAlertTitle = @"关闭密码";
            [_tableView reloadData];
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

-(void)reName:(NSInteger)index{
    
    ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
    advance(iter, index);
    DeviceSettingViewController *deviceSetVc = [[DeviceSettingViewController alloc]init];
    deviceSetVc.m_pDevice = iter->second;
    deviceSetVc.m_pGateway = m_pGateway;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:deviceSetVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
-(void)deleteDevice:(NSInteger)index{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除设备后,您将不能操控此设备" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        ITER_MAP_STR_DEVICE iter = m_map_id_str_device[m_pGateway->m_strID].begin();
        advance(iter, index);
        NSLog(@"确认删除");
        sendSetDevMsg(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(), 3, iter->second->m_strID.c_str(), 0, 0, 0, 0, 0, 0, 0, 0);
        
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)openOrShutDownPassWord:(NSInteger)index{

    if (_isNeedPassWord == YES) {
        NSLog(@"打开密码");
        _isNeedPassWord = NO;
        _passWordAlertTitle = @"打开密码";
        [_tableView reloadData];
    }else if (_isNeedPassWord == NO){
        NSLog(@"关闭密码");
        _isNeedPassWord = YES;
        _passWordAlertTitle = @"关闭密码";
        [_tableView reloadData];
    }
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
