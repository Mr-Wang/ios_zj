//
//  WY_UploadZJCAPhotoViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/8/31.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_ExpertMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_UploadZJCAPhotoViewController : UIViewController
@property (nonatomic , strong) WY_ExpertMessageModel *mWY_ExpertMessageModel;
@property (nonatomic,strong) NSString*source;

@end

NS_ASSUME_NONNULL_END
