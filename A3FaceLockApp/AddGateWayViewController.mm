//
//  AddGateWayViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/1/17.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "AddGateWayViewController.h"

#import "SaoyisaoViewController.h"       // 扫一扫
#import "DeviceListViewController.h"  //    网关
#import "DeviceListTableViewCell.h"   //    网关cell

#import "AlermViewController.h"       //    警告信息
#import "OthersViewController.h"      //

//#import "DeviceViewController.h"      //    设备
#import "LockListViewController.h"

#import "SwitchGateWayTableViewCell.h"
@interface AddGateWayViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>{

    UITabBarController *_tabBarController;
    
}
@property(nonatomic,strong)NSString *versionStr;
@property(nonatomic) BOOL isShowMenu;

@end

@implementation AddGateWayViewController

@synthesize delegate,textID,textPW,label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setM_pGateway:(CGateway *)pGateway
{
    m_pGateway = pGateway;
   // [self SetControl];
}

- (CGateway*)m_pGateway
{
    return m_pGateway;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"login_background"];
    UIImageView *imageVc = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageVc.image = image;
    imageVc.userInteractionEnabled = YES;
    [self.view addSubview:imageVc];

    _isShowMenu = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    // [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jisshou:) name:@"changeUserName" object:nil];     //切换网关回调的通知
    [self SetControl];   // 创建UI
    [self createVersonLabel];
    [self creatTableView];     //隐藏的网关
    [self createNavRightBtn];   //nav右上角按钮
    
   // [self createUserDownMenu];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReViewGateway:) name:REVIEW_GATEWAY object:nil];     //监测网关状态

}

