//
//  ModifyGateWayPWViewController.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/16.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "ModifyGateWayPWViewController.h"


@interface ModifyGateWayPWViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ModifyGateWayPWViewController
//@synthesize oldPW,repertPW,m_pGateway,PWNew;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)setM_pGateway:(CGateway *)pGateway{
//    m_pGateway = pGateway;
//}
//
//- (CGateway*)m_pGateway{
//    return m_pGateway;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"修改网关密码";
    
    //添加self.view的点击事件（点击屏幕空白取消键盘）
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    
    [self createView];
    
}

-(void)createView{

    NSArray *titleArr = @[@"原密码",@"新密码",@"确认密码"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [MyUtiles createLabelWithFrame:CGRectMake(30, 84+32*i, 70, 30) font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter color:[UIColor blackColor] text:titleArr[i]];
        label.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:label];
    }
    _oldPW = [MyUtiles createTextField:CGRectMake(30+70+20, 84, SCREEN_WIDTH-70-20-60, 30) placeholder:@"输入原密码" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor whiteColor] keyboardType:UIKeyboardTypeDefault viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    _PWNew = [MyUtiles createTextField:CGRectMake(30+70+20, 84+32*1, SCREEN_WIDTH-70-20-60, 30) placeholder:@"输入新密码" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor whiteColor] keyboardType:UIKeyboardTypeDefault viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    _repertPW = [MyUtiles createTextField:CGRectMake(30+70+20, 84+32*2, SCREEN_WIDTH-70-20-60, 30) placeholder:@"确认新密码" alignment:UIControlContentVerticalAlignmentCenter color:[UIColor whiteColor] keyboardType:UIKeyboardTypeDefault viewMode:UITextFieldViewModeAlways secureTextEntry:NO];
    
    UIButton *okButton = [MyUtiles createBtnWithFrame:CGRectMake(30, 84+32*2+30+50, SCREEN_WIDTH-60, 30) title:@"确定" normalBgImg:nil highlightedBgImg:nil target:self action:@selector(modifyPassWord)];
    okButton.backgroundColor = [UIColor redColor];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [self.view addSubview:okButton];
    [self.view addSubview:_oldPW];
    [self.view addSubview:_PWNew];
    [self.view addSubview:_repertPW];
}

-(void)modifyPassWord{

    NSLog(@"确定修改网关密码");
    NSString *message = NULL;
    if (_oldPW.text.length == 0||_PWNew.text.length == 0||_repertPW.text.length == 0){
        message = @"密码不能为空";
    }else if([_oldPW.text UTF8String] != _m_pGateway->m_strPW){
        message = @"原密码不正确";
    }else if (![_PWNew.text isEqualToString:_repertPW.text]){
        message = @"两次新密码不匹配";
    }if (message != NULL){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertView show];
    }else{
        m_strChangePw = [_PWNew.text UTF8String];
        sendChangeGwPwdMsg(_m_pGateway->m_strAppID.c_str(), _m_pGateway->m_strID.c_str(), [_oldPW.text UTF8String], [_PWNew.text UTF8String]);
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    //[self.nameTextField resignFirstResponder];
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
