//
//  WY_SelMajorView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SelMajorView.h"
#import "WY_selPicView.h"
#import "WY_ProfessionModel.h"

@implementation WY_SelMajorView
{
    
    UIButton *btnLeft;
    UIButton *btnRight;
    UIButton *btnRightA;
    UIImageView *imgLine;
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

- (void)updateMakeFrame {
    [self.colSelType setFrame:CGRectMake(0, self.lblTs1.bottom, kScreenWidth, k375Width(66))];
    
    [self.lblType setFrame:CGRectMake(k375Width(12), 0, kScreenWidth - k375Width(74), self.colSelType.height)];
    
    [self.imgAcc setFrame:CGRectMake(self.lblType.right + k375Width(12), 0, k360Width(22), k360Width(22))];
    self.imgAcc.centerY = self.lblType.centerY;
    //mainProfession 主评专业只可修改一次- 默认都是0 ，修改后变成1
    if ((self.rowIndex == self.mWY_MajorPhotoModel.newZPIndex || self.rowIndex == self.mWY_MajorPhotoModel.oldZPIndex) && self.mWY_MajorPhotoModel.mainProfession != 1) {
        [self.lblIsZp setHidden:NO];
        
         
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            NSLog(@"点击了lblIsZp");
            if ([self lblIsZpBlock]) {
                self.lblIsZpBlock(self);
            }
        }];
        [self.lblIsZp setUserInteractionEnabled:YES];
        [self.lblIsZp addGestureRecognizer:tapGest];

        [self.lblIsZp setFrame:CGRectMake(k375Width(12), self.colSelType.bottom , kScreenWidth - k360Width(24), k375Width(30))];
        
        [self.lblTs2 setFrame:CGRectMake(k375Width(12), self.lblIsZp.bottom +   k360Width(8), kScreenWidth, k375Width(44))];
        
    } else {
        [self.lblIsZp setHidden:YES];
        [self.lblTs2 setFrame:CGRectMake(k375Width(12), self.colSelType.bottom +   k360Width(8), kScreenWidth - k360Width(24), k375Width(44))];

    }
           
    [self.scrollViewZczs setFrame:CGRectMake(0, self.lblTs2.bottom, kScreenWidth, k375Width(120))];
    
    [self.lblTs3 setFrame:CGRectMake(k375Width(12), self.scrollViewZczs.bottom, kScreenWidth - k375Width(24), k375Width(54))];
    
    [self.scrollViewZgzs setFrame:CGRectMake(0, self.lblTs3.bottom, kScreenWidth, k375Width(120))];
    
    [imgLine setFrame:CGRectMake(0, self.scrollViewZgzs.bottom + k360Width(10), kScreenWidth, 1)];
    self.height = imgLine.bottom + 1;
}

