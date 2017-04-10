//
//  AlermAlermTableViewCell.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/3/1.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlermAlermModel.h"
@interface AlermAlermTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UILabel *nameLaBEL;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong)  AlermAlermModel*model;
@end
