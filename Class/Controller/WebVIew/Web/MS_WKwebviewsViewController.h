//
//  MS_WKwebviewsViewController.h
//  MigratoryBirds
//
//  Created by Doj on 2018/7/13.
//  Copyright © 2018年 Doj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MS_WKwebviewsViewController : UIViewController

@property (nonatomic , strong) NSString *titleStr;/* <#注释#> */
@property (nonatomic , strong) NSString *ishy;
@property (nonatomic , strong) NSString *webviewURL;/* 加载链接 */
@property (nonatomic , strong) NSString *webHTML;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,copy) NSString *isshow;
@property (nonatomic,copy) NSString *isShare;//分享
@property (nonatomic,copy) NSString *isLxy;//辽小易 1；

@end
