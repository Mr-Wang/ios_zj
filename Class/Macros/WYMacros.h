//
//  WYMacros.h
//  WeChat
//
//  Created by Mac on 2017/9/10.
//  Copyright © 2017年 Wangyang. All rights reserved.
//  APP所有的宏常量 仅限于 #define


#ifndef MHMacros_h
#define MHMacros_h

/// 存储应用版本的key
#define MHApplicationVersionKey   @"SBApplicationVersionKey"
/// 应用名称
#define MH_APP_NAME    ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"])
/// 应用版本号
#define MH_APP_VERSION ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
/// 应用build
#define MH_APP_BUILD   ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

//服务器时间
#define kLastSaveServerTimeStamp @"kLastSaveServerTimeStamp"
#define kLastSaveLocalTimeStamp @"kLastSaveLocalTimeStamp"


// 输出日志 (格式: [时间] [哪个方法] [哪行] [输出内容])
#ifdef DEBUG
#define NSLog(format, ...)  printf("\n[%s] %s [第%d行] 💕 %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);
#else

#define NSLog(format, ...)

#endif
// 打印方法
#define MHLogFunc NSLog(@"%s", __func__)
// 打印请求错误信息
#define MHLogError(error) NSLog(@"Error: %@", error)
// 销毁打印
#define MHDealloc NSLog(@"\n =========+++ %@  销毁了 +++======== \n",[self class])

#define MHLogLastError(db) NSLog(@"lastError: %@, lastErrorCode: %d, lastErrorMessage: %@", [db lastError], [db lastErrorCode], [db lastErrorMessage]);
 
 
/// 导航条高度
#define JCNew64 (IS_IPhoneX_All?88.0f:64.0f)

/// tabBar高度
#define MH_APPLICATION_TAB_BAR_HEIGHT (IS_IPhoneX_All?83.0f:49.0f)
 
/// 状态栏高度
#define MH_APPLICATION_STATUS_BAR_HEIGHT (IS_IPhoneX_All?44:20.0f)

 

///------
/// iOS Version
///------
#define MHIOSVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define MH_iOS7_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
#define MH_iOS8_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)
#define MH_iOS9_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 9.0)
#define MH_iOS10_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
#define MH_iOS11_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 11.0)
#define MH_iOS12_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 12.0)
#define MH_iOS13_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 13.0)
#define MH_iOS14_VERSTION_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 14.0)

  

// KVO获取监听对象的属性 有自动提示
// 宏里面的#，会自动把后面的参数变成c语言的字符串
#define MHKeyPath(objc,keyPath) @(((void)objc.keyPath ,#keyPath))

// 颜色
#define MHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 颜色+透明度
#define MHColorAlpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define MHRandomColor MHColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 根据rgbValue获取对应的颜色
#define MHColorFromRGB(__rgbValue) [UIColor colorWithRed:((float)((__rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((__rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(__rgbValue & 0xFF))/255.0 alpha:1.0]

#define MHColorFromRGBAlpha(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


// AppCaches 文件夹路径
#define MHCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
// App DocumentDirectory 文件夹路径
#define MHDocumentDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

// 系统放大倍数
#define MHScale [[UIScreen mainScreen] scale]

// 设置图片
#define MHImageNamed(__imageName) [UIImage imageNamed:__imageName]

/// 根据hex 获取颜色
#define MHColorFromHexString(__hexString__) ([UIColor colorFromHexString:__hexString__])

//  通知中心
#define MHNotificationCenter [NSNotificationCenter defaultCenter]



 
// 是否为空对象
#define MHObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

// 字符串为空
#define MHStringIsEmpty(__string) ((__string.length == 0) || MHObjectIsNil(__string))

// 字符串不为空
#define MHStringIsNotEmpty(__string)  (!MHStringIsEmpty(__string))

// 数组为空
#define MHArrayIsEmpty(__array) ((MHObjectIsNil(__array)) || (__array.count==0))

/// 适配iPhone X + iOS 11
#define  MHAdjustsScrollViewInsets_Never(__scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([__scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = __scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)


//// --------------------  下面是公共配置  --------------------
  

#ifdef DEBUG
#define MSLog(...) NSLog(__VA_ARGS__)
#else
#define MSLog(...)
#endif


//获取屏幕 宽度、高度
#define MSScreenW ([UIScreen mainScreen].bounds.size.width)
#define MSScreenH ([UIScreen mainScreen].bounds.size.height)
 
#define JPush_KEY @"4c81858c536edad4fbc2f4c8"
   

//状态栏、导航栏、标签栏高度
#define Height_StatusBar [[UIApplication sharedApplication] statusBarFrame].size.height
#define Height_NavBar 44.0f


#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height >= 800)

// Tabbar safe bottom margin.
#define  JC_TabbarSafeBottomMargin  (IS_IPhoneX_All ? 34.f : 0.f)

 
//16进制
#define MSHexColor(c) [UIColor colorWithHexString:c]

//RGB颜色设置
#define MSColorA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]



