//
//  WY_ConsultingTableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/25.
//  Copyright © 2021 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_MessageModel.h"
#import "WY_AExpertQuestionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WY_ConsultingTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblZJName;
@property (nonatomic, strong) UILabel *lblDate;

@property (nonatomic, strong) UIImageView* imgLine;
@property (nonatomic, strong) UIImageView*imgYhf;
@property (nonatomic ,strong) UIImageView *imgHead;


@property (nonatomic, strong) WY_MessageModel *mWY_MessageModel;

@property (nonatomic, strong)NSMutableArray *zhuanYeArr;
@property (nonatomic, strong) UIView *viewZhuanYe;

- (void)showCellByItem:(WY_MessageModel *)withModel;
- (void)showCellDocByItem:(WY_AExpertQuestionModel *)withModel;
@end

NS_ASSUME_NONNULL_END
