//
//  WY_HandleTempCAViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2023/10/31.
//  Copyright © 2023 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_HandleTempCAViewController : UIViewController
@property (nonatomic , strong) NSString *isEdit; //1是编辑
@property (nonatomic , strong) NSMutableDictionary *dicEditInfo;
//特别说明
@property (nonatomic, strong) NSString *yqztdStr;
//证书平台和有效期
@property (nonatomic, strong) NSMutableDictionary *dicCloudSignatureType;
//项目名称
@property (nonatomic, strong) NSString *projectName;
//项目code
@property (nonatomic, strong) NSString *tenderProjectCode;
@property (nonatomic, strong) NSString *pID;
@property (nonatomic, strong) NSString *expertId;
@end

NS_ASSUME_NONNULL_END
