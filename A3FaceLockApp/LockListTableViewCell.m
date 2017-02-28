//
//  LockListTableViewCell.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/21.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "LockListTableViewCell.h"

@implementation LockListTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    for (UIView *subView in self.subviews){
//       // NSLog(@"subView.subviews is %@",self.subviews);
//        if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]){
//            UIView *confirmView=(UIView *)[subView.subviews firstObject];
//            //改背景颜色
//            //confirmView.backgroundColor=[UIColor purpleColor];
//            for(UIView *sub in confirmView.subviews){
//                if([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]){
//                    UILabel *deleteLabel=(UILabel *)sub;
//                    //改删除按钮的字体大小
//                    deleteLabel.font=[UIFont boldSystemFontOfSize:14];
//                }
//            }
//            break;
//        }
//    }
//}
- (IBAction)controlDevice:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
