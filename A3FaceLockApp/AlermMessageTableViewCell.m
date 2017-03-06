//
//  AlermMessageTableViewCell.m
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/3/1.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "AlermMessageTableViewCell.h"

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
            _nameLabel.text = [NSString stringWithFormat:@"%@   App开锁",model.name];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"app1@2x"];
        }else if ([_model.epData  isEqualToString: @"2"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   上锁",model.name];
            _nameLabel.textColor = [UIColor colorWithRed:133/255.f green:213/255.f blue:77/255.f alpha:1.0];
            _image.image = [UIImage imageNamed:@"locked1@2x"];
        }else if ([_model.epData  isEqualToString: @"30"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   密码开锁",model.name];
            _nameLabel.textColor = [UIColor orangeColor];
            _image.image = [UIImage imageNamed:@"password1@2x"];
        }else if ([arr containsObject:_model.epData]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   人脸扫描开锁",model.name];
            _nameLabel.textColor = [UIColor purpleColor];
            _image.image = [UIImage imageNamed:@"face1@2x"];
        }else if ([_model.epData isEqualToString:@"138"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   钥匙开锁",model.name];
            _nameLabel.textColor = [UIColor brownColor];
            _image.image = [UIImage imageNamed:@"key@2x"];
        }else if ([_model.epData isEqualToString:@"23"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   入侵警报",model.name];
            _nameLabel.textColor = [UIColor redColor];
        }else if ([_model.epData isEqualToString:@"24"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   报警解除",model.name];
            _nameLabel.textColor = [UIColor blueColor];
        }else if ([_model.epData isEqualToString:@"25"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   强制上锁",model.name];
            _nameLabel.textColor = [UIColor redColor];
        }else if ([_model.epData isEqualToString:@"10"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   上保险",model.name];
            _nameLabel.textColor = [UIColor blueColor];
        }else if ([_model.epData isEqualToString:@"11"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   解除保险",model.name];
            _nameLabel.textColor = [UIColor redColor];
        }else if ([_model.epData isEqualToString:@"29"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   破坏报警",model.name];
            _nameLabel.textColor = [UIColor redColor];
        }else if ([_model.epData isEqualToString:@"31"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   密码连续出错",model.name];
            _nameLabel.textColor = [UIColor redColor];
        }else if ([_model.epData isEqualToString:@"20"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@   反锁",model.name];
            _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"company_logo"];
        }else if ([_model.epData isEqualToString:@"28"]){
            _nameLabel.text = [NSString stringWithFormat:@"%@ 电量低",model.name];
        _nameLabel.textColor = [UIColor redColor];
            _image.image = [UIImage imageNamed:@"powerlow1@2x"];
        }
        
        _timeLabel.text = model.createDate;
        _timeLabel.textColor = [UIColor lightGrayColor];
        
        //_image.image = [UIImage imageNamed:@"company_logo"];
    }

}
@end
