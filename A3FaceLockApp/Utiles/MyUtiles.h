//
//  MyUtiles.h
//  LimitFree
//
//  Created by 共享 on 16/4/5.
//  Copyright (c) 2016年 shishu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
@interface MyUtiles : NSObject

//创建label
+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment color:(UIColor *)fontColor text:(NSString *)text;

//创建btn
+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title normalBgImg:(NSString *)normaoBgImgName highlightedBgImg:(NSString *)highlightedBgImgName target:(id)target action:(SEL)action;


//类型名字转换成中文
+ (NSString *)transferCateName:(NSString *)name;

//创建textField
+(UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder alignment:(UIControlContentVerticalAlignment)alignment color:(UIColor *)color keyboardType:(UIKeyboardType)keyboardType viewMode:(UITextFieldViewMode)viewMode secureTextEntry:(BOOL)secureTextEntry;

//创建tableView
+(UITableView*)createTableView:(CGRect)frame tableViewStyle:(UITableViewStyle)tableViewStyle backgroundColor:(UIColor*)backgroundColor separatorColor:(UIColor*)separatorColor separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle showsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator showsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator;

//将NSString转换成十六进制的字符串
+ (NSString *)convertStringToHexStr:(NSString *)str;

//将十六进制的字符串转换成NSString
+ (NSString *)convertHexStrToString:(NSString *)str;

//获取文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;

//获取IP地址
+(NSString *)localIPAddress;

//获取本地的PDF文件
+(CGPDFDocumentRef)pdfRefByFilePath:(NSString *)aFilePath;

//将某个时间转化成 时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
@end