- (void)makeUI {
    self.lblTs1 = [UILabel new];
    self.lblTs2 = [UILabel new];
    self.lblIsZp = [UILabel new];
    self.lblTs3 = [UILabel new];
    self.colSelType = [UIControl new];
    self.scrollViewZczs = [UIScrollView new];
    self.scrollViewZgzs = [UIScrollView new];
    self.btnDelMajor = [UIButton new];
    [self.btnDelMajor setHidden:YES];
    [self addSubview:self.lblTs1];
    [self addSubview:self.lblTs2];
    [self addSubview:self.lblIsZp];
    [self addSubview:self.lblTs3];
    [self addSubview:self.colSelType];
    [self addSubview:self.scrollViewZczs];
    [self addSubview:self.scrollViewZgzs];
    [self addSubview:self.btnDelMajor];
    
    [self.colSelType setHidden:YES];
    
    self.lblType = [UILabel new];
    self.imgAcc = [UIImageView new];
    
    
    
    
    
    [self.colSelType addSubview:self.lblType];
    [self.colSelType addSubview:self.imgAcc];
    
    self.lblType.text = @"请选择专业";
    [self.imgAcc setImage:[UIImage imageNamed:@"accup"]];
    
    [self.btnDelMajor setFrame:CGRectMake(kScreenWidth - k375Width(80), k375Width(10), k375Width(60), k375Width(35))];
    [self.btnDelMajor rounded:k375Width(44/8)];
    [self.btnDelMajor setTitle:@"删除" forState:UIControlStateNormal];
    [self.btnDelMajor setBackgroundColor:MSTHEMEColor];
    
    [self.lblTs1 setFrame:CGRectMake(k375Width(12), k360Width(5), kScreenWidth, k375Width(60))];
    [self.lblTs1 setNumberOfLines:2];
    
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(8), self.lblTs1.bottom + k360Width(10), (kScreenWidth - k360Width(8*4))/ 3,k360Width(31))];
          [btnLeft rounded:k360Width(31) / 8 width:1 color:HEXCOLOR(0xBFBFBF)];
          [btnLeft setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)
           ];
          [btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          btnLeft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
       [btnLeft setTitle:@"请选择一级专业" forState:UIControlStateNormal];
    [btnLeft.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    UIImageView *imgsjx1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1016_三角形"]];
    [imgsjx1 setFrame:CGRectMake(btnLeft.width - k360Width(20), k360Width(12), k360Width(12), k360Width(7))];
    imgsjx1.tag = 103;
          [btnLeft addSubview:imgsjx1];
          [btnLeft addTarget:self action:@selector(btnLeftAction:) forControlEvents:UIControlEventTouchUpInside];
          [btnLeft.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size:k360Width(12)]];

          btnRight = [[UIButton alloc] initWithFrame:CGRectMake(btnLeft.right + k360Width(8), self.lblTs1.bottom + k360Width(10), (kScreenWidth - k360Width(8*4))/ 3,k360Width(31))];
    [btnRight.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
          [btnRight rounded:k360Width(31) / 8 width:1 color:HEXCOLOR(0xBFBFBF)];
          [btnRight setTitle:@"请选择二级专业" forState:UIControlStateNormal];
          [btnRight setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)
           ];
          [btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
          [btnRight addTarget:self action:@selector(btnRightAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgsjx2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1016_三角形"]];
    imgsjx2.tag = 103;
    [imgsjx2 setFrame:CGRectMake(btnRight.width - k360Width(20), k360Width(12), k360Width(12), k360Width(7))];
    [btnRight.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size:k360Width(12)]];

    [btnRight addSubview:imgsjx2];

    btnRightA = [[UIButton alloc] initWithFrame:CGRectMake(btnRight.right + k360Width(8), self.lblTs1.bottom + k360Width(10), (kScreenWidth - k360Width(8*4))/ 3,k360Width(31))];
    [btnRightA.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [btnRightA rounded:k360Width(31) / 8 width:1 color:HEXCOLOR(0xBFBFBF)];
    [btnRightA setTitle:@"请选择三级专业" forState:UIControlStateNormal];
    [btnRightA.titleLabel setFont:[UIFont fontWithName:@"Source Han Sans SC" size:k360Width(12)]];
    [btnRightA setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)
     ];
    [btnRightA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnRightA.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnRightA addTarget:self action:@selector(btnRightAAction:) forControlEvents:UIControlEventTouchUpInside];

          UIImageView *imgsjx3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1016_三角形"]];
          [imgsjx3 setFrame:CGRectMake(btnRightA.width - k360Width(20), k360Width(12), k360Width(12), k360Width(7))];
          [btnRightA addSubview:imgsjx3];

    
       [btnLeft setTag:1934];
       [btnRight setTag:1934];
    [btnRightA setTag:1934];

       [self addSubview:btnLeft];
    
       [self addSubview:btnRight];
    [self addSubview:btnRightA];
    

    
    [self updateMakeFrame];
    

    
    NSMutableAttributedString *lblTs2Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [lblTs2Str setYy_font:WY_FONTMedium(14)];
    [lblTs2Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *lblTs2Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传职称证明"];
    [lblTs2Str1 setYy_font:WY_FONTMedium(14)];
    [lblTs2Str1 setYy_color:[UIColor blackColor]];

     [lblTs2Str appendAttributedString:lblTs2Str1];
    self.lblTs2.attributedText = lblTs2Str;
    
    self.lblIsZp.text = @"此专业是否为主评专业，点此修改或确认";
    [self.lblIsZp setBackgroundColor: MSTHEMEColor];
    [self.lblIsZp setTextAlignment:NSTextAlignmentCenter];
    [self.lblIsZp rounded:5];
    [self.lblIsZp setTextColor:[UIColor whiteColor]];
    [self.lblIsZp setFont:WY_FONTMedium(14)];
    
    NSMutableAttributedString *lblTs3Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [lblTs3Str setYy_font:WY_FONTMedium(14)];
    [lblTs3Str setYy_color:[UIColor redColor]];
    NSMutableAttributedString *lblTs3Str1 = [[NSMutableAttributedString alloc] initWithString:@"请上传资格（注册证）或者技术能力证明（格式见右上角下载模板并加盖单位公章"];
    [lblTs3Str1 setYy_font:WY_FONTMedium(14)];
       [lblTs3Str1 setYy_color:[UIColor blackColor]];
     [lblTs3Str appendAttributedString:lblTs3Str1];
    self.lblTs3.attributedText = lblTs3Str;
    [self.lblTs3 setNumberOfLines:2];
    
    
    imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.scrollViewZgzs.bottom + k360Width(10), kScreenWidth, 1)];
    [self addSubview:imgLine];
    [imgLine setBackgroundColor:APPLineColor];
    self.height = imgLine.bottom + 1;
 }

- (void)showCellByModel:(WY_MajorPhotoModel *)withMajorPhotoModel{
    self.mWY_MajorPhotoModel = withMajorPhotoModel;
    [self bindGylhArr];
    
    if (![self.mWY_MajorPhotoModel.letDel isEqual:[NSNull null]] && self.mWY_MajorPhotoModel.letDel != nil) {
        if ([self.mWY_MajorPhotoModel.letDel intValue] == 1) {
            [self.btnDelMajor setHidden:NO];
        } else {
            [self.btnDelMajor setHidden:YES];
        }
    }
    
    NSMutableAttributedString *lblTs1Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [lblTs1Str setYy_color:[UIColor redColor]];
    [lblTs1Str setYy_font:WY_FONTMedium(14)];
    NSMutableAttributedString *lblTs1Str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"请完善原有专业%d",self.rowIndex+1]];
    [lblTs1Str1 setYy_font:WY_FONTMedium(14)];
    [lblTs1Str1 setYy_color:[UIColor blackColor]];
    [lblTs1Str appendAttributedString:lblTs1Str1];

    
    NSMutableArray *arrTypeName = [[NSMutableArray alloc] initWithArray:[self.oldModel.professionName componentsSeparatedByString:@","]];
    NSString *oldName;
    if (arrTypeName.count == 2) {
        oldName = [NSString stringWithFormat:@"\n%@-%@",arrTypeName[0],arrTypeName[1]];
    }
 
    
    NSMutableAttributedString *lblTs1Str2 = [[NSMutableAttributedString alloc] initWithString:oldName];
    [lblTs1Str2 setYy_font:WY_FONTRegular(14)];
    [lblTs1Str2 setYy_color:[UIColor grayColor]];
     [lblTs1Str appendAttributedString:lblTs1Str2];
    [lblTs1Str setYy_lineSpacing:5];
    self.lblTs1.attributedText = lblTs1Str;

    //是1 不能编辑- 并且不能删除- ； 只能选择第三级；
    if ([self.mWY_MajorPhotoModel.professionState isEqualToString:@"1"]) {
        [self.btnDelMajor setHidden:YES];
        [btnLeft setUserInteractionEnabled:NO];
        [btnRight setUserInteractionEnabled:NO];
        NSMutableArray *arrTypeName = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.professionName componentsSeparatedByString:@","]];
        if (arrTypeName.count == 2) {
            [btnLeft setTitle:arrTypeName[0] forState:UIControlStateNormal];
            [btnRight setTitle:arrTypeName[1] forState:UIControlStateNormal];
        }
        if (arrTypeName.count == 3) {
            [btnLeft setTitle:arrTypeName[0] forState:UIControlStateNormal];
            [btnRight setTitle:arrTypeName[1] forState:UIControlStateNormal];
            [btnRightA setTitle:arrTypeName[2] forState:UIControlStateNormal];
            NSMutableArray *arrCodeName = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.professionCode componentsSeparatedByString:@","]];

            self.mWY_MajorPhotoModel.professionCodeThird = arrCodeName[2];
            self.mWY_MajorPhotoModel.professionNameThird = arrTypeName[2];
        }
        if (self.mWY_MajorPhotoModel.professionNameThird.length > 0) {
            [btnRightA setTitle:self.mWY_MajorPhotoModel.professionNameThird forState:UIControlStateNormal];
        }
                
    } else {
        
        NSMutableArray *arrprofessionCode = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.professionCode componentsSeparatedByString:@","]];
        NSMutableArray *arrprofessionName = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.professionName componentsSeparatedByString:@","]];

        if (arrprofessionCode.count >= 3) {
            self.mWY_MajorPhotoModel.professionNameFirst = arrprofessionName[0];
            self.mWY_MajorPhotoModel.professionNameSecond = arrprofessionName[1];
            self.mWY_MajorPhotoModel.professionNameThird = arrprofessionName[2];
            
            self.mWY_MajorPhotoModel.professionCodeFirst = arrprofessionCode[0];
            self.mWY_MajorPhotoModel.professionCodeSecond = arrprofessionCode[1];
            self.mWY_MajorPhotoModel.professionCodeThird = arrprofessionCode[2];
              
        }
        if (self.mWY_MajorPhotoModel.professionNameFirst) {
            [btnLeft setTitle:self.mWY_MajorPhotoModel.professionNameFirst forState:UIControlStateNormal];
            [btnRight setTitle:self.mWY_MajorPhotoModel.professionNameSecond forState:UIControlStateNormal];
            [btnRightA setTitle:self.mWY_MajorPhotoModel.professionNameThird forState:UIControlStateNormal];
        }
    }
    
 
    
    self.arrZczs = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.jobEleid componentsSeparatedByString:@","]];
    
     self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.qualificationEleId componentsSeparatedByString:@","]];
 
    [self initZczsImgs];
    
    [self initZgzsImgs];
 }


