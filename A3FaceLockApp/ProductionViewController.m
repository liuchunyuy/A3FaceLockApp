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
    [self createView];
   // [MBManager showLoading];
   // [self createWebview];
}

-(void)createView{

    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH-20, SCREEN_HEIGHT-64)];
    [self.view addSubview:textView];
    textView.text = @"\n\n\t产品功能\n\t1. 低功耗电路设计，无需外接电源及布线；\n\t2. 具有人脸识别、密码认证及组合方式开锁功能；\n\t3. 人脸识别功能白天、夜晚均可使用；\n\t4. 具有2.8寸电容触摸液晶屏；\n\t5. 具有室内反锁功能；\n\t6. 具有开关门记录功能；\n\t7. 使用大容量锂电池（10000mAH）为主要电源，备用小\t容量锂电池应急；\n\t8. 具有电池电量自动检测、低电压提醒功能；\n\t9. 具有语音提示功能；\n\t10. 具有防掉电数据丢失功能；\n\t11. 界面简洁，操作简单，并伴有声光提示信息；\n\t12. 可接入智能家居系统；\n\t13. 超B级锁芯，隐蔽式设计，高安全级别；\n\t14. 支持外接microUSB应急电源；\n\t15. 具有通道锁功能；\n\t16. 具有电子保险功能；\n\t17. 可接入智能家居系统，支持远程操作；\n\t18. 可手动复位重启；\n\t19. 可通过U盘升级系统；\n\t20. 高安全锁体，核心部件为304不锈钢材质；\n\t21. 人机工程学把手";
    textView.font = [UIFont systemFontOfSize:15.f];
    textView.textAlignment = NSTextAlignmentJustified;
    textView.editable = NO; // 默认YES
    //textView.selectable = NO; // 默认YES 当设置为NO时，不能选择
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 15;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:attributes];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"A3production"];
    attachment.bounds = CGRectMake(20, 0, SCREEN_WIDTH-40, SCREEN_HEIGHT/3);
    NSMutableAttributedString *attachmentString = (NSMutableAttributedString *)[NSAttributedString attributedStringWithAttachment:attachment];
    // [textView.textStorage appendAttributedString:attachmentString];
    
    [textView.textStorage insertAttributedString:attachmentString atIndex:0];
   

    //NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    //NSDictionary * mDict = [NSDictionary dictionaryWithDictionary:dict];
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
