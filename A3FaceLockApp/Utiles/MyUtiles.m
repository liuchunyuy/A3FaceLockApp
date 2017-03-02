//
//  MyUtiles.m
//  LimitFree
//
//  Created by 共享 on 16/4/5.
//  Copyright (c) 2016年 shishu. All rights reserved.
//

#import "MyUtiles.h"

@implementation MyUtiles

+ (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment color:(UIColor *)fontColor text:(NSString *)text;
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = font;
    label.textAlignment = textAlignment;
    label.textColor = fontColor;
    label.text = text;
    return label;
}

+ (UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title normalBgImg:(NSString *)normaoBgImgName highlightedBgImg:(NSString *)highlightedBgImgName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:normaoBgImgName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highlightedBgImgName] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn.imageView setContentMode:UIViewContentModeScaleToFill];
    return btn;
}

+(UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder alignment:(UIControlContentVerticalAlignment)alignment color:(UIColor *)color keyboardType:(UIKeyboardType)keyboardType viewMode:(UITextFieldViewMode)viewMode secureTextEntry:(BOOL)secureTextEntry{
    
    UITextField *textField = [[UITextField alloc]init];
    textField.frame = frame;
    //_passWord.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment = alignment;
    textField.placeholder = placeholder;
    [textField setFont:[UIFont boldSystemFontOfSize:14]];
    textField.backgroundColor = color;
    textField.keyboardType = keyboardType;
    textField.clearButtonMode = viewMode;
    textField.secureTextEntry = secureTextEntry;
    return textField;
}

+(UILabel*)cutLabelPosition:(UIRectCorner)corner cornerRadii:(CGSize)size{
    
    UILabel *label = [[UILabel alloc]init];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds byRoundingCorners:corner cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = label.bounds;
    maskLayer.path = maskPath.CGPath;
    label.layer.mask = maskLayer;

    return label;
}

+(UITableView*)createTableView:(CGRect)frame tableViewStyle:(UITableViewStyle)tableViewStyle backgroundColor:(UIColor*)backgroundColor separatorColor:(UIColor*)separatorColor separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle showsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator showsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator{

    UITableView *tableView = [[UITableView alloc]initWithFrame:frame style:tableViewStyle];
    tableView.frame = frame;
    //tableView.tableViewStyle = tableViewStyle;
    tableView.backgroundColor = backgroundColor;
    tableView.separatorColor = separatorColor;
    tableView.separatorStyle = separatorStyle;
    tableView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    tableView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    return tableView;
}

//将NSString转换成十六进制的字符串则可使用如下方式:
+ (NSString *)convertStringToHexStr:(NSString *)str {
    if (!str || [str length] == 0) {
        return @"";
    }
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

//将某个时间转化成 时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    return timeSp;
    
}

+ (NSString *)getDate:(NSString *)date
{
    long long time=[date longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    [df setDateFormat:@"yy-MM-dd HH:mm"];
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    NSString * timeStr =[df stringFromDate:d];
    return timeStr;
}

+ (NSString *)convertHexStrToString:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    NSString *string = [[NSString alloc]initWithData:hexData encoding:NSUTF8StringEncoding];
    return string;
}

//获取局域网IP
+ (NSString *)localIPAddress
{
    NSString *localIP = nil;
    struct ifaddrs *addrs;
    if (getifaddrs(&addrs)==0) {
        const struct ifaddrs *cursor = addrs;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                //NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                //if ([name isEqualToString:@"en0"]) // Wi-Fi adapter
                {
                    localIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    break;
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return localIP;
}

//获取文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    return path;
}

//获取本地的PDF文件
+(CGPDFDocumentRef)pdfRefByFilePath:(NSString *)aFilePath
{
    
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    size_t count;
    
    //pdf的扩展名必须重命名一下，才可以取到
    NSString* aFilePath2 = [aFilePath  stringByReplacingOccurrencesOfString:@".dat" withString:@".pdf"];
    NSError* error;
    //[[NSFileManager defaultManager] moveItemAtPath:aFilePath2 toPath:aFilePath2 error:nil];
    NSFileManager* fileManager =[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:aFilePath]) {
        //get new resource path with different extension
        
        //copy it over
        [fileManager copyItemAtPath:aFilePath toPath:aFilePath2 error:&error];
    }
    
    path = CFStringCreateWithCString (NULL, [aFilePath2   UTF8String],
                                      kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path,
                                         kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    document = CGPDFDocumentCreateWithURL (url);
    CFRelease(url);
    if (document == nil) {
        [fileManager copyItemAtPath:aFilePath2 toPath:aFilePath error:&error];
    }
    
    return document;
    
}


//将分类的英文改成中文
+ (NSString *)transferCateName:(NSString *)name
{
    
    if ([name isEqualToString:@"Business"]) {
        return @"商业";
    }else if ([name isEqualToString:@"Weather"]) {
        return @"天气";
    }else if ([name isEqualToString:@"Tool"]) {
        return @"工具";
    }else if ([name isEqualToString:@"Travel"]) {
        return @"旅行";
    }else if ([name isEqualToString:@"Sports"]) {
        return @"体育";
    }else if ([name isEqualToString:@"Social"]) {
        return @"社交";
    }else if ([name isEqualToString:@"Refer"]) {
        return @"参考";
    }else if ([name isEqualToString:@"Ability"]) {
        return @"效率";
    }else if ([name isEqualToString:@"Photography"]) {
        return @"摄影";
    }else if ([name isEqualToString:@"News"]) {
        return @"新闻";
    }else if ([name isEqualToString:@"Gps"]) {
        return @"导航";
    }else if ([name isEqualToString:@"Music"]) {
        return @"音乐";
    }else if ([name isEqualToString:@"Life"]) {
        return @"生活";
    }else if ([name isEqualToString:@"Health"]) {
        return @"健康";
    }else if ([name isEqualToString:@"Finance"]) {
        return @"财务";
    }else if ([name isEqualToString:@"Pastime"]) {
        return @"娱乐";
    }else if ([name isEqualToString:@"Education"]) {
        return @"教育";
    }else if ([name isEqualToString:@"Book"]) {
        return @"书籍";
    }else if ([name isEqualToString:@"Medical"]) {
        return @"医疗";
    }else if ([name isEqualToString:@"Catalogs"]) {
        return @"商品指南";
    }else if ([name isEqualToString:@"FoodDrink"]) {
        return @"美食";
    }else if ([name isEqualToString:@"Game"]) {
        return @"游戏";
    }else if([name isEqualToString:@"All"]){
        return @"全部";
    }
    
    return nil;
}

@end