- (void)SetControl{
    
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(30, 80+64+SCREEN_WIDTH/3, SCREEN_WIDTH-60, 50)];
    userView.backgroundColor = [UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:0.2];
    userView.layer.cornerRadius = 10;
    userView.layer.masksToBounds = YES;
    [self.view addSubview:userView];
    
    UIView *passWordView = [[UIView alloc]initWithFrame:CGRectMake(30, 80+60+64+SCREEN_WIDTH/3, SCREEN_WIDTH-60, 50)];
    passWordView.backgroundColor = [UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:0.2];
    passWordView.layer.cornerRadius = 10;
    passWordView.layer.masksToBounds = YES;
    [self.view addSubview:passWordView];
    
    textID = [MyUtiles createTextField:CGRectMake(60, 5, SCREEN_WIDTH-60-100, 40) placeholder:@"用户名" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeDefault viewMode:UITextFieldViewModeNever secureTextEntry:NO];
    //textID.layer.cornerRadius = 4;
    //textID.layer.masksToBounds = YES5
    textID.textColor = [UIColor whiteColor];
    [textPW setBorderStyle:UITextBorderStyleNone];
   // textID.layer.borderColor = [UIColor clearColor].CGColor;
    textID.returnKeyType =UIReturnKeyDone;
   // textID.borderStyle = UITextBorderStyleRoundedRect;
    textID.delegate =self;
    [textID addTarget:self action:@selector(downMenuUsers) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn = [MyUtiles createBtnWithFrame:CGRectMake(userView.frame.size.width-40,15,20,20) title:nil normalBgImg:@"下拉@2x" highlightedBgImg:nil target:self action:@selector(userDownMenu)];
    btn.backgroundColor = [UIColor clearColor];
    [userView addSubview:btn];
    
    UIImage *image = [UIImage imageNamed:@"用户名@2x"];
    UIImageView *imageUser = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 20)];
    imageUser.image = image;
    imageUser.userInteractionEnabled = YES;
    [userView addSubview:imageUser];
    
    textPW = [MyUtiles createTextField:CGRectMake(60, 5, SCREEN_WIDTH-60-100, 40) placeholder:@"网关密码默认后六位" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor clearColor] keyboardType:UIKeyboardTypeDefault viewMode:UITextFieldViewModeNever secureTextEntry:NO];
    textPW.textColor = [UIColor whiteColor];
    [textPW setBorderStyle:UITextBorderStyleNone];
    textPW.returnKeyType =UIReturnKeyDone;
    //textPW.borderStyle = UITextBorderStyleRoundedRect;
    textPW.delegate = self;
    
    UIImage *image1 = [UIImage imageNamed:@"密码@2x"];
    UIImageView *imagePassWord = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 20)];
    imagePassWord.image = image1;
    imagePassWord.userInteractionEnabled = YES;
    [passWordView addSubview:imagePassWord];
    
    UIButton *loginBtn = [MyUtiles createBtnWithFrame:CGRectMake(30, 80+60+60+64+SCREEN_WIDTH/3, SCREEN_WIDTH-60, 50) title:@"登  录" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(OK:)];
    loginBtn.layer.cornerRadius = 10;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    loginBtn.backgroundColor = [UIColor colorWithRed:252/255.f green:86/255.f blue:88/255.f alpha:1.0];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    UIButton *saoyisaoBtn = [MyUtiles createBtnWithFrame:CGRectMake(SCREEN_WIDTH-60, 40, 40, 40) title:@"扫一扫" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(saoyisao)];
    [saoyisaoBtn setImage:[UIImage imageNamed:@"saoyisao@2x"] forState:UIControlStateNormal];
    saoyisaoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [saoyisaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saoyisaoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [saoyisaoBtn.imageView setContentMode:UIViewContentModeScaleToFill];
    [self initButton:saoyisaoBtn];
    
    [self.view addSubview:loginBtn];    //登录按钮
    _userNametableView = [MyUtiles createTableView:CGRectMake(userView.frame.origin.x, userView.frame.origin.y+55, userView.frame.size.width, userView.frame.size.height*4) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor lightGrayColor] separatorColor:[UIColor lightGrayColor] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    _userNametableView.delegate = self;
    _userNametableView.dataSource = self;
    _userNametableView.hidden = YES;
    //_userNametableView.userInteractionEnabled = YES;
    _userNametableView.layer.cornerRadius = 7;
    _userNametableView.layer.masksToBounds = YES;
    _userNametableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [_userNametableView registerNib:[UINib nibWithNibName:@"SwitchGateWayTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchGateWayTableViewCell"];
    [self.view addSubview:_userNametableView];
    
    [self.view addSubview:saoyisaoBtn]; //扫一扫按钮
    
    [userView addSubview:textID];      //ID输入框
    [passWordView addSubview:textPW];      //密码输入框
   // if (m_pGateway != NULL){
//        textID.text = [NSString stringWithUTF8String:m_pGateway->m_strID.c_str()];
//        textID.enabled = NO;
//        textPW.text = [NSString stringWithUTF8String:m_pGateway->m_strPW.c_str()];
        //label.text = @"Modify the gateway";
   // }else{
        //textID.text = @"50294D203FFB";
        textID.text = @"50294D2044C1";
        //textID.enabled = NO;
        //label.text = @"Add the gateway";
        textPW.text = @"2044C1";
   // }
}

//封装调整button上文字和图片居中，且图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+10 ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-30, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}


-(void)userDownMenu{
    
    if (_isShowMenu == YES) {
        _isShowMenu = NO;
        _userNametableView.hidden = YES;
        
    }else if (_isShowMenu == NO){
        _isShowMenu = YES;
        NSDictionary *products = [NSDictionary dictionaryWithContentsOfFile:[MyUtiles getDocumentsPath:@"oldLoginName.plist"]];
        _userArr = [NSMutableArray arrayWithArray:products.allKeys];
        [_userNametableView reloadData];
        _userNametableView.hidden = NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textID  resignFirstResponder];
    [textPW resignFirstResponder];
    _userNametableView.hidden = YES;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    NSLog(@"点击了用户名输入框");
    [textID resignFirstResponder];
    NSDictionary *products = [NSDictionary dictionaryWithContentsOfFile:[MyUtiles getDocumentsPath:@"oldLoginName.plist"]];
    _userArr = [NSMutableArray arrayWithArray:products.allKeys];
    NSLog(@"用户名arr ------%@", _userArr);
    
    [_userNametableView reloadData];
    _userNametableView.hidden = NO;
    return YES;
}

-(void)creatTableView{
    
    _tableView  = [MyUtiles createTableView:CGRectMake(0, 64, SCREEN_WIDTH, 64) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor orangeColor] separatorColor:[UIColor lightGrayColor] separatorStyle:UITableViewCellSeparatorStyleNone showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
//    _userNametableView = [MyUtiles createTableView:CGRectMake(textID.frame.origin.x, textID.frame.origin.y+45, textID.frame.size.width, textID.frame.size.height*4) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor lightGrayColor] separatorColor:[UIColor lightGrayColor] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
//    _userNametableView.delegate = self;
//    _userNametableView.dataSource = self;
//    _userNametableView.hidden = YES;
//    //_userNametableView.userInteractionEnabled = YES;
//    _userNametableView.layer.cornerRadius = 7;
//    _userNametableView.layer.masksToBounds = YES;
//    _userNametableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
//    [_userNametableView registerNib:[UINib nibWithNibName:@"SwitchGateWayTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchGateWayTableViewCell"];
//    [self.view addSubview:_userNametableView];
}

-(void)downMenuUsers{

    NSLog(@"点击了用户名输入框");
    NSDictionary *products = [NSDictionary dictionaryWithContentsOfFile:[MyUtiles getDocumentsPath:@"oldLoginName.plist"]];
    _userArr = [NSMutableArray arrayWithArray:products.allKeys];
    NSLog(@"用户名arr ------%@", _userArr);

    _userNametableView.hidden = NO;
}


-(void)connectGateWay{
    
    if (textID.text.length == 0) {
        [MBManager hideAlert];
        [MBManager showBriefMessage:@"用户名不能为空 o(>﹏<)o" InView:self.view];
        return;
    }
    if (textPW.text.length == 0) {
        [MBManager hideAlert];
        [MBManager showBriefMessage:@"密码不能为空 o(>﹏<)o" InView:self.view];
        return;
    }
    
    ITER_MAP_STR_GATEWAY iter = m_map_str_gateway.find([textID.text UTF8String]);
    if (iter == m_map_str_gateway.end()){
        
        CGateway *pGetway = new CGateway;
        pGetway->m_strID = [textID.text UTF8String];
        pGetway->m_strPW = [textPW.text UTF8String];
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
    }else{
//        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"prompt"
//                                                     message:@"The gateway has been in existence"
//                                                    delegate:self
//                                           cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        [av show];
//        //[av release];
        
        NSLog(@"加载主页面");
        [MBManager hideAlert];
        [self loadMainView];
        return;
    }
}

#pragma mark - UITableViewDelegate , UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return m_map_str_gateway.size();
    }else
        return _userArr.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == _tableView) {
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
                cell.gateWayStatus.text = @"In the gateway to connect";
            }else if (iStatus == 0){
                [MBManager hideAlert];
                cell.gateWayStatus.text = @"Gateway connection is successful";
                [self loadMainView];    // 加载主页面
            }else if (iStatus == -1){
                cell.gateWayStatus.text = @"The gateway connection fails";
            }else if (iStatus == 11){
                cell.gateWayStatus.text = @"The gateway is not online";
            }else if (iStatus == 12){
                cell.gateWayStatus.text = @"The gateway ID error";
            }else if (iStatus == 13){
                cell.gateWayStatus.text = @"The gateway password mistake";
                [MBManager hideAlert];
                [MBManager showBriefMessage:@"密码错误 o(>﹏<)o" InView:self.view];
            }else if (iStatus == 14){
                cell.gateWayStatus.text = @"Change the new IP login";
            }else if (iStatus == 21){
                cell.gateWayStatus.text = @"Change the password successfully";
            }else if (iStatus == 22){
                cell.gateWayStatus.text = @"Change the password failure";
            }else if (iStatus == 31){
                cell.gateWayStatus.text = @ "The gateway to online";
            }else if (iStatus == 32){
                cell.gateWayStatus.text = @"The gateway is offline";
            }else{
                cell.gateWayStatus.text = @"Server connection is successful, the gateway status is unknown";
            }
        }else if (iter->second->m_iServerStatus == -1){
            cell.gateWayStatus.text = @"Server connection is broken";
        }else{
            cell.gateWayStatus.text = @"The server connection is unknown";
        }
        
        NSString *strDeviceNum = [NSString stringWithFormat:@"设备: %ld个", m_map_id_str_device[iter->second->m_strID].size()];
        cell.gateWayDevice.text = strDeviceNum;
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        return cell;

    }else{
        SwitchGateWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchGateWayTableViewCell" forIndexPath:indexPath];
        cell.userLabel.text = _userArr[indexPath.row];
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
        return cell;
    }
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击了用户名列表");
    if (tableView == _userNametableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        textID.text = @"";
        textID.text = _userArr[indexPath.row];
        NSLog(@"textID.text is %@",textID.text);
        _userNametableView.hidden = YES;
    }else
        NSLog(@"-----");
}