- (void)showOldCellByModel:(WY_MajorPhotoModel *)withMajorPhotoModel{
     
    self.mWY_MajorPhotoModel = withMajorPhotoModel;
    
   
    //如果专业是铁路、地铁的- 没有删除按钮
    if ([self.mWY_MajorPhotoModel.source intValue] >= 2) {
        [self.btnDelMajor setHidden:YES];
    } else {
        [self.btnDelMajor setHidden:NO];
        if (![self.mWY_MajorPhotoModel.letDel isEqual:[NSNull null]] && self.mWY_MajorPhotoModel.letDel != nil) {
            if ([self.mWY_MajorPhotoModel.letDel intValue] == 1) {
                [self.btnDelMajor setHidden:NO];
            } else {
                [self.btnDelMajor setHidden:YES];
            }
        }
    }
    
   
    [self bindGylhArr];
    
    NSMutableAttributedString *lblTs1Str = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [lblTs1Str setYy_color:[UIColor redColor]];
    [lblTs1Str setYy_font:WY_FONTMedium(14)];
    NSString *zyStatus = @"";
    if ([withMajorPhotoModel.isOldOrNew isEqualToString:@"1"]) {
        if (self.rowIndex == self.mWY_MajorPhotoModel.oldZPIndex) {
            zyStatus = @"老专业【主评】";
        } else {
            zyStatus = @"老专业";
        }
    } else {
        if (self.rowIndex == self.mWY_MajorPhotoModel.newZPIndex) {
            zyStatus = @"新专业【主评】";
        } else {
            zyStatus = @"新专业";
        }
    }
    
    NSMutableAttributedString *lblTs1Str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"请完善专业%d （%@）",self.rowIndex+1,zyStatus]];
    [lblTs1Str1 setYy_font:WY_FONTMedium(14)];
    [lblTs1Str1 setYy_color:[UIColor blackColor]];
    
    if ([withMajorPhotoModel.expertWarehousing intValue] == 2) {
        NSMutableAttributedString *lblTs1Str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n此专业审核不通过，拒绝原因："]];
        [lblTs1Str2 setYy_font:WY_FONTMedium(14)];
        [lblTs1Str2 setYy_color:[UIColor redColor]];
        [lblTs1Str1 appendAttributedString:lblTs1Str2];
        
        NSMutableAttributedString *lblTs1Str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"点击查看"]];
        [lblTs1Str3 setYy_underlineStyle:NSUnderlineStyleSingle];
        [lblTs1Str3 setYy_font:WY_FONTMedium(14)];
        [lblTs1Str3 setYy_color:[UIColor redColor]];
        [lblTs1Str1 appendAttributedString:lblTs1Str3];
        
        self.lblTs1.userInteractionEnabled = YES;
        [self.lblTs1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拒绝原因" message:self.jujueContent delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }]];

    }
    
    if (withMajorPhotoModel.beforeProfessionName != nil && ![withMajorPhotoModel.beforeProfessionName isEqual:[NSNull null]]) {
        NSMutableAttributedString *lblTs1Str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n原可抽取专业："]];
        [lblTs1Str2 setYy_font:WY_FONTMedium(14)];
        [lblTs1Str2 setYy_color:MSTHEMEColor];
        [lblTs1Str1 appendAttributedString:lblTs1Str2];
        
        NSMutableAttributedString *lblTs1Str3 = [[NSMutableAttributedString alloc] initWithString:withMajorPhotoModel.beforeProfessionName];
        [lblTs1Str3 setYy_font:WY_FONTMedium(14)];
        [lblTs1Str3 setYy_color:MSTHEMEColor];
        [lblTs1Str1 appendAttributedString:lblTs1Str3];

    }
    
    [lblTs1Str appendAttributedString:lblTs1Str1];
    
    [self.lblTs1 setFrame:CGRectMake(k375Width(12), k360Width(5), kScreenWidth, k375Width(60))];
    self.lblTs1.attributedText = lblTs1Str;
    [self.lblTs1 setNumberOfLines:0];
    [self.lblTs1 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblTs1 sizeToFit];
    self.lblTs1.height += 10;
    btnLeft.top = self.lblTs1.bottom + k360Width(10);
    btnRight.top = self.lblTs1.bottom + k360Width(10);
    btnRightA.top = self.lblTs1.bottom + k360Width(10);
    [self updateMakeFrame];
    
    //老专业 - 限制两个专业选择框
    if ([self.mWY_MajorPhotoModel.isOldOrNew isEqualToString:@"1"]) {
        [btnRightA setHidden:YES];
        
        btnLeft.width = (kScreenWidth - k360Width(8*3))/ 2;
        btnRight.width = (kScreenWidth - k360Width(8*3))/ 2;
        btnRight.left = btnLeft.right + k360Width(8);
        
        UIImageView *xialaImg = [btnLeft viewWithTag:103];
        xialaImg.left = btnLeft.width - k360Width(20);
        
        UIImageView *xialaRImg = [btnRight viewWithTag:103];
        xialaRImg.left = btnRight.width - k360Width(20);
        
        
        NSMutableArray *arrprofessionCode = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.professionCode componentsSeparatedByString:@","]];
        NSMutableArray *arrprofessionName = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.professionName componentsSeparatedByString:@","]];

         if (arrprofessionName.count >= 2) {
            self.mWY_MajorPhotoModel.professionNameFirst = arrprofessionName[0];
            self.mWY_MajorPhotoModel.professionNameSecond = arrprofessionName[1];
            self.mWY_MajorPhotoModel.professionCodeFirst = arrprofessionCode[0];
             if(arrprofessionCode.count > 1) {
                 self.mWY_MajorPhotoModel.professionCodeSecond = arrprofessionCode[1];
             } else {
                 self.mWY_MajorPhotoModel.professionCodeSecond = self.mWY_MajorPhotoModel.professionCodeFirst;
             }
            [btnLeft setTitle:self.mWY_MajorPhotoModel.professionNameFirst forState:UIControlStateNormal];
            [btnRight setTitle:self.mWY_MajorPhotoModel.professionNameSecond forState:UIControlStateNormal];
        } else {
            if (self.mWY_MajorPhotoModel.professionNameFirst) {
                [btnLeft setTitle:self.mWY_MajorPhotoModel.professionNameFirst forState:UIControlStateNormal];
                [btnRight setTitle:self.mWY_MajorPhotoModel.professionNameSecond forState:UIControlStateNormal];
                
                if (self.mWY_MajorPhotoModel.professionCodeSecond.length <= 0) {
                    self.mWY_MajorPhotoModel.professionCodeSecond = self.mWY_MajorPhotoModel.professionCode;
                }

             }
        }
    } else {
        
        NSMutableArray *arrprofessionCode = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.professionCode componentsSeparatedByString:@","]];
        NSMutableArray *arrprofessionName = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.professionName componentsSeparatedByString:@","]];

        if (arrprofessionCode.count >= 3) {
            self.mWY_MajorPhotoModel.professionNameFirst = arrprofessionName[0];
            self.mWY_MajorPhotoModel.professionNameSecond = arrprofessionName[1];
            self.mWY_MajorPhotoModel.professionNameThird = arrprofessionName[2];
            
            self.mWY_MajorPhotoModel.professionCodeFirst = arrprofessionCode[0];
            self.mWY_MajorPhotoModel.professionCodeSecond = arrprofessionCode[1];
            self.mWY_MajorPhotoModel.professionCodeThird = arrprofessionCode[2];
             
        }
        if (self.mWY_MajorPhotoModel.professionNameFirst) {
            [btnLeft setTitle:self.mWY_MajorPhotoModel.professionNameFirst forState:UIControlStateNormal];
            [btnRight setTitle:self.mWY_MajorPhotoModel.professionNameSecond forState:UIControlStateNormal];
            [btnRightA setTitle:self.mWY_MajorPhotoModel.professionNameThird forState:UIControlStateNormal];
        }
    }
    
 
    
    self.arrZczs = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.jobEleid componentsSeparatedByString:@","]];
    
     self.arrZgzs = [[NSMutableArray alloc] initWithArray:[self.mWY_MajorPhotoModel.qualificationEleId componentsSeparatedByString:@","]];
 
    [self initZczsImgs];
    
    [self initZgzsImgs];
 }
