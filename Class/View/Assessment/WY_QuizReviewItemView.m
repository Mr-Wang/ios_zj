//
//  WY_QuizReviewItemView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/27.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QuizReviewItemView.h"

@implementation WY_QuizReviewItemView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        self.userInteractionEnabled = YES;
        [self makeUI];
    }
    return self;
}

- (void)makeUI {
    [self setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self viewShadowCorner:self];
    
    self.lblTypeStr = [UILabel new];
    [self.lblTypeStr setFont:WY_FONTMedium(16)];
    [self.lblTypeStr setTextColor:[UIColor blackColor]];
    [self addSubview:self.lblTypeStr];
    [self.lblTypeStr setFrame:CGRectMake(k360Width(16), 0, k360Width(200), k360Width(44))];
    self.imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - k360Width(22 + 10), k360Width(44-22) / 2, k360Width(22), k360Width(22))];
    [self.imgAcc setImage:[UIImage imageNamed:@"accdown"]];
    [self addSubview:self.imgAcc];
    self.colTitle = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.width, k360Width(44))];
    [self addSubview:self.colTitle];
    
    self.viewContent = [UIView new];
    [self.viewContent setFrame:CGRectMake(0, k360Width(44), self.width, k360Width(44))];
    [self addSubview:self.viewContent];
    
}
- (void)showCellByItem:(WY_QuestionTypeModel *)withModel
{
    self.mWY_QuestionTypeModel = withModel;
     
    switch ([self.mWY_QuestionTypeModel.type intValue]) {
        case 1:
        {
            self.lblTypeStr.text = @"单选题";
        }
            break;
        case 2:
        {
            self.lblTypeStr.text = @"多选题";
        }
            break;
        case 3:
        {
            self.lblTypeStr.text = @"判断题";
        }
            break;
        case 4:
        {
            self.lblTypeStr.text = @"简答题";
            
        }
            break;
        case 5 :
        {
            self.lblTypeStr.text = @"案例分析题";
        }
            break;
        case 6 :
        {
            self.lblTypeStr.text = @"填空题";
        }
            break;
        default:
            break;
    }
    
    [self.viewContent removeAllSubviews];
    
    float Start_X  = k360Width(16);           // 第一个按钮的X坐标
    float Start_Y = 0;       // 第一个按钮的Y坐标
    float  Width_Space = k360Width(13);     // 2个按钮之间的横间距
    float  Height_Space = k360Width(13);// 竖间距
    float  Button_Height = k360Width(34);// 高
    float  Button_Width = k360Width(38);// 宽
    int lastY = 0;
    for (int i =0; i < self.mWY_QuestionTypeModel.tQuestionList.count; i ++) {
        NSInteger index = i % 6;
        NSInteger page = i / 6;
        // 圆角按钮
        UIButton *aBt = [[UIButton alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
        WY_QuestionModel *qModel = self.mWY_QuestionTypeModel.tQuestionList[i];
        [aBt setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [aBt.titleLabel setFont:WY_FONTMedium(14)];
        [aBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        /**
         * 题目是否正确
         * 1错
         * 0对
         * 2针对于多选题的，漏选情况
         */
        if ([qModel.answerIsRight isEqualToString:@"0"]) {
            [aBt setBackgroundImage:[UIImage imageNamed:@"0226_lvxing"] forState:UIControlStateNormal];
        } else if ([qModel.answerIsRight isEqualToString:@"1"]) {
            [aBt setBackgroundImage:[UIImage imageNamed:@"0226_hongxing"] forState:UIControlStateNormal];
        } else {
            [aBt setBackgroundImage:[UIImage imageNamed:@"0226_lanxing"] forState:UIControlStateNormal];
        }
        [aBt addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (self.selTopicModelBlock) {
                self.selTopicModelBlock(qModel);
            }
        }];
         [self.viewContent addSubview:aBt];
        lastY = aBt.bottom + k360Width(20);
    }
    self.viewContent.height = lastY;
    self.height = self.viewContent.bottom;
            
}
///给View设置阴影和圆角
- (void)viewShadowCorner:(UIView *)viewInfoTemp {
    viewInfoTemp.layer.shadowColor = HEXCOLOR(0xdddddd).CGColor;
    viewInfoTemp.layer.shadowOffset = CGSizeMake(5, 5);
    viewInfoTemp.layer.shadowOpacity = 1;
    viewInfoTemp.layer.shadowRadius = 9.0;
    viewInfoTemp.layer.cornerRadius = k360Width(44) / 8;
    [viewInfoTemp setBackgroundColor:[UIColor whiteColor]];
    viewInfoTemp.clipsToBounds = NO;
}

@end
