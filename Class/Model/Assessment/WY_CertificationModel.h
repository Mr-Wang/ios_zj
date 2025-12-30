//
//  WY_CertificationModel.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_CertificationModel : MHObject

    /**
     * 申请人姓名
     */
    @property (nonatomic , strong) NSString *  sBRName;
    /**
     * 申请人身份证
     */
    @property (nonatomic , strong) NSString *  sBRIDCard;

    /**
     * 人脸
     */
    @property (nonatomic , strong) NSString *  strData;
    /**
     * 考试ID
     */
    @property (nonatomic , strong) NSString *  ClassGuid;

@end

NS_ASSUME_NONNULL_END