- (void)showNewCellByModel:(WY_MajorPhotoModel *)withMajorPhotoModel{
    [self showOldCellByModel:withMajorPhotoModel];
}

/// 初始化职称证书Imgs
- (void)initZczsImgs {
    [self.scrollViewZczs removeAllSubviews];
    
    float lastX = k375Width(12);
    int i = 0;
    for (NSString *imgUrl in self.arrZczs) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        tempBtn.rowIndex = i;
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewZczs addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnZczsImgAction:) forControlEvents:UIControlEventTouchUpInside];

        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnZczsDelAction:) forControlEvents:UIControlEventTouchUpInside];

        i ++;
    }
    
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [self.scrollViewZczs addSubview:tempBtnAdd];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addZczsPicAction) forControlEvents:UIControlEventTouchUpInside];

    [self.scrollViewZczs setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
}



- (void)addZgzsPicAction {
    //添加资格证书图片；
//    [self.arrZgzs addObject:@"https://graph.baidu.com/thumb/3526854172,2892710939.jpg"];
//
//    self.mWY_MajorPhotoModel.majorZgzsPhotos = [self.arrZgzs componentsJoinedByString:@",,,,"];
//    [self initZgzsImgs];
    if (self.arrZgzs.count >=2) {
        UIAlertView *alertAction = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加两张证明图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertAction show];
        return;
    }
    if (self.addZgzsPicItemBlock) {
        self.addZgzsPicItemBlock(self);
    }
}

