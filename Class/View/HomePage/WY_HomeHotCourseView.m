//
//  WY_HomeHotCourseView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/8/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_HomeHotCourseView.h"
#import "WY_RecommendCourseTableViewCell.h"

@implementation WY_HomeHotCourseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    [self setBackgroundColor:[UIColor whiteColor]];
    self.btnLeft = [UIButton new];
    self.btnRight = [UIButton new];
    self.viewLeft = [UIView new];
    self.viewRight = [UIView new];
    self.lblSM = [UILabel new];
    self.btnMore = [UIButton new];
    
    
    [self addSubview:self.btnLeft];
    [self addSubview:self.btnRight];
    [self addSubview:self.viewLeft];
    [self addSubview:self.viewRight];
    [self addSubview:self.lblSM];
    [self addSubview:self.btnMore];
    
    [self.btnLeft setFrame:CGRectMake(k360Width(15), k360Width(15), k360Width(90), k360Width(30))];
    [self.btnRight setFrame:CGRectMake(self.btnLeft.right, k360Width(15), k360Width(90), k360Width(30))];
    [self.btnLeft setTitle:@"热门课程" forState:UIControlStateNormal];
    [self.btnRight setTitle:@"相关培训" forState:UIControlStateNormal];
    [self.btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
 
    
    [self.btnLeft.titleLabel setFont:WY_FONTMedium(22)];
    
    [self.btnRight.titleLabel setFont:WY_FONTMedium(16)];
    [self.lblSM setFrame:CGRectMake(self.btnLeft.left, self.btnLeft.bottom + k360Width(15), kScreenWidth - k360Width(30), k360Width(22))];
    
    self.lblSM.text = @"近千门专题课程，助你吃透各个知识点";
    [self.lblSM setFont:WY_FONTMedium(14)];
    [self.lblSM setTextColor:HEXCOLOR(0xB3B3B3)];
    
    [self.viewLeft setFrame:CGRectMake(0, self.lblSM.bottom + k360Width(5), kScreenWidth, k360Width(44))];
    
    [self.viewRight setFrame:CGRectMake(0, self.lblSM.bottom + k360Width(5), kScreenWidth, k360Width(44))];
 
    [self.btnMore setFrame:CGRectMake(0, self.viewLeft.bottom, kScreenWidth, k360Width(44))];
    [self.btnMore.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnMore setTitle:@"查看更多" forState:UIControlStateNormal];
    [self.btnMore setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [self.btnMore setBackgroundColor:[UIColor whiteColor]]; 
    
    
    [self.btnLeft addTarget:self action:@selector(btnLeftAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRight addTarget:self action:@selector(btnRightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnMore addTarget:self action:@selector(btnMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnLeft setSelected:YES];
    [self.viewRight setHidden:YES];
}

- (void)showBindView:(WY_IndexModel *)withModel
{
    self.mWY_IndexModel = withModel;
    [self.viewLeft removeAllSubviews];
    [self.viewRight removeAllSubviews];
    
    
     int lastY = k360Width(16);
    for (int i = 0 ; i < self.mWY_IndexModel.bestTraCourseList.count ; i ++) {
        WY_TrainItemModel *ydzqModel = self.mWY_IndexModel.bestTraCourseList[i];
            WY_RecommendCourseTableViewCell *readItemView = [[WY_RecommendCourseTableViewCell alloc] initWithFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(200))];
            [readItemView showZJHomeCellByItem:ydzqModel];
            readItemView.colSender.tag = i;
            [readItemView.colSender addTarget:self action:@selector(recommendCourseItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.viewLeft addSubview:readItemView];
            lastY = readItemView.bottom + k360Width(10);
        }
        self.viewLeft.height = lastY;

    int lastRRY = k360Width(16);
    for (int i = 0 ; i < self.mWY_IndexModel.onLineTraCourseList.count ; i ++) {
        WY_TrainItemModel *ydzqModel = self.mWY_IndexModel.onLineTraCourseList[i];
            WY_RecommendCourseTableViewCell *readItemView = [[WY_RecommendCourseTableViewCell alloc] initWithFrame:CGRectMake(0, lastRRY, kScreenWidth, k360Width(200))];
            [readItemView showZJHomeCellByItem:ydzqModel];
            readItemView.colSender.tag = i;
            [readItemView.colSender addTarget:self action:@selector(oLTCourseItemAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.viewRight addSubview:readItemView];
            lastRRY = readItemView.bottom + k360Width(10);
        }
        self.viewRight.height = lastRRY;
    
    if (self.btnLeft.selected) {
        self.btnMore.top = self.viewLeft.bottom;
    } else {
        self.btnMore.top = self.viewRight.bottom;
    }
    
    self.height = self.btnMore.bottom;
    
    
}


- (void)btnUpdateState:(BOOL)isLeftSel {
    self.btnLeft.selected = isLeftSel;
    self.btnRight.selected = !isLeftSel;
    if (isLeftSel) {
        [self.btnLeft.titleLabel setFont:WY_FONTMedium(22)];
        [self.btnRight.titleLabel setFont:WY_FONTMedium(16)];
        
    } else {
        [self.btnLeft.titleLabel setFont:WY_FONTMedium(16)];
        [self.btnRight.titleLabel setFont:WY_FONTMedium(22)];
    }
    [self.viewLeft setHidden:!isLeftSel];
    [self.viewRight setHidden:isLeftSel];
    
    if (self.btnLeft.selected) {
        self.btnMore.top = self.viewLeft.bottom;
    } else {
        self.btnMore.top = self.viewRight.bottom;
    }
    
    self.height = self.btnMore.bottom;
}

/// 点击了左按钮
- (void)btnLeftAction {
    BOOL isLeftSel = YES;
    [self btnUpdateState:isLeftSel];
    if (self.didUpdateHeightBlock) {
        self.didUpdateHeightBlock();
    }
}

/// 点击了右按钮
- (void)btnRightAction {
    BOOL isLeftSel = NO;
    [self btnUpdateState:isLeftSel];
    
    if (self.didUpdateHeightBlock) {
        self.didUpdateHeightBlock();
    }
}

/// 点击了更多按钮
- (void)btnMoreAction {
    if (self.didMoreBlock) {
        self.didMoreBlock();
    }
}


#pragma mark --热门课程Item点击
- (void)recommendCourseItemAction:(UIControl *)colSender {
    WY_TrainItemModel *ydzqModel = self.mWY_IndexModel.bestTraCourseList[colSender.tag];
     NSLog(@"点击了：%@",ydzqModel.Title);
//    [self gotoTrainDetailsPage:ydzqModel];
    
    if (self.didItemBlock) {
        self.didItemBlock(ydzqModel);
    }
    
}
- (void)oLTCourseItemAction:(UIControl *)colSender {
    WY_TrainItemModel *ydzqModel = self.mWY_IndexModel.onLineTraCourseList[colSender.tag];
     NSLog(@"点击了：%@",ydzqModel.Title);
//    [self gotoTrainDetailsPage:ydzqModel];
    if (self.didItemBlock) {
        self.didItemBlock(ydzqModel);
    }
}

@end
