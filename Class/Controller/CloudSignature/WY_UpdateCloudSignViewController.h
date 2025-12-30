//
//  WY_UpdateCloudSignViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/5/11.
//  Copyright © 2022 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_UpdateCloudSignViewController : UIViewController
@property (nonatomic , strong) NSString *isEdit; //1是编辑
@property (nonatomic , strong) NSMutableDictionary *dicEditInfo;
//特别说明
@property (nonatomic, strong) NSDictionary *yqztdStr;
//证书平台和有效期
@property (nonatomic, strong) NSMutableDictionary *dicCloudSignatureType;



@end

NS_ASSUME_NONNULL_END