- (void)addZczsPicAction {
    //添加职称证书图片；
//    [self.arrZczs addObject:@"https://graph.baidu.com/thumb/3526854172,2892710939.jpg"];
//    self.mWY_MajorPhotoModel.majorZczsPhotos = [self.arrZczs componentsJoinedByString:@",,,,"];
//
//       [self initZczsImgs];
    
    if (self.arrZczs.count >=2) {
        UIAlertView *alertAction = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多添加两张证明图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertAction show];
        return;
    }
    if (self.addZczsPicItemBlock) {
        self.addZczsPicItemBlock(self);
    }
}

- (void)btnZczsImgAction:(UIButton *)btnSender {
    //打开图片；
    if (self.selPicItemBlock) {
        self.selPicItemBlock(btnSender.tag, self.arrZczs);
    }
}
- (void)btnZgzsImgAction:(UIButton *)btnSender {
    //打开图片；
    if (self.selPicItemBlock) {
        self.selPicItemBlock(btnSender.tag, self.arrZgzs);
    }
}
- (void)btnZczsDelAction:(UIButton *)btnSender {
    
    if (!self.canEdit && !self.canBFEdit) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:self.reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![self.mWY_MajorPhotoModel.letEdit isEqual:[NSNull null]] && self.mWY_MajorPhotoModel.letEdit != nil) {
        if([self.mWY_MajorPhotoModel.letEdit intValue] == 0) {
            [SVProgressHUD showErrorWithStatus:@"当前专业信息不可修改"];
            return;
        }
    }
    //删除图片
    [self.arrZczs removeObjectAtIndex:btnSender.tag];
    self.mWY_MajorPhotoModel.jobEleid = [self.arrZczs componentsJoinedByString:@","];
    [self initZczsImgs];
}

