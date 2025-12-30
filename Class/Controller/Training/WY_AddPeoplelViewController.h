//
//  WY_AddPeoplelViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_TraEnrolPersonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_AddPeoplelViewController : UIViewController
@property (nonatomic, strong) WY_TraEnrolPersonModel *selModel;
@property (nonatomic) BOOL onlySelf;
 @property (nonatomic,copy) void(^addSuccessBlock)(WY_TraEnrolPersonModel *selModel);
@property (nonatomic,copy) void(^updateSuccessBlock)(WY_TraEnrolPersonModel *selModel);
@property (nonatomic) int isAddOrUpdate; //1 - add / 2-update
@end

NS_ASSUME_NONNULL_END
