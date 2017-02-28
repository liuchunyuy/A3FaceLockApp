//
//  DeviceListTableViewCell.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/1/19.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "DeviceListTableViewCell.h"

@implementation DeviceListTableViewCell
//@synthesize gateWayID,gateWayStatus,gateWayDevice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
