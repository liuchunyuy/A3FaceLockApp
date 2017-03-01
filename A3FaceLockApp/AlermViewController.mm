//
//  AlermViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/14.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "AlermViewController.h"
#import "SZCalendarPicker.h"

#import "AlermMessageTableViewCell.h"
#import "AlermMessageModel.h"

#import "AlermAlermTableViewCell.h"
#import "AlermAlermModel.h"

#import "MJRefresh.h"
@interface AlermViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UISegmentedControl *segmentedControl; //信息、警告
@property(nonatomic,copy) UIView *messageView;  //消息
@property(nonatomic,copy) UIView *alermView;    //警告
@property(nonatomic,copy)NSMutableArray *messageArr;  //消息数组
@property(nonatomic,copy)NSMutableArray *alermArr;  //警告数组

@property(nonatomic,copy)NSMutableArray *alermArr1;  //截取后的警告数组
@end

@implementation AlermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [MyUtiles createBtnWithFrame:CGRectMake(0, 0, 100, 50) title:@"选择日期" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(dataClick)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [self createTableView];
    [self createSegmentControl];
    _messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _alermView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    [self.view addSubview:_messageView];
    [self.view addSubview:_alermView];
    
    [_messageView addSubview:_messageTable];
    [_alermView addSubview:_alermTable];
    
    [MBManager showLoading];
    [self indexDidChangeForSegmentedControl:_segmentedControl];//默认进入信息界面
    [self dataPick];       //默认获取当天信息
}

-(void)createTableView{

    _messageArr = [NSMutableArray array];
    _alermArr = [NSMutableArray array];
    _alermArr1 = [NSMutableArray array];
    
    _messageTable = [MyUtiles createTableView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor whiteColor] separatorColor:[UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    _messageTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    _messageTable.delegate = self;
    _messageTable.dataSource =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_messageTable registerNib:[UINib nibWithNibName:@"AlermMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlermMessageTableViewCell"];
    
    _alermArr = [NSMutableArray array];
    _alermTable = [MyUtiles createTableView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) tableViewStyle:UITableViewStylePlain backgroundColor:[UIColor whiteColor] separatorColor:[UIColor colorWithRed:64/255.f green:76/255.f blue:86/255.f alpha:1.0] separatorStyle:UITableViewCellSeparatorStyleSingleLine showsHorizontalScrollIndicator:NO showsVerticalScrollIndicator:NO];
    _alermTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//取消空白的cell
    _alermTable.delegate = self;
    _alermTable.dataSource =self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_alermTable registerNib:[UINib nibWithNibName:@"AlermAlermTableViewCell" bundle:nil] forCellReuseIdentifier:@"AlermAlermTableViewCell"];
    
    [self addHeaderFooter];
}

-(void)addHeaderFooter{
    
    _messageTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_messageArr removeAllObjects];
        [self dataPick];
    }];
    
    _messageTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_messageArr removeAllObjects];
        [self dataPick];
    }];
    
    _alermTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [_alermArr removeAllObjects];
        [self dataPick];
    }];
    
    _alermTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [_alermArr removeAllObjects];
        [self dataPick];
    }];
    
}

-(void)createSegmentControl{
    
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"信息",@"警告",nil];
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(0, 0, 100, 25);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:1.0 alpha:1.0];
    [_segmentedControl addTarget:self  action:@selector(indexDidChangeForSegmentedControl:)
                forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentedControl];
}

-(void)indexDidChangeForSegmentedControl:(UISegmentedControl *)segment{

    int index = (int)_segmentedControl.selectedSegmentIndex;
    switch (index) {
        case 0:
            _alermView.hidden = YES;
            _messageView.hidden = NO;
            //[_messageArr removeAllObjects];
            //[self dataPick];
            break;
        case 1:
            _alermView.hidden = NO;
            _messageView.hidden = YES;
            //_alermView.backgroundColor = [UIColor greenColor];
            break;
        default:
            break;
    }
}

