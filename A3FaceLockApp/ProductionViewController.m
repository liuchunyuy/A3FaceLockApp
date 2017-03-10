//
//  ProductionViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/15.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "ProductionViewController.h"

@interface ProductionViewController ()<UIWebViewDelegate>

@end

@implementation ProductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"A3人脸锁";
    //左按钮颜色
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
   // [self createView];
    [MBManager showLoading];
    [self createWebview];
}

-(void)createWebview{
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webview.scalesPageToFit = YES;
    [self.view addSubview:webview];    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"UdisA3.pdf" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    [MBManager hideAlert];    
}



//-(void)createView{
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://udis888.1688.com"]];
//    webView.scalesPageToFit = YES;
//    [webView loadRequest:request];
//    [self.view addSubview: webView];
//}

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
