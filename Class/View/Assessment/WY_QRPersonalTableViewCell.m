//
//  WY_QRPersonalTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/26.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_QRPersonalTableViewCell.h"

@implementation WY_QRPersonalTableViewCell
{
    UIImageView *imgLine;
    UIImageView *imgAcc;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self makeUI];
        [self.colSender setUserInteractionEnabled:NO];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        self.userInteractionEnabled = YES;
        [self makeUI];
        [self.colSender setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)makeUI {
    //67
    
    self.colSender = [[UIControl alloc] init];
    self.imgContent = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(34),  k360Width(26), k360Width(24))];
     [self.contentView addSubview:_imgContent];
    self.lblNum = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(34),  k360Width(26), k360Width(24))];
    [self.lblNum setFont: WY_FONTMedium(16)];
    [self.lblNum setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_lblNum];
    [self.lblNum setHidden:YES];
    self.lblksmc = [UILabel new];
    [self.lblksmc setHidden:YES];
    [self.contentView addSubview:self.lblksmc];
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.imgContent.right + k360Width(16), k360Width(16), kScreenWidth - k360Width(56), k360Width(22))];
    [self.lblTitle setFont: WY_FONTMedium(16)];
    [self.contentView addSubview:self.lblTitle];
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(self.lblTitle.left, self.lblTitle.bottom + k360Width(8), self.lblTitle.width, k360Width(22))];
    [self.lblDate setFont: WY_FONTRegular(14)];
    [self.lblDate setTextColor:HEXCOLOR(0x909090)];
    [self.contentView addSubview:self.lblDate];
    
    self.lblRight = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(216), self.lblTitle.bottom + k360Width(8), k360Width(200), k360Width(22))];
    [self.lblRight setFont: WY_FONTRegular(14)];
    [self.lblRight setTextAlignment:NSTextAlignmentRight];
    [self.lblRight setTextColor:HEXCOLOR(0x909090)];
    [self.contentView addSubview:self.lblRight];

    [self.contentView addSubview: self.colSender];
    
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(self.lblTitle.left,self.lblDate.bottom + k360Width(13),kScreenWidth - self.lblTitle.left - k360Width(16), 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [self.contentView addSubview:imgLine];
    
    imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
    [imgAcc setImage:[UIImage imageNamed:@"accup"]];
    [self.contentView addSubview:imgAcc];
    [imgAcc setHidden:YES];

}
- (void)showRankCellByItem:(WY_RankModel*)withWY_RankModel ByNum:(NSInteger) withNum {
   self.mWY_RankModel = withWY_RankModel;
   self.lblTitle.text = self.mWY_RankModel.username ;
   [self.imgContent setHidden:NO];
   [self.lblNum setHidden:YES];
   switch (withNum) {
       case 0:
           {
               [self.imgContent setImage:[UIImage imageNamed:@"0226_diyi"]];

           }
           break;
           case 1:
                 {
                     [self.imgContent setImage:[UIImage imageNamed:@"0226_dier"]];

                 }
                 break;
               case 2:
                     {
                         [self.imgContent setImage:[UIImage imageNamed:@"0226_disan"]];

                     }
                     break;
                   
       default:
       {
           [self.imgContent setHidden:YES];
           [self.lblNum setHidden:NO];
           self.lblNum.text = [NSString stringWithFormat:@"%zd",withNum + 1];
           
       }
           break;
   }
    self.lblDate.text = [NSString stringWithFormat:@"考试次数：%@次",self.mWY_RankModel.count];

    self.lblRight.text = [NSString stringWithFormat:@"最好成绩：%.1f分",[self.mWY_RankModel.bestscore floatValue]];

   
   self.height = imgLine.bottom;
   [self.colSender setFrame:self.bounds];
}




- (void)showCellByItem:(WY_PersonalScoreModel*)withWY_PersonalScoreModel ByNum:(NSInteger) withNum {
    self.mWY_PersonalScoreModel = withWY_PersonalScoreModel;
    self.lblTitle.text = [NSString stringWithFormat:@"%.1f分",[ self.mWY_PersonalScoreModel.score floatValue]] ;
    [self.imgContent setHidden:NO];
    [self.lblNum setHidden:YES];
    switch (withNum) {
        case 0:
            {
                [self.imgContent setImage:[UIImage imageNamed:@"0226_diyi"]];

            }
            break;
            case 1:
                  {
                      [self.imgContent setImage:[UIImage imageNamed:@"0226_dier"]];

                  }
                  break;
                case 2:
                      {
                          [self.imgContent setImage:[UIImage imageNamed:@"0226_disan"]];

                      }
                      break;
                    
        default:
        {
            [self.imgContent setHidden:YES];
            [self.lblNum setHidden:NO];
            self.lblNum.text = [NSString stringWithFormat:@"%zd",withNum + 1];
            
        }
            break;
    }
     self.lblDate.text = [NSString stringWithFormat:@"用时：%@",self.mWY_PersonalScoreModel.examTime];
 
    if (self.mWY_PersonalScoreModel.answertime.length > 10) {
            self.lblRight.text = [NSString stringWithFormat:@"测试时间：%@",[self.mWY_PersonalScoreModel.answertime  substringToIndex:10]];
    } else {
        self.lblRight.text = [NSString stringWithFormat:@"测试时间：%@",self.mWY_PersonalScoreModel.answertime] ;
    }
    
    self.height = imgLine.bottom;
    [self.colSender setFrame:self.bounds];
 }