- (void)btnZgzsDelAction:(UIButton *)btnSender {
    if (!self.canEdit && !self.canBFEdit) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:self.reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (![self.mWY_MajorPhotoModel.letEdit isEqual:[NSNull null]] && self.mWY_MajorPhotoModel.letEdit != nil) {
        if([self.mWY_MajorPhotoModel.letEdit intValue] == 0) {
            [SVProgressHUD showErrorWithStatus:@"当前专业信息不可修改"];
            return;
        }
    }
    //删除图片
    [self.arrZgzs removeObjectAtIndex:btnSender.tag];
    self.mWY_MajorPhotoModel.qualificationEleId = [self.arrZgzs componentsJoinedByString:@","];

    [self initZgzsImgs];
}



/// 初始化资格证书Imgs
- (void)initZgzsImgs {
    [self.scrollViewZgzs removeAllSubviews];
    
    float lastX = k375Width(12);
     int i = 0;
    for (NSString *imgUrl in self.arrZgzs) {
        WY_selPicView *tempBtn = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
        [tempBtn showCellByImgUrl:imgUrl ByIsDel:YES];
        lastX = tempBtn.right + k375Width(12);
        [self.scrollViewZgzs addSubview:tempBtn];
        tempBtn.btnImg.tag = i;
        [tempBtn.btnImg addTarget:self action:@selector(btnZgzsImgAction:) forControlEvents:UIControlEventTouchUpInside];

        tempBtn.btnDel.tag = i;
        [tempBtn.btnDel addTarget:self action:@selector(btnZgzsDelAction:) forControlEvents:UIControlEventTouchUpInside];
        i++;
    }
    
    WY_selPicView *tempBtnAdd = [[WY_selPicView alloc] initWithFrame:CGRectMake(lastX, 0, k375Width(100), k375Width(100))];
    [tempBtnAdd showCellByImgUrl:@"" ByIsDel:NO];
    [tempBtnAdd.btnImg addTarget:self action:@selector(addZgzsPicAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollViewZgzs addSubview:tempBtnAdd];
    
    [self.scrollViewZgzs setContentSize:CGSizeMake(tempBtnAdd.right + k375Width(20), 0)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



/**选择年*/
- (void)btnLeftAction:(UIButton *)btnSender {
//    tKhfsmx/getGylh
    //如果专业是铁路、地铁的- 没有删除按钮
    
    if (!self.canEdit && !self.canBFEdit) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:self.reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.mWY_MajorPhotoModel.source intValue] >= 2) {
        [SVProgressHUD showErrorWithStatus:@"当前专业不能修改"];
        return;
    }
    if (![self.mWY_MajorPhotoModel.letEdit isEqual:[NSNull null]] && self.mWY_MajorPhotoModel.letEdit != nil) {
        if([self.mWY_MajorPhotoModel.letEdit intValue] == 0 || [self.mWY_MajorPhotoModel.letEdit intValue] == 2) {
            [SVProgressHUD showErrorWithStatus:@"当前专业信息不可修改"];
            return;
        }
    }
    if (self.arrXiBie) {
        self.arrXiBieStrs = [NSMutableArray new];
        for (WY_ProfessionModel *tempModel in self.arrXiBie) {
            if (tempModel.name) {
                [self.arrXiBieStrs addObject:[NSString stringWithFormat:@"%@%@",tempModel.code,tempModel.name]];
            } else {
                [self.arrXiBieStrs addObject:@""];
            }
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"请选择一级专业" rows:self.arrXiBieStrs initialSelection:self.selIndexXiBie==-1?0:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.selIndexXiBie = selectedIndex;
            WY_ProfessionModel *tempModel = self.arrXiBie[selectedIndex];
            NSLog(@"%@",tempModel.name);
            [btnLeft setTitle:tempModel.name forState:UIControlStateNormal];
            self.mWY_MajorPhotoModel.professionCodeFirst = tempModel.code;
            self.mWY_MajorPhotoModel.professionNameFirst = tempModel.name;
            
            self.mWY_MajorPhotoModel.professionNameSecond = @"";
            self.mWY_MajorPhotoModel.professionCodeSecond = @"";
            self.mWY_MajorPhotoModel.professionCodeThird = @"";
            self.mWY_MajorPhotoModel.professionNameThird = @"";

            [btnRight setTitle:@"请选择二级专业" forState:UIControlStateNormal];
            [btnRightA setTitle:@"请选择三级专业" forState:UIControlStateNormal];
            self.selIndexLcss = -1;
            self.selIndexGylh = -1;
        } cancelBlock:^(ActionSheetStringPicker *picker) {
        } origin:self.superview];

    } else {
        [self bindGylhArr];
    }
}
/**选择月*/
- (void)btnRightAction:(UIButton *)btnSender {
    if (!self.canEdit && !self.canBFEdit) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:self.reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.mWY_MajorPhotoModel.source intValue] >= 2) {
        [SVProgressHUD showErrorWithStatus:@"当前专业不能修改"];
        return;
    }
    if (![self.mWY_MajorPhotoModel.letEdit isEqual:[NSNull null]] && self.mWY_MajorPhotoModel.letEdit != nil) {
        if([self.mWY_MajorPhotoModel.letEdit intValue] == 0 || [self.mWY_MajorPhotoModel.letEdit intValue] == 2) {
            [SVProgressHUD showErrorWithStatus:@"当前专业信息不可修改"];
            return;
        }
    }
    if (self.mWY_MajorPhotoModel.professionCodeFirst.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请先选择一级专业"];
        return;
    }
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    NSString *urlStr = @"";
    // 老专业
    if ([self.mWY_MajorPhotoModel.isOldOrNew isEqualToString:@"1"]) {
        urlStr = expertGetSysIndustriesTypeSecondList_HTTP;
        [postDic setObject:self.mWY_MajorPhotoModel.professionCodeFirst forKey:@"pcode"];
    } else {
        urlStr = getProfession_HTTP;
        [postDic setObject:self.mWY_MajorPhotoModel.professionCodeFirst forKey:@"code"];
        [postDic setObject:@"0" forKey:@"type"];
    }
 
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"EMM_cityCode"];
    [postDic setObject:cityCode forKey:@"citycode"];
    if ((self.isFormal == 1 || self.isFormal == 2)) {
        [postDic setObject:[NSString stringWithFormat:@"%d",self.isFormal] forKey:@"isFormal"];
    } else {
        [postDic setObject:@"0" forKey:@"isFormal"];
    }
    
    //老专业 code -
     if (self.oldModel.professionCode) {
        [postDic setObject:self.oldModel.professionCode forKey:@"scode"];
    }
    [[MS_BasicDataController sharedInstance] postWithURL:urlStr params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
         if (successCallBack) {
             // 老专业
             if ([self.mWY_MajorPhotoModel.isOldOrNew isEqualToString:@"1"]) {
                 self.arrLcss = [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_ProfessionModel class] json:successCallBack]];

             } else {
                 self.arrLcss = [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_ProfessionModel class] json:successCallBack[@"list"]]];

             }
             
             self.arrLcssStrs = [NSMutableArray new];
                    for (WY_ProfessionModel *tempModel in self.arrLcss) {
                        [self.arrLcssStrs addObject:[NSString stringWithFormat:@"%@%@",tempModel.code,tempModel.name]];
                    }
                    [ActionSheetStringPicker showPickerWithTitle:@"请选择二级专业" rows:self.arrLcssStrs initialSelection:self.selIndexLcss==-1?0:self.selIndexLcss doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                        self.selIndexLcss = selectedIndex;
                        self.selIndexGylh = -1;
                        WY_ProfessionModel *tempModel = self.arrLcss[selectedIndex];
                        NSLog(@"%@",tempModel.name);
                        
                        self.mWY_MajorPhotoModel.professionNameSecond = tempModel.name;
                        self.mWY_MajorPhotoModel.professionCodeSecond = tempModel.code;

                        self.mWY_MajorPhotoModel.professionCodeThird = @"";
                        self.mWY_MajorPhotoModel.professionNameThird = @"";
 
                        [btnRight setTitle:tempModel.name forState:UIControlStateNormal];
                        [btnRightA setTitle:@"请选择三级专业" forState:UIControlStateNormal];
                        
                      } cancelBlock:^(ActionSheetStringPicker *picker) {
                    } origin:self.superview];
          }
    } failure:^(NSString *failureCallBack) {
    } ErrorInfo:^(NSError *error) {
     }];
}

