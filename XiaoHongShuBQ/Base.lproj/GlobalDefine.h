//
//  GlobalDefine.h
//  Bolaihui
//
//  Created by zhilin duan on 7/28/15.
//  Copyright (c) 2015 Bolaihui. All rights reserved.
//

#ifndef Bolaihui_GlobalDefine_h
#define Bolaihui_GlobalDefine_h

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "AppDelegate.h"
static const int ddLogLevel = DDLogLevelVerbose;

//#define BLH_DEBUG YES

#ifdef BLH_DEBUG
//#define BLH_HOST @"http://"
#else
//#define BLH_HOST @"http://"
#endif

// 沙盒Document路径
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

//屏幕宽、高
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define kScreen_Frame       (CGRectMake(0, 0 ,SCREEN_WIDTH,SCREEN_HEIGHT))


#define HEIGHT_TAB_BAR 49.0f
#define HEIGHT_STATUS_BAR 20.0f
#define HEIGHT_NAV_BAR 44.0f
#define HEIGHT_NAV_STATUS_BAR 64.0f

#define navigationBarColor UIColorFromRGB(33, 192, 174)

#define FONT_NORMAL 12.0f
#define FONT_BUTTON 14.0f

//项目列表一次获取数据总量
#define BLH_PAGE_SIZE 5

//获取文本的宽度
#define getTextWidth(x,y) [x sizeWithFont:GetFont(y)].width

// 获取本地字符串
#define BoLocalizedString(key)  NSLocalizedStringFromTable(key, @"Localizations", @"")

// 获取图片
#define GetImage(imageName)  [UIImage imageNamed:imageName]
#define GetPilotImage(imageName, type)  [UIImage pilotImagepathForResource:imageName withType:type]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
// 字体
#define GetFont(x) [UIFont systemFontOfSize:x]
#define GetBoldFont(x) [UIFont boldSystemFontOfSize:x]

//项目字体大小通用定义
#define BFONT_18 18.0f
#define BFONT_16 16.0f
#define BFONT_15 15.0f
#define BFONT_14 14.0f
#define BFONT_13 13.0f
#define BFONT_12 12.0f
#define BFONT_11 11.0f
#define BFONT_10 10.0f

// 颜色
#define UIColorFromRGBOne(x)  [UIColor colorWithRed:x/255.0 green:x/255.0 blue:x/255.0 alpha:1.0]
#define UIColorFromRGB(x, y, z)  [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]
#define UIColorFromRGBA(r, g, b, a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])

#define BCOLOR_33 UIColorFromRGB(0x33, 0x33, 0x33)
#define BCOLOR_99 UIColorFromRGB(0x99, 0x99, 0x99)
#define BCOLOR_73 UIColorFromRGB(0x99, 0x99, 0x99)
#define BCOLOR_LINE_H UIColorFromRGB(0xBC, 0xBB, 0xC1)
#define BCOLOR_ZI [UIColor colorWithRed:0.725 green:0.027 blue:0.718 alpha:1.00]
// 判断iOS系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// 获取系统版本号
#define SysVer [[[UIDevice currentDevice] systemVersion] floatValue]

#define NOTIFICATON_LOGIN @"user_login_notification"
#define NOTIFICATON_LOGOUT @"user_logout_notification"

#define NOTIFICATION_LOGOUT_BYSYSTEM @"auth_failed_system"
#define NOTIFICATION_ORDER_CREATE @"order_create"

//方法
static BOOL isEmpty(id thing) {
    return thing == nil
    || [thing isKindOfClass:[NSNull class]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}


#endif