#define randomColor MSColorA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//字体根据屏幕宽度适应
#define MSadaptedFont(x) [UIFont systemFontOfSize:MIN(x,MSAdaptedWidth(x))]

#define MSColor(r,g,b) MSColorA(r,g,b,1.0f)


#define MSString(str)    NSLocalizedString((str), nil)

//#999999
#define APPLightGrayColor MSColor(153,153,153)
//#333333
#define APPBlackColor MSColor(51,51,51)

#define YFColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


#define MSTHEMEColor HEXCOLOR(0x448EEE) //MSColor(73, 168, 238)//主题色
#define APPRedColor MSColor(252,141,91)
#define APPGreenColor MSColor(1,187,112)
 #define APPWhiteColor MSColor(255,255,255)
#define APPTextBlackColor YFColor(38, 38, 38)
#define APPTextGayColor YFColor(127, 127, 127)
#define APPTableViewLine YFColor(221, 221, 221)
#define BGColor YFColor(245,245,245)

#define APPLineColor MSColor(238,238,238)

#define MSSH (MSScreenH>667?667:MSScreenH)
#define kWidth(R) (R)*(MSScreenW)/750
#define kHeight(R) (R)*(MSSH)/1334
#define FontShowSize [[NSUserDefaults standardUserDefaults] objectForKey:@"FontShowSize"]

#define CURRENTVERSION [[NSUserDefaults standardUserDefaults] boolForKey:@"CURRENTVERSION"]

///专家- 查询是是不是社会专家，社会紫（超龄）1、社会蓝（甲方）2、不是专家10
#define EXPERTISMIND [[NSUserDefaults standardUserDefaults] integerForKey:@"ExpertIsMind"]

#define k360Width(R) (R)*(MSScreenW)/(360 - [FontShowSize intValue])
#define k375Width(R) (R)*(MSScreenW)/375


// 屏幕的宽度

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height



#define Project_AppDelegate     ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define Project_tabbarController        (Project_AppDelegate.tabbarController)

#define Project_window Project_AppDelegate.window



#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
 
//16进制图片
#define MSHexColor(c) [UIColor colorWithHexString:c]

//  字体宏
#define YF_FONTSYS(size) ([UIFont systemFontOfSize:(size+FontSizeRatio)])
#define FontSizeRatio (kScreenWidth>320?2:0)
//字体宏 -平方 -正常
#define WY_FONTRegular(fontSize) ([UIFont fontWithName:@"PingFangSC-Regular" size:k360Width((fontSize))])
//字体宏 -平方 -粗体
#define WY_FONTMedium(fontSize) ([UIFont fontWithName:@"PingFangSC-Medium" size:k360Width((fontSize))])

//字体宏 -平方 -正常
#define WY_FONT375Regular(fontSize) ([UIFont fontWithName:@"PingFangSC-Regular" size:k375Width((fontSize))])
//字体宏 -平方 -粗体
#define WY_FONT375Medium(fontSize) ([UIFont fontWithName:@"PingFangSC-Medium" size:k375Width((fontSize))])

//倍率
#define Ratio  ([UIScreen mainScreen].bounds.size.width/320)

#define YF_CustomFont(fontSize) ([UIFont fontWithName:@"PingFang-SC-Regular" size:(fontSize+FontSizeRatio)]?[UIFont fontWithName:@"PingFang-SC-Regular" size:(fontSize+FontSizeRatio)]:[UIFont systemFontOfSize:fontSize+FontSizeRatio])

#define YF_FONTBOLDSYS(size) ([UIFont boldSystemFontOfSize:(size+FontSizeRatio)])


#define ViewX(view) ((view).frame.origin.x)
#define ViewY(view) ((view).frame.origin.y)
#define ViewW(view) ((view).frame.size.width)
#define ViewH(view) ((view).frame.size.height)

// 定义字体大小
#define MSFONT(n)   [UIFont systemFontOfSize:n]

//弱引用自身
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

// 判断当前设备型号
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
 

//退出登录Notify
#define NOTIFY_RELOGIN @"NOTIFY_RELOGIN"

//科大讯飞的
#define APPID_VALUE           @"5ffaabef"
#define URL_VALUE             @""                 // url
#define TIMEOUT_VALUE         @"20000"            // timeout, Unit:ms
#define BEST_URL_VALUE        @"1"                // best_search_url

#define SEARCH_AREA_VALUE     @"Hefei,Anhui"
#define ASR_PTT_VALUE         @"1"
#define VAD_BOS_VALUE         @"5000"
#define VAD_EOS_VALUE         @"1800"
#define PLAIN_RESULT_VALUE    @"1"
#define ASR_SCH_VALUE         @"1"

/// 云签章配置
#define KTIMESTAMP_SERVER_ADDRESS_SIGNAL            @"timestampAddressAndPort"
#define KTIMESTAMP_DEFAULT_SERVER_ADDRESS           @"http://210.74.41.195/timestamp"

/// 其他常量配置
#import "WYURLConfigure.h"
#import "WYConstEnum.h"

#endif /* MHMacros_h */
