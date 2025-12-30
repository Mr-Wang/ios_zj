//
//  WY_CloudSignatureHandleViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/3/15.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_CloudSignatureHandleViewController : UIViewController
@property (nonatomic , strong) NSString *isEdit; //1是编辑
@property (nonatomic , strong) NSMutableDictionary *dicEditInfo;
//特别说明
@property (nonatomic, strong) NSDictionary *yqztdStr;
//证书平台和有效期
@property (nonatomic, strong) NSMutableDictionary *dicCloudSignatureType;
@end

NS_ASSUME_NONNULL_END
