//
//  AlermMessageTableViewCell.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/3/1.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "AlermMessageTableViewCell.h"


// 字符串为 nil null <null>的时候 替代方法
#define HH_IsEmptyString(object)\
(  (object == nil || \
[object isKindOfClass:[NSNull class]] ||\
[object isEqualToString:@"(null)"] || \
[object isEqualToString:@"null"] || \
[object isEqualToString:@"<null>"] )\
== 1 ? @"未命名":object\
)
@implementation AlermMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(AlermMessageModel *)model{
    
    if (_model != model) {
        _model = model;
        NSArray *arr = @[@"65",@"66",@"67",@"68",@"69",@"70",@"71",@"72",@"73",@"74",@"75",@"76",@"77",@"78",@"79",@"80",@"81",@"82",@"83",@"84"];
        if ([_model.epData  isEqual: @"1"]) {
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   App开锁",nameStr];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"app1@2x"];
        }else if ([_model.epData  isEqualToString: @"2"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   上锁",nameStr];
            _nameLabel.textColor = [UIColor colorWithRed:133/255.f green:213/255.f blue:77/255.f alpha:1.0];
            _image.image = [UIImage imageNamed:@"关门1@2x"];
        }else if ([_model.epData  isEqualToString: @"30"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   密码开锁",nameStr];
            _nameLabel.textColor = [UIColor orangeColor];
            _image.image = [UIImage imageNamed:@"密码1@2x"];
        }else if ([arr containsObject:_model.epData]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   人脸扫描开锁",nameStr];
            _nameLabel.textColor = [UIColor purpleColor];
            _image.image = [UIImage imageNamed:@"人脸1@2x"];
        }else if ([_model.epData isEqualToString:@"138"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   钥匙开锁",nameStr];
            _nameLabel.textColor = [UIColor brownColor];
            _image.image = [UIImage imageNamed:@"钥匙@2x"];
        }else if ([_model.epData isEqualToString:@"23"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   入侵警报",nameStr];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"入侵警报1@2x"];
        }else if ([_model.epData isEqualToString:@"24"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   报警解除",nameStr];
            _nameLabel.textColor = [UIColor blueColor];
            _image.image = [UIImage imageNamed:@"解除报警1@2x"];
        }else if ([_model.epData isEqualToString:@"25"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   强制上锁",nameStr];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"强制上锁1@2x"];
        }else if ([_model.epData isEqualToString:@"10"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   上保险",nameStr];
            _nameLabel.textColor = [UIColor blueColor];
            _image.image = [UIImage imageNamed:@"上保险1@2x"];
        }else if ([_model.epData isEqualToString:@"11"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   解除保险",nameStr];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"解除保险@2x"];
        }else if ([_model.epData isEqualToString:@"29"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   破坏报警",nameStr];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"破坏报警1@2x"];
        }else if ([_model.epData isEqualToString:@"31"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   密码连续出错",nameStr];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"密码连续错误1@2x"];
        }else if ([_model.epData isEqualToString:@"20"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@   反锁",nameStr];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"反锁1@2x"];
            _image.image = [UIImage imageNamed:@"company_logo"];
        }else if ([_model.epData isEqualToString:@"28"]){
            NSString *nameStr = HH_IsEmptyString(model.name);
            _nameLabel.text = [NSString stringWithFormat:@"%@ 电量低",nameStr];
        _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"电量低1@2x"];
        }
        
        _timeLabel.text = model.createDate;
        _timeLabel.textColor = [UIColor lightGrayColor];
        
        //_image.image = [UIImage imageNamed:@"company_logo"];
    }

}
@end
