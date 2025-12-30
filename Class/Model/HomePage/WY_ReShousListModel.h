//
//  WY_ReShousListModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/13.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_ReShousListModel : MHObject
@property (nonatomic, readwrite, copy) NSString *ishy;
@property (nonatomic, readwrite, copy) NSString *infoid;
@property (nonatomic, readwrite, copy) NSString *keyword;
@property (nonatomic, readwrite, copy) NSString *sum;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *url;
@property (nonatomic, readwrite, copy) NSString *webUrl;
@property (nonatomic, readwrite, copy) NSString *title;



@end

NS_ASSUME_NONNULL_END