- (void)showCellType2ByItem:(WY_PersonalScoreModel*)withWY_PersonalScoreModel ByNum:(NSInteger) withNum {
   self.mWY_PersonalScoreModel = withWY_PersonalScoreModel;
    
    [self.lblksmc setHidden:NO];
    [self.lblksmc setFrame:CGRectMake(self.lblTitle.left, k360Width(16), kScreenWidth - self.lblTitle.left - k360Width(16), 0)];
    [self.lblksmc setFont:WY_FONTRegular(14)];
    [self.lblksmc setTextColor:APPTextGayColor];
//    self.lblksmc.text = withWY_PersonalScoreModel.khmcStr;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:withWY_PersonalScoreModel.khmcStr];
    
    if ([withWY_PersonalScoreModel.nsDescription isNotBlank]) {
         NSMutableAttributedString *tishi =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@",withWY_PersonalScoreModel.nsDescription]];
        [tishi setYy_font:WY_FONTMedium(14)];
        [tishi yy_setObliqueness:@0.3 range:NSMakeRange(0, withWY_PersonalScoreModel.nsDescription.length)];
        
        [tishi setYy_color:HEXCOLOR(0xFA6400)];
        [attStr appendAttributedString:tishi];

    }
    
   
    [self.lblksmc setAttributedText:attStr];
    
    [self.lblksmc setNumberOfLines:0];
    [self.lblksmc setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblksmc sizeToFit];
    
    self.lblTitle.top = self.lblksmc.bottom + k360Width(8);
    self.lblDate.top = self.lblTitle.bottom + k360Width(8);
    self.lblRight.top = self.lblTitle.bottom + k360Width(8);
    imgLine.top = self.lblDate.bottom + k360Width(13);
    
    if ([withWY_PersonalScoreModel.isface isEqualToString:@"0"]) {
        NSMutableAttributedString *attStrFenshu = [[NSMutableAttributedString alloc] initWithString:@"分数无效"];

        NSMutableAttributedString *attStrA = [[NSMutableAttributedString alloc] initWithString:@"  人脸比对失败"];
        [attStrA setYy_color:[UIColor redColor]];
        [attStrA setYy_font:WY_FONT375Regular(12)];
        
        [attStrFenshu appendAttributedString:attStrA];
        self.lblTitle.attributedText = attStrFenshu;
    } else {
        self.lblTitle.text = [NSString stringWithFormat:@"%.1f分",[ self.mWY_PersonalScoreModel.score floatValue]];
    }
    
   
    
   [self.imgContent setHidden:NO];
   [self.lblNum setHidden:YES];
   switch (withNum) {
       case 0:
           {
               [self.imgContent setImage:[UIImage imageNamed:@"0226_diyi"]];

           }
           break;
           case 1:
                 {
                     [self.imgContent setImage:[UIImage imageNamed:@"0226_dier"]];

                 }
                 break;
               case 2:
                     {
                         [self.imgContent setImage:[UIImage imageNamed:@"0226_disan"]];

                     }
                     break;
                   
       default:
       {
           [self.imgContent setHidden:YES];
           [self.lblNum setHidden:NO];
           self.lblNum.text = [NSString stringWithFormat:@"%zd",withNum + 1];
           
       }
           break;
   }
    self.lblDate.text = [NSString stringWithFormat:@"用时：%@",self.mWY_PersonalScoreModel.examTime];

   if (self.mWY_PersonalScoreModel.answertime.length > 10) {
           self.lblRight.text = [NSString stringWithFormat:@"测试时间：%@",[self.mWY_PersonalScoreModel.answertime  substringToIndex:10]];
   } else {
       self.lblRight.text = [NSString stringWithFormat:@"测试时间：%@",self.mWY_PersonalScoreModel.answertime] ;
   }
   
    self.lblNum.top = 0;
    self.lblNum.height = imgLine.bottom;
   self.height = imgLine.bottom;
    imgAcc.centerY = self.centerY;
    [imgAcc setHidden:NO];
   [self.colSender setFrame:self.bounds];
}
@end
