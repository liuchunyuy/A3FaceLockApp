//
//  AlermAlermModel.h
//  A3FaceLockApp
//
//  Created by GavinHe on 2017/3/1.
//  Copyright © 2017年 Liu Chunyu. All rights reserved.
//

#import "JSONModel.h"

@interface AlermAlermModel : JSONModel
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *createDate;
@property (nonatomic,strong) NSString *epData;
@end
