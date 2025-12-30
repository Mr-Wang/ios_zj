//
//  WY_FilterTreeModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_FilterTreeModel : MHObject
@property (nonatomic, strong) NSString *nsID;
@property (nonatomic, strong) NSString *nsTitle;
@property (nonatomic, strong) NSString *nsParentID;
@property (nonatomic, strong) NSMutableArray *arrChilds;
@property (nonatomic) BOOL isSel;
@property (nonatomic) BOOL isOpen;
@end

NS_ASSUME_NONNULL_END
