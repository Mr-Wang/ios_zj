//
//  WY_PerfectListTableViewCell.h
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFStepView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_PerfectListTableViewCell : UITableViewCell

/// 标题title
@property (nonatomic, strong) UILabel *titleLab;
 
/// 向右按钮
@property (nonatomic, strong) UIImageView *rImg;

@property (nonatomic , strong) UIView *lineView;/* 线 */
@property (nonatomic , strong) UIView *lineView2;/* 线 */


@property (nonatomic , strong) UIImageView *logoImg;/* logo */

@property (nonatomic, strong) UILabel *rightLab;
@property (nonatomic, strong) UILabel *jujueTitle;
@property (nonatomic, strong) UILabel *jujueContent;
@property (nonatomic, strong) XFStepView *stepView;
@property (nonatomic, strong) UIView *viewStepVertical;
@property (nonatomic, strong) UIControl *curZyView;
@property (nonatomic , strong) NSMutableArray *arrZyData;
@property (nonatomic,copy) void(^selDidMoreBlock)(void);
- (void)showZHCellByItem:(NSMutableDictionary *)withDic;

- (void)showCellByItem:(NSMutableDictionary *)withDic;
 
@property (nonatomic,copy) void(^syncExpertData)(void);
@end


NS_ASSUME_NONNULL_END
