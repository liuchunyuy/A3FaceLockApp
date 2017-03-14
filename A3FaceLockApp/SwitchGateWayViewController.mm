//
//  SwitchGateWayViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/16.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "SwitchGateWayViewController.h"
#import "SwitchGateWayTableViewCell.h"

#import "AddGateWayViewController.h"
@interface SwitchGateWayViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SwitchGateWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"选择网关";
    //[self checkGateWayCount];    //取消搜索局域网网关功能
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self createTableView];

}

-(void)createTableView{

    UITableView *tableView = [MyUtiles createTableView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-200) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor colorWithRed:236/255.f green:236/255.f blue:236/255.f alpha:1.0] separatorColor:[UIColor purpleColor] separatorStyle:UITableViewCellSeparatorStyleNone showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    NSDictionary *products = [NSDictionary dictionaryWithContentsOfFile:[MyUtiles getDocumentsPath:@"oldLoginName.plist"]];
    _userArr = [NSMutableArray arrayWithArray:products.allKeys];
    NSLog(@"用户名arr ------%@", _userArr);
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    [tableView registerNib:[UINib nibWithNibName:@"SwitchGateWayTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchGateWayTableViewCell"];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   // NSLog(@"_dataArray.count = %lu",(unsigned long)_dataArray.count);
    return _userArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SwitchGateWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchGateWayTableViewCell" forIndexPath:indexPath];    
    cell.userLabel.text = _userArr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *numstr = _userArr[indexPath.row];
    
    // 断开正在登录的网关
    NSString *gateWayIDStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"gateWayIDStr"];
    NSString *gateWayAppStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"gateWayAppStr"];
    
    NSLog(@"gateWayIDStr is %@",gateWayIDStr);
    NSLog(@"gateWayAppStr is %@",gateWayAppStr);
   // int i = sendDisConnectGwMsg([gateWayAppStr UTF8String],[gateWayIDStr UTF8String]);
    
   // NSLog(@"i is %d",i);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:numstr forKey:@"name"];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeUserName" object:self userInfo:dic];
    
    //return;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeUserName" object:nil];
}

-(void)checkGateWayCount{

   // NSString *ipStr = [MyUtiles localIPAddress];
   // NSLog(@"当前局域网IP  is  %@",ipStr);
    //CString *ip = @"10.168.132.88";
   // int result = Search([ipStr UTF8String]);
   // NSLog(@"扫描局域网结果 %d", num);

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