/**选择月*/
- (void)btnRightAAction:(UIButton *)btnSender {
    if (!self.canEdit && !self.canBFEdit) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:self.reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([self.mWY_MajorPhotoModel.source intValue] >= 2) {
        [SVProgressHUD showErrorWithStatus:@"当前专业不能修改"];
        return;
    }
    if (![self.mWY_MajorPhotoModel.letEdit isEqual:[NSNull null]] && self.mWY_MajorPhotoModel.letEdit != nil) {
        if([self.mWY_MajorPhotoModel.letEdit intValue] == 0 || [self.mWY_MajorPhotoModel.letEdit intValue] == 2) {
            [SVProgressHUD showErrorWithStatus:@"当前专业信息不可修改"];
            return;
        }
    }
        NSMutableDictionary *postDic = [NSMutableDictionary new];
        if ([self.mWY_MajorPhotoModel.isOldOrNew isEqualToString:@"1"]) {
            [postDic setObject:self.mWY_MajorPhotoModel.professionCode forKey:@"code"];
            [postDic setObject:@"1" forKey:@"type"];
        } else {
            if (self.mWY_MajorPhotoModel.professionCodeSecond.length <= 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择二级专业"];
                return;
            }
            [postDic setObject:self.mWY_MajorPhotoModel.professionCodeSecond forKey:@"code"];
            [postDic setObject:@"0" forKey:@"type"];

        }
    //老专业 code -
     if (self.oldModel.professionCode) {
        [postDic setObject:self.oldModel.professionCode forKey:@"scode"];
    }
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"EMM_cityCode"];
    [postDic setObject:cityCode forKey:@"citycode"];
    if ((self.isFormal == 1 || self.isFormal == 2)) {
        [postDic setObject:[NSString stringWithFormat:@"%d",self.isFormal] forKey:@"isFormal"];
    } else {
        [postDic setObject:@"0" forKey:@"isFormal"];
    }
    
        [[MS_BasicDataController sharedInstance] postWithURL:getProfession_HTTP params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
            NSLog(@"获取数据成功");
             if (successCallBack) {
                 self.arrGylh = [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_ProfessionModel class] json:successCallBack[@"list"]]];
                 
                 self.arrGylhStrs = [NSMutableArray new];
                        for (WY_ProfessionModel *tempModel in self.arrGylh) {
                             [self.arrGylhStrs addObject:[NSString stringWithFormat:@"%@%@",tempModel.code,tempModel.name]];
                        }
                        [ActionSheetStringPicker showPickerWithTitle:@"请选择三级专业" rows:self.arrGylhStrs initialSelection:self.selIndexGylh==-1?0:self.selIndexGylh doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                            self.selIndexGylh = selectedIndex;
                             WY_ProfessionModel *tempModel = self.arrGylh[selectedIndex];
                            NSLog(@"%@",tempModel.name);
                            self.mWY_MajorPhotoModel.professionCodeThird = tempModel.code;
                            self.mWY_MajorPhotoModel.professionNameThird = tempModel.name;
                            [btnRightA setTitle:tempModel.name forState:UIControlStateNormal];
                           } cancelBlock:^(ActionSheetStringPicker *picker) {
                        } origin:self.superview];
              }
        } failure:^(NSString *failureCallBack) {
        } ErrorInfo:^(NSError *error) {
         }];
}


