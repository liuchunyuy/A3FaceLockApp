//
//  AboutUsViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/16.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<UITextViewDelegate>

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"公司简介";
    //左按钮颜色
   // [MBManager showLoading];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createView];
    //[self createWebView];
}

-(void)createWebView{
 
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webview.scalesPageToFit = YES;
    [self.view addSubview:webview];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"companyIntrduce.pdf" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    [MBManager hideAlert];

}

-(void)createView{
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH-20, SCREEN_HEIGHT-64)];
    [self.view addSubview:textView];
    textView.text = @"\n\t加拿大联合数字识别系统（Udis）有限公司2007年成立于加拿大温哥华，是一家致力于生物识别、数字识别的高科技公司，公司拥有完整的面部识别技术，并推出了性能稳定、技术优越的面部识别数字电路模块SDM32及行为分析系统BAV3.0等系列产品。\n\t上海友迪斯数字识别系统股份有限公司（简称Udis）是由加拿大联合数字识别系统有限公司与上海鑫洽投资管理咨询事务所（原上海精工科技管理层合伙）发起，经对原上海精工科技有限公司(简称FORBUG)的优质资产吸收合并而成立的股份制公司。上海精工是国内知名的特种行业通道控制的专家，在银行金库、枪弹库、市政府、武警系统等部门的特种通道控制领域拥有超过50%的市场占有率。\n\tUdis充分发挥加方高性能数字模块的核心优势及上海精工在特种行业中的丰富行业经验，尤其是高安全专用锁具机电一体化系统设计及方案整合优势，率先推出全球第一款Udis高端面部识别锁及Udis高端面部识别保险柜。随着Udis系列产品的相继问世，Udis 必将引领新一代科技产品改善人们的生活方式，深刻体验安全、快捷、时尚、现代的全新生活感受。\n\t16年来我们一直专注于智能锁具的研发和推广。全国700家监狱中的460家采用了我们的智能锁具，Udis人脸识别锁A5和A6两个系列产品是我们16年的研发技术成果，广泛应用于民用市场。而A3人脸锁产品打破了过去功能单一的诟病，集人脸、密码、远程、机械钥匙开锁的各项功能，必将成为一款明星产品。\n\t我们是第一家推出人脸识别锁的公司，在监狱系统已经得到广泛推广和应用。相比指纹锁，人脸识别锁有12项优势，是未来智能锁具发展的必然选择。\n\n🔗:\twww.udis.cn\n☎️:\t021-37128056 \n➡️:\t中国上海奉贤区望园路2066弄5号楼4楼";
    textView.font = [UIFont systemFontOfSize:15.f];
    textView.textAlignment = NSTextAlignmentNatural;
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
    attachment.image = [UIImage imageNamed:@"other_company@2x"];
    attachment.bounds = CGRectMake(10, 0, SCREEN_WIDTH-30, SCREEN_HEIGHT/4);
    NSMutableAttributedString *attachmentString = (NSMutableAttributedString *)[NSAttributedString attributedStringWithAttachment:attachment];
    // [textView.textStorage appendAttributedString:attachmentString];
    
    [textView.textStorage insertAttributedString:attachmentString atIndex:0];
    

//    NSLog(@"打电话给: %@", _nameArr[indexPath.row]);
//    NSString *telStr = [NSString stringWithFormat:@"%@", _numArr[indexPath.row]];
//    UIWebView *callWebView = [[UIWebView alloc] init];
//    NSURL *telURL= [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telStr]];
//    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
//    [self.view addSubview:callWebView];
    
    
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
