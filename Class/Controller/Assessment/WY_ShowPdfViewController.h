//
//  WY_ShowPdfViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/19.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_PersonalScoreModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ShowPdfViewController : UIViewController

@property (nonatomic , strong) NSString *titleStr;/* <#注释#> */

@property (nonatomic , strong) NSString *webviewURL;/* 加载链接 */
@property (nonatomic , strong) NSString *yuanWebviewURL;/* 加载链接 */
@property (nonatomic,strong) NSString *type;
@property (nonatomic,copy) NSString *isshow;
@property (nonatomic , strong) NSString *isYuLan; //是预览 1 
@property (nonatomic, strong) WY_PersonalScoreModel *mWY_PersonalScoreModel;
@end

NS_ASSUME_NONNULL_END
