//
//  OthersViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/14.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "OthersViewController.h"
#import "AboutUsViewController.h"

@interface OthersViewController ()<UINavigationControllerDelegate>

@end

@implementation OthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.delegate = self; //实现nav代理隐藏本页面的nav
    
    [self createView];
    
}

-(void)createView{

    UIImage *image = [UIImage imageNamed:@"company_logo"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 64, SCREEN_WIDTH/3, SCREEN_WIDTH/3)];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UILabel *companyLabel = [MyUtiles createLabelWithFrame:CGRectMake(30, 64+SCREEN_WIDTH/3+20, SCREEN_WIDTH-60, 30) font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:@"上海友迪斯数字识别系统有限公司"];
    [self.view addSubview:companyLabel];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64+SCREEN_WIDTH/3+70, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    
    NSArray *btnTitleArr = @[@"关于我们",@"清除缓存"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30, 64+SCREEN_WIDTH/3+100 + 30*i+ 10, 100, 30);
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:btn];
        
        if (i == 0) {
            [btn addTarget:self action:@selector(goAboutUSVc) forControlEvents:UIControlEventTouchUpInside];
        }else if (i == 1){
            [btn addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UILabel *label = [MyUtiles createLabelWithFrame:CGRectMake(30, 64+SCREEN_WIDTH/3+100 + 30+ 10 +40, 100, 30) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:@"版    本"];
    [self.view addSubview:label];
}

-(void)clearCache{

    NSLog(@"清除缓存");
    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    
    NSString *message = size > 1 ? [NSString stringWithFormat:@"缓存%.2fM, 删除缓存", size] : [NSString stringWithFormat:@"缓存%.2fK, 删除缓存?", size * 1024.0];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action){
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject];
        [self cleanCaches:NSTemporaryDirectory()];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self showDetailViewController:alert sender:nil];
}

// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

-(void)goAboutUSVc{

    self.hidesBottomBarWhenPushed = YES;
    AboutUsViewController *aboutUsVc = [[AboutUsViewController alloc]init];
    [self.navigationController pushViewController:aboutUsVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

//隐藏本页面的nav

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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
