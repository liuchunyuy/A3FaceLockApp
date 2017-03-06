//
//  AddGateWayViewController.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/1/17.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Device.h"

@protocol AddGatewayViewControllerDelegate;
@interface AddGateWayViewController : UIViewController<UITextFieldDelegate>{

    CGateway *m_pGateway;
}

- (void)setM_pGateway:(CGateway *)pGateway;
- (CGateway*)m_pGateway;

@property(nonatomic,assign)id<AddGatewayViewControllerDelegate>delegate;

@property(nonatomic,strong) UITableView *tableView;  //  网关
@property(nonatomic,strong) UITableView *userNametableView;  //  用户名
@property(nonatomic,strong)NSMutableArray *userArr;  // 用户名数组
@property(nonatomic,strong)UITextField *textID;
@property(nonatomic,strong)UITextField *textPW;
@property(nonatomic,strong)UILabel *label;


-(void)OK:(id)sender;
-(void)Cancel:(id)sender;
-(void)resignActive;
@end

@protocol AddGatewayViewControllerDelegate
- (void)AddGatewayViewControllerDidOK:(NSString*)strID PASSWORD:(NSString*)strPW;
- (void)EditGatewayViewControllerDidOK:(NSString*)strID PASSWORD:(NSString*)strPW;
@end