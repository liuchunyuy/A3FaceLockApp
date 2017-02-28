//
//  DeviceListTableViewCell.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/1/19.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *gateWayID;
@property (strong, nonatomic) IBOutlet UILabel *gateWayStatus;
@property (strong, nonatomic) IBOutlet UILabel *gateWayDevice;

@property (strong, nonatomic) IBOutlet UIImageView *gateWayLogo;
@end
