//
//  WY_OverallParticipationViewController.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2023/2/10.
//  Copyright © 2023 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_OverallParticipationViewController : UIViewController
@property (nonatomic, strong) NSString *bonusPoints;
@property (nonatomic, strong) NSString *unansweredDeductPoints;//年度语音电话未接听数
@property (nonatomic, strong) NSString *refuseDeductPoints;//年度主动拒绝参评数
@end

NS_ASSUME_NONNULL_END
