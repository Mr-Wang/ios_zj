//
//  WY_SelTopicViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SelTopicViewController.h"

@interface WY_SelTopicViewController ()
{
    UIButton *btnQbst;
    UIImageView *imgTop;
    float lastY;
}
@end

@implementation WY_SelTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self bindView];
}

- (void)makeUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imgTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, k360Width(55))];
    [imgTop setImage:[UIImage imageNamed:@"0226_yinying"]];
    [self.view addSubview:imgTop];
    btnQbst = [UIButton new];
    [btnQbst setFrame:CGRectMake(kScreenWidth - k360Width(16 + 80), k360Width(0), k360Width(80), k360Width(44))];
     [btnQbst setImage:[UIImage imageNamed:@"0225_qbst"] forState:UIControlStateNormal];
    [btnQbst.titleLabel setFont:WY_FONTRegular(12)];
    [btnQbst setTitleColor:APPTextGayColor forState:UIControlStateNormal];
    [btnQbst setTitleEdgeInsets:UIEdgeInsetsMake(0, k360Width(15), 0, 0)];
    [self.view addSubview:btnQbst];
    
}
- (void)bindView {
    [btnQbst setTitle:[NSString stringWithFormat:@"%zd/%zd",self.currentSelIndex + 1,self.mWY_QuizModel.tQuestionList.count] forState:UIControlStateNormal];
    
    float Start_X  = k360Width(13);           // 第一个按钮的X坐标
    float Start_Y = imgTop.bottom + k360Width(13);       // 第一个按钮的Y坐标
    float  Width_Space = k360Width(13);     // 2个按钮之间的横间距
    float  Height_Space = k360Width(13);// 竖间距
    float  Button_Height = k360Width(44);// 高
    float  Button_Width = k360Width(44);// 宽
    lastY = 0;
    for (int i =0; i < self.mWY_QuizModel.tQuestionList.count; i ++) {
        NSInteger index = i % 6;
        NSInteger page = i / 6;
        // 圆角按钮
        UIButton *aBt = [[UIButton alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
        WY_QuestionModel *qModel = self.mWY_QuizModel.tQuestionList[i];
        [aBt setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [aBt.titleLabel setFont:WY_FONTMedium(14)];
        if (qModel.select) {
            [aBt setBackgroundColor:HEXCOLOR(0xCDF3C4)];
            [aBt rounded:Button_Height/2 width:0 color:APPTextGayColor];
            [aBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            [aBt setTitleColor:APPTextGayColor forState:UIControlStateNormal];
            [aBt setBackgroundColor:[UIColor whiteColor]];
            [aBt rounded:Button_Height/2 width:1 color:APPTextGayColor];
        }
        [aBt addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (self.selTopicBlock) {
                self.selTopicBlock(i);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
         [self.view addSubview:aBt];
        lastY = aBt.bottom + k360Width(20);
    }
 
 
}
#pragma mark - HWPanModalPresentable
- (PanModalHeight)longFormHeight {
    return PanModalHeightMake(PanModalHeightTypeContent, lastY);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
