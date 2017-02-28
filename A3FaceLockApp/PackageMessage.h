//
//  PackageDevice.h
//  Demo
//
//  Created by mini2 on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <string>
@interface PackageMessage : NSObject

@property (nonatomic,assign) std::string m_strID;
@property (nonatomic,assign) std::string m_strDeviceID;
@property (nonatomic,assign) std::string m_strAreaID;
@property (nonatomic,assign) std::string m_strSceneID;

@end
