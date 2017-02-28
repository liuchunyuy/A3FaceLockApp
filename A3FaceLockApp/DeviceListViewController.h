//
//  DeviceListViewController.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/1/18.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Device.h"
#include "wulianSDK.h"
#import "PackageMessage.h"
@interface DeviceListViewController : UIViewController
{
    CGateway* m_pGateway;
    
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSString *gateWayIDStr;
@property(nonatomic,copy) NSString *gateWayPWStr;
@property(nonatomic,copy) NSString *gateWayVerStr;  //网关版本
@property (nonatomic,retain)NSIndexPath *selectedIndexpath;

- (void)setM_pGateway:(CGateway *)pGateway;
- (CGateway*)m_pGateway;
@end
