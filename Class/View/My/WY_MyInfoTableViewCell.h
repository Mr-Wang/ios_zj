//
//  WY_MyInfoTableViewCell.h
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
 NS_ASSUME_NONNULL_BEGIN

@interface WY_MyInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *cellBackgroudImage;
@property (nonatomic, strong) UIImageView *cellBottomColor;

/// 头像
@property (nonatomic, strong) UIImageView *imgHead;
/// 昵称
@property (nonatomic, strong) UILabel *lblNickname;
/// 电话
@property (nonatomic, strong) UILabel *lblPhone;
/// 退出
@property (nonatomic, strong) UIButton *btnExitUser;
//学习积分
@property (nonatomic, strong) UILabel *lblxxjf;
//企业积分
@property (nonatomic, strong) UILabel *lblqyjf;
@property (nonatomic, strong) UIView *viewJiFen;
@property (nonatomic, strong) UILabel *lblMyJf;
//查看积分规则
@property (nonatomic, strong) UIButton *btnJfgz;
@property (nonatomic, strong) UIView *viewZhuanYe;


@property (nonatomic,copy) void(^btnExitUserAction)(void);
@end

NS_ASSUME_NONNULL_END
