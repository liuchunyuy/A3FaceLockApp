//
//  ModifyGateWayPWViewController.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/16.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Device.h"
#include "wulianSDK.h"
@interface ModifyGateWayPWViewController : UIViewController<UIApplicationDelegate>
//{
//    CGateway* m_pGateway;
//    
//}

@property(nonatomic,copy)UITextField *oldPW;
@property(nonatomic,copy)UITextField *PWNew;
@property(nonatomic,copy)UITextField *repertPW;

//@property(nonatomic,retain)CGateway *m_pGateway;

@property CGateway *m_pGateway;

//- (void)setM_pGateway:(CGateway *)pGateway;
//- (CGateway*)m_pGateway;
@end