-(void)dataClick{

    NSLog(@"选择其他日期");
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(0, 100, self.view.frame.size.width, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
        
        NSString *date = [NSString stringWithFormat:@"%li-%li-%li 23:59:60", (long)year,(long)month,(long)day];
        NSLog(@"date is %@",date);
    
        NSDate * senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:date];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        NSDate * now = [dateformatter dateFromString:locationString];
        NSTimeInterval a = [now timeIntervalSince1970]*1000;
        //转成时间戳
        NSString *timeSp = [NSString stringWithFormat:@"%.0f", a];
        
        int t =  sendGetDeviceAlarmData(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(),NULL, [timeSp UTF8String], "50");
        ITER_MAP_STR_GATEWAY iter = m_map_str_gateway.begin();
        advance(iter, 0);
        NSString *gateWayIDStr = [NSString stringWithUTF8String:iter->second->data.c_str()];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[gateWayIDStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        
        NSArray *array = [dic objectForKey:@"retData"];
    
        NSArray *models = [AlermMessageModel arrayOfModelsFromDictionaries:array];
        
        [_messageArr addObjectsFromArray:models];
        [_messageTable reloadData];
        
        [_messageTable.mj_header endRefreshing];
        [_messageTable.mj_footer endRefreshing];

        NSLog(@"时间戳timeString is %@",timeSp);
        NSLog(@"获取警告信息结果t is %d",t);
    };
}

-(void)dataPick{     //当前时间

    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    
    int t =  sendGetDeviceAlarmData(m_pGateway->m_strAppID.c_str(), m_pGateway->m_strID.c_str(),NULL, [timeString UTF8String], "50");
    
    ITER_MAP_STR_GATEWAY iter = m_map_str_gateway.begin();
    advance(iter, 0);
    NSString *gateWayIDStr = [NSString stringWithUTF8String:iter->second->data.c_str()];
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[gateWayIDStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    
    NSArray *array = [dic objectForKey:@"retData"];
   // NSLog(@"获取警告信息结果 is%@",array);
    
    NSArray *models = [AlermMessageModel arrayOfModelsFromDictionaries:array];
    [_messageArr addObjectsFromArray:models];
    [_messageTable reloadData];
    
    [MBManager hideAlert];
    [_messageTable.mj_header endRefreshing];
    [_messageTable.mj_footer endRefreshing];
    
    
    for (NSDictionary *dic in array) {
        NSString *nameStr = [NSString stringWithFormat:@"%@",dic[@"epData"]];
        if ([nameStr isEqualToString:@"10"]||[nameStr isEqualToString:@"11"]||[nameStr isEqualToString:@"20"]||[nameStr isEqualToString:@"23"]||[nameStr isEqualToString:@"24"]||[nameStr isEqualToString:@"25"]||[nameStr isEqualToString:@"28"]||[nameStr isEqualToString:@"29"]||[nameStr isEqualToString:@"31"]) {
            [_alermArr1 addObject:dic];
        }
    }
    NSLog(@"_alermArr is %@",_alermArr1);  //截取后的警告数组
    NSArray *models1 = [AlermAlermModel arrayOfModelsFromDictionaries:_alermArr1];
    [_alermArr addObjectsFromArray:models1];
    
    [_alermTable reloadData];
    
    [_alermTable.mj_header endRefreshing];
    [_alermTable.mj_footer endRefreshing];
    NSLog(@"时间戳timeString is %@",timeString);
    NSLog(@"获取警告信息结果t is %d",t);
}

#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == _messageTable) {
        return _messageArr.count;
    }else{
        return _alermArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _messageTable) {
        AlermMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlermMessageTableViewCell" forIndexPath:indexPath];
        cell.model = _messageArr[indexPath.row];
        return cell;
    }else{
        AlermAlermTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlermAlermTableViewCell" forIndexPath:indexPath];
        cell.model = _alermArr[indexPath.row];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (void)setM_pGateway:(CGateway *)pGateway{
    
    m_pGateway = pGateway;
}

- (CGateway*)m_pGateway{
    
    return m_pGateway;
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
