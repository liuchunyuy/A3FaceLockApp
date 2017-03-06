//
//  DeviceListViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/1/18.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "DeviceListViewController.h"
#import "DeviceListTableViewCell.h"
//#import "LocksListViewController.h"
#import "ModifyGateWayPWViewController.h"
#import "SwitchGateWayViewController.h"

@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

//@property(nonatomic,copy)NSString *gateWayIDStr;
@end

@implementation DeviceListViewController

- (void)setM_pGateway:(CGateway *)pGateway{
    m_pGateway = pGateway;
}

- (CGateway*)m_pGateway{
    return m_pGateway;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"_gateWayIDStr is %@", _gateWayIDStr);
    NSLog(@"_gateWayPWStr is%@", _gateWayPWStr);
    
    UIButton *btn = [MyUtiles createBtnWithFrame:CGRectMake(0, 0, 100, 50) title:@"监控" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(monitorClick)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReViewGateway:) name:REVIEW_GATEWAY object:nil];
    
    [self creatTableView];
    [self createView];
    [self connectGateWay];
}

-(void)createView{

    NSArray *labelArr = @[@"网关ID",@"网关版本"];
    NSArray *imageArr = @[@"网关ID@2x",@"网关版本@2x",@"修改密码@2x",@"切换网关@2x"];
    for (int i = 0; i < 4; i++) {
        if (i < 2) {
            UILabel *label = [MyUtiles createLabelWithFrame:CGRectMake(50, _tableView.frame.origin.y+SCREEN_HEIGHT/3+20 +20 +30*i, 100, 25) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:labelArr[i]];
           // label.backgroundColor = [UIColor redColor];
            [self.view addSubview:label];
        }
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArr[i]]];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, _tableView.frame.origin.y+SCREEN_HEIGHT/3+20 +20 +30*i, 25, 25)];
        imageView.image = image;
        [self.view addSubview:imageView];
    }
    
    NSString *gateWayIDStr = [NSString stringWithUTF8String:m_map_str_gateway.begin()->second->m_strID.c_str()];   //
    NSString *gateWayAppStr = [NSString stringWithUTF8String:m_map_str_gateway.begin()->second->m_strAppID.c_str()];
    
    [[NSUserDefaults standardUserDefaults] setObject:gateWayIDStr forKey:@"gateWayIDStr"];
    [[NSUserDefaults standardUserDefaults] setObject:gateWayAppStr forKey:@"gateWayAppStr"];
    
    NSArray *label1Arr = @[gateWayIDStr,@"3.3.25"];
    for (int i = 0; i < 2; i++) {
        UILabel *label1 = [MyUtiles createLabelWithFrame:CGRectMake(150, _tableView.frame.origin.y+SCREEN_HEIGHT/3+20 +20 +30*i, 150, 25) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:label1Arr[i]];
        [self.view addSubview:label1];
    }
    
    NSArray *buttonArr = @[@"修改密码",@"切换网关"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [MyUtiles createBtnWithFrame:CGRectMake(50, _tableView.frame.origin.y+SCREEN_HEIGHT/3+20 +20 +30+30+30*i, 100, 25) title:buttonArr[i] normalBgImg:nil highlightedBgImg:nil target:self action:nil];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        if (i == 0) {
           // btn.backgroundColor = [UIColor yellowColor];
            [btn addTarget:self action:@selector(modifyGateWayPassWord) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1){
           // btn.backgroundColor = [UIColor cyanColor];
            [btn addTarget:self action:@selector(switchGateWay) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:btn];
    }
    
    UIButton *exitGateWayBtn = [MyUtiles createBtnWithFrame:CGRectMake(SCREEN_WIDTH/4, _tableView.frame.origin.y+SCREEN_HEIGHT/3+20 +20 +30+30+60+50, SCREEN_WIDTH/2, 40) title:@"退出" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(exitGateWay)];
    exitGateWayBtn.layer.masksToBounds = YES;
    exitGateWayBtn.layer.cornerRadius = 5;
    exitGateWayBtn.backgroundColor = [UIColor redColor];
    exitGateWayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [exitGateWayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitGateWayBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:exitGateWayBtn];
    
}

-(void)modifyGateWayPassWord{

    NSLog(@"修改网关密码");
    
    self.hidesBottomBarWhenPushed = YES;
    ITER_MAP_STR_GATEWAY iter = m_map_str_gateway.begin();
    advance(iter, 0);
    m_strCurID = iter->second->m_strID;
    ModifyGateWayPWViewController *modifyPWVc = [[ModifyGateWayPWViewController alloc]init];
    modifyPWVc.m_pGateway = iter->second;
    [self.navigationController pushViewController:modifyPWVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)switchGateWay{

    NSLog(@"切换网关");
    self.hidesBottomBarWhenPushed = YES;
    SwitchGateWayViewController *switchGateWayVc = [[SwitchGateWayViewController alloc]init];
    [self.navigationController pushViewController:switchGateWayVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

-(void)exitGateWay{

    NSLog(@"退出程序");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出程序" message:@"退出后，您需要重新登录才能控制设备" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消退出登录");
    }];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定退出程序");
        exit(0);
    }];
    [alertController addAction:cancleAction];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)creatTableView{

    _tableView  = [MyUtiles createTableView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3+20) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor lightGrayColor] separatorColor:[UIColor lightGrayColor] separatorStyle:UITableViewCellSeparatorStyleNone showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
}

