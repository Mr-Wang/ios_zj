//
//  WY_PushModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/11/1.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHObject.h"


NS_ASSUME_NONNULL_BEGIN

@interface WY_PushModel : MHObject
@property (nonatomic, readwrite, copy) NSString *date;
@property (nonatomic, readwrite, copy) NSString *data;
@property (nonatomic, readwrite, copy) NSString *id;
@property (nonatomic, readwrite, copy) NSString *type;
@property (nonatomic, readwrite, copy) NSString *content; 

@end

NS_ASSUME_NONNULL_END
