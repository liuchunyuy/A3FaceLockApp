//
//  LockListTableViewCell.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/21.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *controlButton;
@property (strong, nonatomic) IBOutlet UILabel *statueLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actLoading;

@property (strong, nonatomic) IBOutlet UIImageView *statueImage;
@property (strong, nonatomic) IBOutlet UILabel *danSuoLabel;

@end