-(void)connectGateWay{

    //ITER_MAP_STR_GATEWAY iter = m_map_str_gateway.find([_gateWayIDStr UTF8String]);
   // if (iter == m_map_str_gateway.end()){
        
    CGateway *pGetway = new CGateway;
    pGetway->m_strID = [_gateWayIDStr UTF8String];
    pGetway->m_strPW = [_gateWayPWStr UTF8String];
    if (m_map_str_gateway.size() == 0){
        pGetway->m_strAppID = m_strAppID;
    }else{
        char chAppID[65] = {0};
        sprintf(chAppID, "%s%04d", m_strAppID.c_str(), rand()%10000);
        pGetway->m_strAppID = chAppID;
    }
    m_map_str_gateway[pGetway->m_strID] = pGetway;
    bool bLocal = false;
    int iRet = connectDefault(pGetway->m_strAppID.c_str(), "0",m_strAppVer.c_str(), pGetway->m_strID.c_str(), pGetway->m_strPW.c_str(), NULL, NULL, [[[NSBundle mainBundle] resourcePath] UTF8String], NULL, bLocal);
    
    NSLog(@"iRet is %d",iRet);
    if (iRet != ERR_SUCCESS){
        if (iRet == ERR_CERTIFICATION){
            pGetway->m_iServerStatus = -4;
    }else if (iRet == ERR_LIMITED_CONN){
            pGetway->m_iServerStatus = -5;
        }else{
            pGetway->m_iServerStatus = -3;
        }
    }
    [self.tableView reloadData];
//    }else{
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"prompt"
//                                                    message:@"The gateway has been in existence"
//                                                    delegate:self
//                                           cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        [av show];
//        //[av release];
//    }
}

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return m_map_str_gateway.size();
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //static NSString *GatewayCellIdentifier = @"GatewayCellIdentifier";
    static NSString *cellID = @"DeviceListTableViewCell";
    DeviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DeviceListTableViewCell"
                                                     owner:self
                                                   options:nil];
        for (id oneObject in nib)
            if ([oneObject isKindOfClass:[DeviceListTableViewCell class]])
                cell = (DeviceListTableViewCell*)oneObject;
    }
    
    ITER_MAP_STR_GATEWAY iter = m_map_str_gateway.begin();
    advance(iter, indexPath.row);
    NSString *gateWayIDStr = [NSString stringWithUTF8String:iter->second->m_strID.c_str()];
    cell.gateWayID.text = [NSString stringWithFormat:@"网关ID: %@",gateWayIDStr];
    
    NSLog(@"连接网关的状态%d",iter->second->m_iServerStatus);
    if (iter->second->m_iServerStatus == -5){
        cell.gateWayStatus.text = @"number of connections to limit";
    }else if (iter->second->m_iServerStatus == -4){
        cell.gateWayStatus.text = @"certificate error";
    }else if (iter->second->m_iServerStatus == -3){
        cell.gateWayStatus.text = @"Failed to initialize";
    }else if (iter->second->m_iServerStatus == -2){
        cell.gateWayStatus.text = @"connecting";
    }else if (iter->second->m_iServerStatus == 0){
        char *stopped;
        int iStatus = strtol(iter->second->m_strData.c_str(), &stopped, 10);  //网关状态
        NSLog(@"iStatus is %d",iStatus);
        if (iStatus == -3){
            cell.gateWayStatus.text = @"The gateway to disconnect";
        }else if (iStatus == -2){
            cell.gateWayStatus.text = @"正在尝试连接网关...";
            [MBManager showLoadingInView:_tableView];
        }else if (iStatus == 0){
            [MBManager hideAlert];
            cell.gateWayStatus.text = @"网关连接成功";
        }else if (iStatus == -1){
            cell.gateWayStatus.text = @"The gateway connection fails";
        }else if (iStatus == 11){
            cell.gateWayStatus.text = @"网关不在线";
        }else if (iStatus == 12){
            cell.gateWayStatus.text = @"网关ID错误";
        }else if (iStatus == 13){
            cell.gateWayStatus.text = @"网关密码错误";
        }else if (iStatus == 14){
            cell.gateWayStatus.text = @"Change the new IP login";
        }else if (iStatus == 21){
            cell.gateWayStatus.text = @"修改密码成功";
            [self showAlert:@"网关密码修改成功"];
        }else if (iStatus == 22){
            cell.gateWayStatus.text = @"修改密码失败";
            [self showAlert:@"网关密码修改失败，请重试"];
        }else if (iStatus == 31){
            cell.gateWayStatus.text = @ "网关在线";
        }else if (iStatus == 32){
            cell.gateWayStatus.text = @"网关掉线";
        }else{
            cell.gateWayStatus.text = @"Server connection is successful, the gateway status is unknown";
        }
    }else if (iter->second->m_iServerStatus == -1){
        cell.gateWayStatus.text = @"Server connection is broken";
    }else{
        cell.gateWayStatus.text = @"The server connection is unknown";
    }

    NSString *strDeviceNum = [NSString stringWithFormat:@"设备数量: %ld个", m_map_id_str_device[iter->second->m_strID].size()];
    NSLog(@"设备数量2----%ld",m_map_id_str_device[m_map_str_gateway.begin()->second->m_strID].size());
    cell.gateWayDevice.text = strDeviceNum;
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.backgroundColor = [UIColor clearColor];
    cell.gateWayLogo.image = [UIImage imageNamed:@"company_logo"];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return SCREEN_HEIGHT/3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return;
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    ITER_MAP_STR_GATEWAY iter = m_map_str_gateway.begin();
//    advance(iter, indexPath.row);
//    m_strCurID = iter->second->m_strID;
//    if (!self.locksListViewController)
//    {
//        self.locksListViewController = [[LocksListViewController alloc] initWithNibName:@"DeviceListTableViewCell" bundle:nil];
//    }
//    self.locksListViewController.m_pGateway = iter->second;
//    [self.navigationController pushViewController:self.locksListViewController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndexpath = indexPath;
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"cancel"
                                            destructiveButtonTitle:@"Modify the gateway"
                                                 otherButtonTitles:@"Connect to the gateway",@"Disconnect the gateway",@"Reconnect ",@"Stop the reconnection",nil];
    [actionSheet showInView:self.view];
}

-(void)monitorClick{

    NSLog(@"监控");
}

- (void)ReViewGateway:(NSNotification *)notification{
    
    if (NO == [NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(ReViewGateway:) withObject:notification waitUntilDone:NO];
        return;
    }    
    //PackageMessage *msg = [notification.userInfo valueForKey:@"MSG"];
    [self.tableView reloadData];
}

// Pop-up box
- (void)timerFireMethod:(NSTimer*)theTimer{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{// time
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
