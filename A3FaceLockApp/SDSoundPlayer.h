//
//  SDSoundPlayer.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/27.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SDSoundPlayer : NSObject
@property(nonatomic,assign)float rate;   //语速

@property(nonatomic,assign)float volume; //音量

@property(nonatomic,assign)float pitchMultiplier;  //音调

@property(nonatomic,assign)BOOL  autoPlay;  //自动播放

//类方法实例出对象

+(SDSoundPlayer *)SDSoundPlayerInit;

//基础设置，如果有别的设置，也很好实现

-(void)setDefaultWithVolume:(float)aVolume rate:(CGFloat)aRate pitchMultiplier:(CGFloat)aPitchMultiplier;

//播放并给出文字

-(void)play:(NSString *)string;
@end
