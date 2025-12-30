//
//  WY_MyInfoTableViewCell.m
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_MyInfoTableViewCell.h"

@implementation WY_MyInfoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self makeUI];
        
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
     }
     return self;
 }
- (void)makeUI {
    self.cellBackgroudImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , kScreenWidth, self.height - k360Width(28))];
    [self.cellBackgroudImage setBackgroundColor:MSTHEMEColor];
    [self.contentView addSubview:self.cellBackgroudImage];
    self.viewZhuanYe = [UIView new];
    [self.contentView addSubview:self.viewZhuanYe];
    self.imgHead = [[UIImageView alloc] init];
    self.lblNickname = [[UILabel alloc] init];
    self.lblPhone = [[UILabel alloc] init];
//    self.btnExitUser = [[UIButton alloc] init];
    [self.contentView addSubview:self.imgHead];
      [self.contentView addSubview:self.lblNickname];
        [self.contentView addSubview:self.lblPhone];
//          [self.contentView addSubview:self.btnExitUser];
    
    [self.imgHead setFrame:CGRectMake(k360Width(32), JCNew64 + MH_APPLICATION_STATUS_BAR_HEIGHT + k360Width(10), k360Width(52), k360Width(52))];
    
    [self.lblNickname setFrame:CGRectMake(self.imgHead.right + k360Width(16), self.imgHead.top, kScreenWidth - (self.imgHead.right + k360Width(16)), k360Width(25))];
    [self.lblNickname setFont:WY_FONTRegular(18)];
    [self.lblNickname setTextColor:[UIColor whiteColor]];
    
    [self.lblPhone setFrame:CGRectMake(self.imgHead.right + k360Width(16), self.lblNickname.bottom + k360Width(1), k360Width(250), k360Width(25))];
    [self.lblPhone setFont:WY_FONTRegular(14)];
    [self.lblPhone setTextColor:[UIColor whiteColor]];
//    [self.btnExitUser setFrame:CGRectMake(self.lblPhone.right + k360Width(16), self.lblPhone.top, k360Width(44), k360Width(25))];
//    [self.btnExitUser.titleLabel setFont:[UIFont systemFontOfSize:14]];
//    [self.btnExitUser setTitle:@"退出" forState:UIControlStateNormal];
//    [self.btnExitUser addTarget:self action:@selector(btnExitUserTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    self.lblxxjf = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imgHead.bottom, kScreenWidth/ 2, k360Width(50))];
    self.lblqyjf = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/ 2, self.imgHead.bottom, kScreenWidth/ 2, k360Width(50))];
    
    [self.lblxxjf setTextColor:[UIColor whiteColor]];
    [self.lblxxjf setFont:WY_FONTRegular(14)];
    
    [self.lblqyjf setTextColor:[UIColor whiteColor]];
    [self.lblqyjf setFont:WY_FONTRegular(14)];
    
    [self.contentView addSubview:self.lblxxjf];
    [self.contentView addSubview:self.lblqyjf];
    
    [self.lblxxjf setNumberOfLines:2];
    [self.lblqyjf setNumberOfLines:2];
    
    [self.lblxxjf setTextAlignment:NSTextAlignmentCenter];
    [self.lblqyjf setTextAlignment:NSTextAlignmentCenter];
    self.cellBackgroudImage.height = self.lblqyjf.bottom + k360Width(30);
    
    //隐藏掉企业积分位置
//    self.cellBottomColor = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.cellBackgroudImage.bottom , kScreenWidth, k360Width(32))];
    
    self.cellBottomColor = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.lblPhone.bottom + k360Width(50) , kScreenWidth, k360Width(32))];
    [self.contentView addSubview:self.cellBottomColor];
    [self.cellBottomColor setBackgroundColor:[UIColor whiteColor]];
    
    self.viewJiFen = [[UIView alloc] initWithFrame:CGRectMake(k360Width(20), self.cellBottomColor.top - k360Width(28 - 6) , kScreenWidth - k360Width(40), k360Width(44))];
//    [self.viewJiFen rounded:k360Width(44 / 4)];
    [self.viewJiFen setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.viewJiFen];
    [self viewShadowCorner:self.viewJiFen];

    UILabel *lblwd = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(95), self.viewJiFen.height)];
    [self.viewJiFen addSubview:lblwd];
    [lblwd setText:@"考核评价结果"];
    [lblwd setFont:WY_FONTMedium(14)];
    
    self.lblMyJf = [[UILabel alloc] initWithFrame:CGRectMake(lblwd.right, 0, k360Width(100), self.viewJiFen.height)];
    [self.lblMyJf setFont:WY_FONTMedium(18)];
    [self.lblMyJf setTextColor:[UIColor redColor]];
    [self.viewJiFen addSubview:self.lblMyJf];
    
    self.btnJfgz = [[UIButton alloc] initWithFrame:CGRectMake(self.viewJiFen.width - k360Width(16 + 100), 0, k360Width(100), self.viewJiFen.height)];
    [self.btnJfgz setTitle:@"考核评价细则" forState:UIControlStateNormal];
    [self.btnJfgz.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnJfgz setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnJfgz setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.viewJiFen addSubview:self.btnJfgz];

    //    self.height = self.cellBottomColor.bottom;
//    [self.viewJiFen setHidden:YES];
//    [self.cellBottomColor setHidden:YES];
    //隐藏掉企业积分位置
    [self.lblxxjf setHidden:YES];
    [self.lblqyjf setHidden:YES];
    
//    self.cellBackgroudImage.height = self.lblPhone.bottom + k360Width(30);
//
//    self.height = self.cellBackgroudImage.height;
    
    self.height = self.cellBottomColor.bottom;

 }

- (void)btnExitUserTouchUpInside {
    if (self.btnExitUserAction) {
        self.btnExitUserAction();
    }
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
