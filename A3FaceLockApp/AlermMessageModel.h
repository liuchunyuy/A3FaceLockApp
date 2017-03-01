//
//  AlermMessageModel.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/3/1.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "JSONModel.h"

@interface AlermMessageModel : JSONModel
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *epData;
@end
