//
//  AlermViewController.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/14.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Device.h"
#include "wulianSDK.h"
@interface AlermViewController : UIViewController
{
    CGateway* m_pGateway;
    CString strAreaID;
}
@property(nonatomic, strong)UITableView *messageTable;
@property(nonatomic, strong)UITableView *alermTable;
- (void)setM_pGateway:(CGateway *)pGateway;
- (CGateway*)m_pGateway;
@end