-(void)loadMainView{

    //加载主页面
    NSMutableArray *VcArr = [[NSMutableArray alloc]init];
    _tabBarController = [[UITabBarController alloc]init];
    
    DeviceListViewController *deviceVc = [[DeviceListViewController alloc]init];
    deviceVc.gateWayIDStr = textID.text;
    deviceVc.gateWayPWStr = textPW.text;
    deviceVc.title = @"网关";
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:deviceVc];
    
    LockListViewController *locksListVc = [[LockListViewController alloc]init];
    ITER_MAP_STR_GATEWAY iter = m_map_str_gateway.begin();
    advance(iter, 0);
    m_strCurID = iter->second->m_strID;
    locksListVc.m_pGateway = iter->second;
    locksListVc.title = @"门锁";
    
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:locksListVc];
    //deviceVc.m_pGateway = locksListVc.m_pGateway;
    
    AlermViewController *alermVc = [[AlermViewController alloc]init];
    ITER_MAP_STR_GATEWAY iter1 = m_map_str_gateway.begin();
    advance(iter, 0);
    m_strCurID = iter1->second->m_strID;
    alermVc.m_pGateway = iter1->second;
    alermVc.title = @"消息";
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:alermVc];
    
    OthersViewController *otherVc = [[OthersViewController alloc]init];
    otherVc.title = @"其他";
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:otherVc];
    [VcArr addObject:nav2];
    [VcArr addObject:nav1];
    [VcArr addObject:nav3];
    [VcArr addObject:nav4];
    _tabBarController.viewControllers = VcArr;
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:252/255.f green:86/255.f blue:89/255.f alpha:1.0];   //nav 背景颜色
    //设置正常状态下的TabBar文字颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    //设置被选中状态下的TabBar文字颜色
    [[UITabBarItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:252/255.f green:13/255.f blue:17/255.f alpha:1.0]} forState:UIControlStateSelected];
    [UITabBar appearance].translucent = NO;
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:47/255.f green:47/255.f  blue:47/255.f  alpha:1.0]];   //tab背景颜色
    
    NSArray *imageArray_select = @[@"device@2x",@"gateWay@2x",@"alermMessage@2x",@"other@2x"];
    NSArray *imageArray_usual = @[@"device_2@2x",@"gateWay_2@2x",@"alermMessage_2@2x",@"other_2@2x"];
    for (int i = 0; i < imageArray_usual.count; i++) {
        UITabBarItem *item = _tabBarController.tabBar.items[i];
        
        [item setSelectedImage:[[UIImage imageNamed:imageArray_select[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setImage:[[UIImage imageNamed:imageArray_usual[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
       
    }
    [self presentViewController:_tabBarController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (tableView == _tableView) {
        return 80;
    }else
        return 35;
    
}

-(void)saoyisao{

    SaoyisaoViewController *saoyisaoVc = [[SaoyisaoViewController alloc]init];
    saoyisaoVc.returnNumberBlock = ^(NSString *str){
        textID.text = str;
        NSString * subStr2 = [textID.text substringFromIndex:textID.text.length-6];
        // textID.text.length
        textPW.text = subStr2;
    };
    UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:saoyisaoVc];
    [self presentViewController:nVC animated:YES completion:nil];
}

-(void)saveUserName:(NSString *)name andPassWord:(NSString *)password{

    if ([name rangeOfString:@" "].length > 0) {
        name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/oldLoginName.plist"]]) {
        //plist文件已经存在
        NSString *oldPath = [MyUtiles getDocumentsPath:@"oldLoginName.plist"];
        NSMutableDictionary *rootDic = [NSMutableDictionary dictionaryWithContentsOfFile:oldPath];
        NSLog(@"rootDic is %@",rootDic);
        NSArray *ketArray = rootDic.allKeys;
        if ([ketArray containsObject:name]) {
            //已经包含次用户名，但还是要写入plist
            NSLog(@"已经包含 is %@",name);
            NSMutableDictionary *childDic = [[NSMutableDictionary alloc]init];
            [childDic setObject: password forKey:name];
            [rootDic setObject:childDic forKey:name];
            [rootDic writeToFile:oldPath atomically:NO];
            NSLog(@"将%@写入到plist文件中",rootDic);
        }else{
            //未包含，写入plist文件
            NSLog(@"已经包含 is %@",name);
            NSMutableDictionary *childDic = [[NSMutableDictionary alloc]init];
            [childDic setObject: password forKey:name];
            [rootDic setObject:childDic forKey:name];
            [rootDic writeToFile:oldPath atomically:NO];
            NSLog(@"将%@写入到plist文件中",rootDic);
        }
    }else{
        //没有的时候创建plist文件
        NSMutableDictionary *rootDic = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *childDic = [[NSMutableDictionary alloc]init];
        [childDic setObject: password forKey:name];
        [rootDic setObject:childDic forKey:name];
        [rootDic writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/oldLoginName.plist"] atomically:NO];
        NSLog(@"创建plist文件 ");
    }
}

-(void)OK:(id)sender{
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBManager showLoading];
    [self connectGateWay];
    [self saveUserName:textID.text andPassWord:textPW.text];  //保存用户名
    
}

-(void)Cancel:(id)sender
{
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)createNavRightBtn{
    
    UIBarButtonItem *rightSharBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(setUp)];
    //NSArray *buttonItem = @[rightSharBt,rightMaxBt];
    self.navigationItem.rightBarButtonItem = rightSharBt;
}

-(void)setUp{
    
    NSLog(@"设置门锁：重命名、删除、关闭开门密码");
}

-(void)jisshou:(NSNotification *)notification{
    
    NSString *gateWayIDStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"gateWayIDStr"];
    NSString *gateWayAppStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"gateWayAppStr"];
    
    NSLog(@"gateWayIDStr is %@",gateWayIDStr);
    NSLog(@"gateWayAppStr is %@",gateWayAppStr);
    
    int i = sendDisConnectGwMsg([gateWayAppStr UTF8String],[gateWayIDStr UTF8String]);
    
    NSLog(@"i is %d",i);
    NSDictionary *nameDictionary = [notification userInfo];
    textID.text = [nameDictionary objectForKey:@"name"];
    return;
}

-(void)resignActive
{
    [textID resignFirstResponder];
    [textPW resignFirstResponder];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    _userNametableView.hidden = YES;
    //[self.nameTextField resignFirstResponder];
}

- (void)ReViewGateway:(NSNotification *)notification{
    
    if (NO == [NSThread isMainThread]){
        [self performSelectorOnMainThread:@selector(ReViewGateway:) withObject:notification waitUntilDone:NO];
        return;
    }
    //PackageMessage *msg = [notification.userInfo valueForKey:@"MSG"];
    [self.tableView reloadData];
}

-(void)createVersonLabel{
    
    NSString *versionStr1 = @"2.0";    //用户正在使用的版本-------代码的写死
    UILabel *versonLabel = [MyUtiles createLabelWithFrame:CGRectMake(3*(self.view.frame.size.width/4), self.view.frame.size.height-40, self.view.frame.size.width/4, 40) font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft color:[UIColor lightGrayColor] text:[NSString stringWithFormat:@"Version: %@",versionStr1]];
    [self.view addSubview:versonLabel];
    
    NSURL *url1 = [NSURL URLWithString:@"http://220.197.186.34:8081/gzdg/update_IOS.txt"];
    NSURLRequest *urlR = [NSURLRequest requestWithURL:url1];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlR completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        _versionStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"更新后的版本 is %@",_versionStr);  //更新后的版本-------从服务器获取
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_versionStr floatValue] > [versionStr1 floatValue]) {
                NSString *message = [NSString stringWithFormat:@"有新版本(%@),请到AppStore更新",_versionStr];
                UIAlertView *alertUpdate = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                _versionStr = [[NSString alloc]init];
                NSLog(@"_versionStr 清零");
                NSLog(@"_versionStr清零后 is %@",_versionStr);
                [alertUpdate show];
            }else{
                _versionStr = [[NSString alloc]init];
                NSLog(@"_versionStr 清零");
                NSLog(@"_versionStr清零后 is %@",_versionStr);
                return ;
            }
        });
    }];
    [dataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

