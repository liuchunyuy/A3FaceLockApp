//
//  LockListViewController.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/21.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Device.h"
#include "wulianSDK.h"

@class LockListTableViewCell;

@interface LockListViewController : UIViewController{
    CGateway* m_pGateway;
    CString strAreaID;
}
@property CDevice *m_pDevice;

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) LockListTableViewCell *cell;
@property(nonatomic,strong) UIActivityIndicatorView * act;
@property (nonatomic,assign)NSInteger selectIndex;
- (void)setM_pGateway:(CGateway *)pGateway;
- (CGateway*)m_pGateway;

@end
