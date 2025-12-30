//
//  WY_HomeArticleView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/8/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_HomeArticleView.h"
#import "WY_RecommendCourseTableViewCell.h"
#import "WY_HomeArticleItemView.h"
#import "WY_WLTools.h"

@implementation WY_HomeArticleView

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
     self.btnMore = [UIButton new];
    self.viewItems = [UIView new];
    [self addSubview:self.viewItems];
      [self addSubview:self.btnMore];
    
    [self.viewItems setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(320))];
 
    [self.btnMore setFrame:CGRectMake(0, self.viewItems.bottom, kScreenWidth, k360Width(44))];
    [self.btnMore.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnMore setTitle:@"查看更多" forState:UIControlStateNormal];
    [self.btnMore setTitleColor:MSTHEMEColor forState:UIControlStateNormal];
    [self.btnMore setBackgroundColor:[UIColor whiteColor]];
     [self.btnMore addTarget:self action:@selector(btnMoreAction) forControlEvents:UIControlEventTouchUpInside];

 }

- (void)showBindView:(WY_IndexModel *)withModel
{
    self.mWY_IndexModel = withModel;
    [self.viewItems removeAllSubviews];
   
       float Start_X  = k360Width(14);           // 第一个按钮的X坐标
       float Start_Y = k360Width(10);       // 第一个按钮的Y坐标
       float  Width_Space =  k360Width(10);     // 2个按钮之间的横间距
       float  Height_Space = k360Width(14);// 竖间距
       float  Button_Height = k375Width(140);// 高
       float  Button_Width = (kScreenWidth - k360Width(14 * 2) - k360Width(10)) / 2; //k360Width(44);// 宽
       
       for (int i =0; i < self.mWY_IndexModel.lawsList.count; i ++) {
           NSInteger index = i % 2;
           NSInteger page = i / 2;
           // 圆角按钮
           WY_HomeArticleItemView *aBt = [[WY_HomeArticleItemView alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
           //               [aBt setBackgroundColor:[UIColor redColor]];
           WY_InfomationModel *dic = self.mWY_IndexModel.lawsList[i];
//           [aBt bindViewWith:dic[@"img"] titleStr:dic[@"title"]];
           [aBt showCellByItem:dic];
           aBt.tag = i;
           [aBt.imgBg setImage:[UIImage imageNamed:[WY_WLTools categorySyImgStringByNum:dic.categorynum]]]; 
            
           [aBt addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
           [self.viewItems addSubview:aBt];
           
           self.viewItems.height = aBt.bottom + k360Width(5);
       }
    self.btnMore.top = self.viewItems.bottom;
    self.height = self.btnMore.bottom;
     
}

/// 点击了更多按钮
- (void)btnMoreAction {
    if (self.didMoreBlock) {
        self.didMoreBlock();
    }
}


#pragma mark --热门课程Item点击
- (void)itemBtnAction:(UIControl *)colSender {
    WY_InfomationModel *ydzqModel = self.mWY_IndexModel.lawsList[colSender.tag];
     NSLog(@"点击了：%@",ydzqModel.title);
    if (self.didItemBlock) {
        self.didItemBlock(ydzqModel);
    }
    
}

@end
