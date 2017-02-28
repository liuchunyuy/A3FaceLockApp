//
//  SaoyisaoViewController.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/2/15.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnNumBlock) (NSString *num);
@interface SaoyisaoViewController : UIViewController

@property (nonatomic, copy)returnNumBlock returnNumberBlock;

@end
