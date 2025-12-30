//
//  WY_MyOtherTableViewCell.h
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_MyOtherTableViewCell : UITableViewCell

/// 标题title
@property (nonatomic, strong) UILabel *titleLab;
 
/// 向右按钮
@property (nonatomic, strong) UIImageView *rImg;

@property (nonatomic , strong) UIView *lineView;/* 线 */


@property (nonatomic , strong) UIImageView *logoImg;/* logo */

@property (nonatomic, strong) UILabel *rightLab;
@end


NS_ASSUME_NONNULL_END
