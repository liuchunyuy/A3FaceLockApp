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
  //  [self createView];
    
    UIWebView *tempWV = [[UIWebView alloc] init];
    [tempWV setFrame:self.view.frame];
   // [self.view addSubview:tempWV];
   // [self loadDocument:@"UdisA3" inView:tempWV];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createView];
}

-(void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

-(void)createView{

    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH-20, SCREEN_HEIGHT-64)];
    [self.view addSubview:textView];
    textView.text = @"\n    这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。\n    这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。\n    这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。\n    这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字,这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。\n    这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字,这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。\n    这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字,这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。\n    这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字,这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字。\n这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字，这是一段文字";
    textView.font = [UIFont systemFontOfSize:15.f];
    textView.textAlignment = NSTextAlignmentJustified;
    textView.editable = NO; // 默认YES
    textView.selectable = NO; // 默认YES 当设置为NO时，不能选择
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"head"];
    attachment.bounds = CGRectMake(10, 0, SCREEN_WIDTH-30, SCREEN_HEIGHT/4);
    NSMutableAttributedString *attachmentString = (NSMutableAttributedString *)[NSAttributedString attributedStringWithAttachment:attachment];
    
   // [textView.textStorage appendAttributedString:attachmentString];
    
    [textView.textStorage insertAttributedString:attachmentString atIndex:1];
    
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