- (void)bindGylhArr {
    self.selIndexXiBie = -1;
    self.selIndexGylh = -1;
    self.selIndexLcss = -1;
    
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    NSString *urlStr = @"";
    // 老专业
    if ([self.mWY_MajorPhotoModel.isOldOrNew isEqualToString:@"1"]) {
        urlStr = expertGetSysIndustriesTypeSecondList_HTTP;
        [postDic setObject:@"" forKey:@"pcode"];
    } else {
        urlStr = getProfession_HTTP;
        [postDic setObject:@"0" forKey:@"code"];
        [postDic setObject:@"0" forKey:@"type"];
    }
    NSString *cityCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"EMM_cityCode"];
    [postDic setObject:cityCode forKey:@"citycode"];
    if ((self.isFormal == 1 || self.isFormal == 2)) {
        [postDic setObject:[NSString stringWithFormat:@"%d",self.isFormal] forKey:@"isFormal"];
    } else {
        [postDic setObject:@"0" forKey:@"isFormal"];
    }
    //老专业 code -
     if (self.oldModel.professionCode) {
        [postDic setObject:self.oldModel.professionCode forKey:@"scode"];
    }
    
    [[MS_BasicDataController sharedInstance] postWithURL:urlStr params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
         if (successCallBack) {
             // 老专业
             if ([self.mWY_MajorPhotoModel.isOldOrNew isEqualToString:@"1"]) {
                 self.arrXiBie = [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_ProfessionModel class] json:successCallBack]];
             } else {
                 self.arrXiBie = [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_ProfessionModel class] json:successCallBack[@"list"]]];

             }
          }
    } failure:^(NSString *failureCallBack) {
    } ErrorInfo:^(NSError *error) {
     }];
 
}


@end
