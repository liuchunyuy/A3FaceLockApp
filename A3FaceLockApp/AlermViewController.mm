//
//  AlermViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/14.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "AlermViewController.h"
#import "SZCalendarPicker.h"
@interface AlermViewController ()
@property(nonatomic,strong)UISegmentedControl *segmentedControl; //信息、警告
@property(nonatomic,copy) UIView *messageView;  //消息
@property(nonatomic,copy) UIView *alermView;    //警告
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
    
    [self createSegmentControl];
    _messageView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _alermView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    [self.view addSubview:_messageView];
    [self.view addSubview:_alermView];
    [self indexDidChangeForSegmentedControl:_segmentedControl];//默认进入信息界面
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
            _messageView.backgroundColor = [UIColor grayColor];
            break;
        case 1:
            _alermView.hidden = NO;
            _messageView.hidden = YES;
            _alermView.backgroundColor = [UIColor greenColor];
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
        
      //  NSInteger t = [MyUtiles timeSwitchTimestamp:<#(NSString *)#> andFormatter:<#(NSString *)#>]
        
//        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
//        NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
//        NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
//        
//        sendGetDeviceAlarmData(CPCHAR appID, CPCHAR gwID,CPCHAR devID, [timeString UTF8String], 10);
    };
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
