//
//  WY_CS_AlertPageViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/4/20.
//  Copyright © 2022 王杨. All rights reserved.
//

#import "WY_CS_AlertPageViewController.h"
#import "WY_CAHandleViewController.h"
#import "WY_CAOrderMainViewController.h"
#import "WY_CATypeUIControl.h"
#import "WY_CloudSignatureHandleViewController.h"

@interface WY_CS_AlertPageViewController ()
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) WY_CATypeUIControl *btnCAUsbKey;
@property (nonatomic, strong) WY_CATypeUIControl *btnCACS;
@property (nonatomic, strong) UILabel *lblTop;
@property (nonatomic, strong) UILabel *lblBottom;
@property (nonatomic, strong) UIView *viewMiddel;
@property (nonatomic, strong) NSDictionary *wxtsStr;
//实体CA温馨提示
@property (nonatomic, strong) NSDictionary *wxtsCAStr;
//特别说明
@property (nonatomic, strong) NSDictionary *yqztdStr;
//ca特别说明
@property (nonatomic, strong) NSDictionary *catdStr;
//实体锁状态
@property (nonatomic) int  usbkeyStatus;
//云签章状态
@property (nonatomic) int  csStatus;


@end

@implementation WY_CS_AlertPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self dataBind];
    [self firstAlertA];
    
}
- (void)firstAlertA {
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"　　1.专家可根据自身需要，自愿选择此便捷渠道申请CA数字证书或云签章，一经办理，不予退换，具体使用范围，详见页面上方产品说明。\n　　2.大连公共资源专家推荐办理“云签章”。\n 咨询电话:024-26206677"];
    [alertControllerMessageStr setYy_alignment:NSTextAlignmentLeft];
    [alertControllerMessageStr setYy_font:WY_FONT375Medium(12)];
    [alertControllerMessageStr setYy_lineSpacing:1];
    [alertControl setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
      [self presentViewController:alertControl animated:YES completion:nil];

}

- (void)makeUI {
    self.title = @"CA便捷办理";
    [self.view setBackgroundColor:HEXCOLOR(0xf0f0f0)];
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.mScrollView setBackgroundColor:HEXCOLOR(0xf0f0f0)];
    [self.view addSubview:self.mScrollView];

    float btnW = (kScreenWidth - k360Width(16*3)) / 2;

    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), self.mScrollView.bottom, btnW, k360Width(44))];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:WY_FONTMedium(14)];
    [btnCancel setBackgroundColor:HEXCOLOR(0xf0f0f0)];
    [btnCancel setTitleColor:HEXCOLOR(0x676666) forState:UIControlStateNormal];
    [btnCancel rounded:k360Width(44)/8 width:1 color:HEXCOLOR(0x676666)];
    [btnCancel setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"取消");
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:btnCancel];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(btnCancel.right + k360Width(16) , self.mScrollView.bottom, btnW, k360Width(44))];
    [self.btnSubmit setTitle:@"确认" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    [self initScrollView];
}

- (void)dataBind {
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_handleCloudSignatureIntroduce_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            NSMutableArray *arrData =[[NSMutableArray alloc] initWithArray:res[@"data"]];
            [self  bindView:arrData];
        } else {
             
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
    }];

    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_canableToHandle_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            self.usbkeyStatus = [res[@"data"][@"caOrder"] intValue];
            if(self.btnCAUsbKey) {
                self.btnCAUsbKey.caStatus = self.usbkeyStatus;
                
                [self.btnCAUsbKey updateViewStatus];
            }
            self.csStatus = [res[@"data"][@"signatureOrder"] intValue];
            if(self.btnCACS) {
                self.btnCACS.caStatus = self.csStatus;
                
                [self.btnCACS updateViewStatus];
            }
    
        }
       
        } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
    }];
     
    
}
- (void)bindView:(NSMutableArray *)arrData {
    // 实体CA 温馨提示
    self.wxtsCAStr = [self geetStrByArr:arrData byType:@"3"];
    // 云签章 温馨提示
    self.wxtsStr = [self geetStrByArr:arrData byType:@"9"];
    
    //  云签章特点
    self.yqztdStr = [self geetStrByArr:arrData byType:@"4"];
    //实体CA特大
    self.catdStr = [self geetStrByArr:arrData byType:@"8"];
    
    NSMutableAttributedString *attTop0 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",@"温馨提示："]];
    NSMutableAttributedString *attTop1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.wxtsStr[@"url"]]];
    NSMutableAttributedString *attTopA1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.wxtsCAStr[@"url"]]];
     
    NSMutableAttributedString *attModel1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.yqztdStr[@"url"]]];
    NSMutableAttributedString *attModelA1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.catdStr[@"url"]]];

 

    NSMutableAttributedString *attTop02 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",@"　　为了提供更好数据共享服务，压缩办理流程、时限，减少材料重复提供，加强个人信息保密，各位专家可根据各主管部门的电子化要求，自愿选择此便捷渠道申请办理。"]];

    NSMutableAttributedString *attTop2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"　　%@",self.wxtsStr[@"codeText"]]];
    NSMutableAttributedString *attTopA2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"　　%@",self.wxtsCAStr[@"codeText"]]];
    
    NSMutableAttributedString *attModel2 = [[NSMutableAttributedString alloc] initWithString:self.yqztdStr[@"codeText"]];
    NSMutableAttributedString *attModelA2 = [[NSMutableAttributedString alloc] initWithString:self.catdStr[@"codeText"]];
    
    [attTop0 setYy_font:WY_FONTMedium(14)];
    [attTop02 setYy_font:WY_FONTMedium(14)];
    
    
    [attTop1 setYy_font:WY_FONTMedium(14)];
    [attTop2 setYy_font:WY_FONTRegular(14)]; 
    [attTopA1 setYy_font:WY_FONTMedium(14)];
    [attTopA2 setYy_font:WY_FONTRegular(14)];
    [attModel1 setYy_font:WY_FONTMedium(14)];
    [attModel2 setYy_font:WY_FONTRegular(14)];
    [attModelA1 setYy_font:WY_FONTMedium(14)];
    [attModelA2 setYy_font:WY_FONTRegular(14)];
 
    [attTop0 setYy_color:[UIColor blackColor]];
    [attTop1 setYy_color:[UIColor blackColor]];
    [attTopA1 setYy_color:[UIColor blackColor]];
    
    [attTop2 yy_setColor:HEXCOLOR(0xFF4D4D) range: [attTop2.string rangeOfString:@"(可用于辽宁省工程建设项目数字化开标评标系统、大连市公共资源交易平台，暂未开通辽宁省政府采购平台 、朝阳市公共资源交易平台)"]];
    [attTopA2 yy_setColor:HEXCOLOR(0xFF4D4D) range: [attTopA2.string rangeOfString:@"(可互联互通辽宁建设工程信息网、辽宁政府采购网、朝阳市公共资源交易平台、大连市公共资源交易平台)"]];
    
    [attTop0 appendAttributedString:attTop02];
    
    [attTop1 appendAttributedString:attTop2];
    [attModel1 appendAttributedString:attModel2];
    
    [attModelA1 appendAttributedString:attModelA2];
 
    
    [attTopA1 appendAttributedString:attTopA2];
    
    
    
    
    [attModel1 setYy_color:HEXCOLOR(0xFF4D4D)];
    [attModelA1 setYy_color:HEXCOLOR(0xFF4D4D)];
 
    [attTop1 setYy_lineSpacing:5];
    [attTop0 setYy_lineSpacing:5];
    
    
    [attTopA1 setYy_lineSpacing:5];
    
    [attModel1 setYy_lineSpacing:5];
    [attModelA1 setYy_lineSpacing:5];
    
    
    
    
    [self.lblTop setNumberOfLines:0];
    [self.lblTop setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblBottom setNumberOfLines:0];
    [self.lblBottom setLineBreakMode:NSLineBreakByWordWrapping];
  
    [attModel1 yy_appendString:@"\n"];
    [attModelA1 yy_appendString:@"\n"];
//    [attModel1 appendAttributedString:attBottom1];
    
    [self.lblTop setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(22))];
    [self.viewMiddel setFrame:CGRectMake(0, self.lblTop.bottom, kScreenWidth, k360Width(100))];
    [self.lblBottom setFrame:CGRectMake(k360Width(16), self.viewMiddel.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(22))];

    self.lblTop.attributedText = attTop0;

    [self.lblTop sizeToFit];
    self.lblTop.height += 10;
    
    
    
    [self.lblBottom sizeToFit];
    self.lblBottom.height += 10;
    
    self.viewMiddel.top = self.lblTop.bottom + k360Width(16);
    
    
    UILabel *lblTiShi = [UILabel new];
    [lblTiShi setFrame:CGRectMake(k360Width(16), k360Width(0), kScreenWidth - k360Width(32), k360Width(44))];
    
    NSMutableAttributedString *attTop1Strxxx = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attTop1Strxxx setYy_font:WY_FONTMedium(14)];
    [attTop1Strxxx setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attTop1Str1xxx = [[NSMutableAttributedString alloc] initWithString:@"请选择申请类型"];
    [attTop1Str1xxx setYy_font:WY_FONTMedium(14)];
    [attTop1Str1xxx setYy_color:[UIColor blackColor]];
    [attTop1Strxxx appendAttributedString:attTop1Str1xxx];
    [lblTiShi setAttributedText:attTop1Strxxx];
    
    [self.viewMiddel addSubview:lblTiShi];
    
    //初始化按钮；
    float btnW = (kScreenWidth - k360Width(16*3)) / 2;
//    self.btnCACS = [[WY_CATypeUIControl alloc] initWithFrame:CGRectMake(k360Width(16), lblTiShi.bottom, btnW, btnW)];
//    self.btnCAUsbKey = [[WY_CATypeUIControl alloc] initWithFrame:CGRectMake(self.btnCACS.right + k360Width(16), lblTiShi.bottom, btnW, btnW)];
    self.btnCAUsbKey = [[WY_CATypeUIControl alloc] initWithFrame:CGRectMake(k360Width(16), lblTiShi.bottom, btnW, btnW)];
    self.btnCACS = [[WY_CATypeUIControl alloc] initWithFrame:CGRectMake(self.btnCAUsbKey.right + k360Width(16), lblTiShi.bottom, btnW, btnW)];
    

 
//    self.btnCACS.caStatus = @"0";
//    self.btnCAUsbKey.caStatus = @"0";
      
    self.btnCACS.lblInfo.text = @"云签章";
    self.btnCAUsbKey.lblInfo.text = @"实体CA锁";
    self.btnCACS.imgUrl = @"0420_cloudsign";
    self.btnCACS.imgUrl_Sel = @"0420_cloudsign_sel";
    
    self.btnCAUsbKey.imgUrl = @"0420_usbkey";
    self.btnCAUsbKey.imgUrl_Sel = @"0420_usbkey_sel";
    
//    [self.btnCACS setSelected:YES];
//    2023-07-25 15:00:37 -罗欣桐需求- 原来需求是默认进入页面选中云签章 现在改成CA锁
//    2024-01-11 17:37:28 -罗欣桐需求又改了- 进入不默认选择，可取消已选择
//    [self.btnCAUsbKey setSelected:YES];
    
    self.btnCAUsbKey.caStatus = self.usbkeyStatus;
    
    self.btnCACS.caStatus = self.csStatus;
    
    
    [self.btnCACS updateViewStatus];
    [self.btnCAUsbKey updateViewStatus];
    
    [self.btnCACS setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.btnCACS.selected = !self.btnCACS.selected;
        self.btnCAUsbKey.selected = NO;
        [self.btnCACS updateViewStatus];
        [self.btnCAUsbKey updateViewStatus]; 
        
        if (self.btnCACS.selected) {
            self.lblBottom.attributedText = attModel1;
            self.lblTop.attributedText = attTop1;
        } else {
            self.lblBottom.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
            self.lblTop.attributedText = attTop0;
        }
        
        
        [self.lblTop setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(22))];
        [self.lblTop sizeToFit];
        self.lblTop.height += 10;
        self.viewMiddel.top = self.lblTop.bottom + k360Width(16);
        
        [self.lblBottom setFrame:CGRectMake(k360Width(16), self.viewMiddel.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(22))];
        [self.lblBottom sizeToFit];
        self.lblBottom.height += 10;
        [self.mScrollView setContentSize:CGSizeMake(0, self.lblBottom.bottom + k360Width(16))];
        
        
    }];
    
    [self.btnCAUsbKey setBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.btnCACS.selected = NO;
        self.btnCAUsbKey.selected = !self.btnCAUsbKey.selected;
        [self.btnCACS updateViewStatus];
        [self.btnCAUsbKey updateViewStatus];
        if (self.btnCAUsbKey.selected) {
            self.lblBottom.attributedText = attModelA1;
            self.lblTop.attributedText = attTopA1;
        } else {
            self.lblBottom.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
            self.lblTop.attributedText = attTop0;
        }
        
        
        [self.lblTop setFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(22))];
        [self.lblTop sizeToFit];
        self.lblTop.height += 10;
        self.viewMiddel.top = self.lblTop.bottom + k360Width(16);

        
        [self.lblBottom setFrame:CGRectMake(k360Width(16), self.viewMiddel.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(22))];
        [self.lblBottom sizeToFit];
        self.lblBottom.height += 10;
        [self.mScrollView setContentSize:CGSizeMake(0, self.lblBottom.bottom + k360Width(16))];
        
        
    }];
    
    
    [self.viewMiddel addSubview:self.btnCACS];
    [self.viewMiddel addSubview:self.btnCAUsbKey];

    self.viewMiddel.height = self.btnCACS.bottom + k360Width(16);
    
    
    
    self.lblBottom.top = self.viewMiddel.bottom + k360Width(16);
    
    [self.mScrollView setContentSize:CGSizeMake(0, self.lblBottom.bottom + k360Width(16))];
    

    
}

/// 通过typeID取描述文字
/// @param typeID 字典表ID
- (NSDictionary *)geetStrByArr:(NSMutableArray *)arrData byType:(NSString *)typeID {
    for (NSDictionary *dicItem in arrData) {
             if ([dicItem[@"id"] intValue]  == [typeID intValue]) {
                return dicItem;
            }
        
    }
    return nil;
}
/// 初始化scroll内容
- (void)initScrollView {
    self.lblTop = [UILabel new];
    self.lblBottom = [UILabel new];
    self.viewMiddel = [UIView new];
    
    
    [self.mScrollView addSubview:self.lblTop];
    [self.mScrollView addSubview:self.viewMiddel];
    [self.mScrollView addSubview:self.lblBottom];
    
}

/// 确定按钮
- (void)btnSubmitAction{
    
    if (!self.btnCAUsbKey.selected && !self.btnCACS.selected) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先选择申请类型" preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
          [self presentViewController:alertControl animated:YES completion:nil];

        return;
    }
    
    if(self.btnCAUsbKey.selected) {
        [self CABanLi];
    } else {
        [self cloudSignBanLi];
    }
}

/// 云签章办理
- (void)cloudSignBanLi {
    if (self.csStatus == 0) {
        //进入云签章办理页
        NSLog(@"进入云签章办理页");
        
        [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getCloudSignatureType_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            
            if (([code integerValue] == 0) && res) {
                NSMutableDictionary *dicCloudSignatureType = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
                WY_CloudSignatureHandleViewController *tempController = [WY_CloudSignatureHandleViewController new];
                tempController.yqztdStr = self.wxtsStr;
                tempController.dicCloudSignatureType = dicCloudSignatureType;
                [self.navigationController pushViewController:tempController animated:YES];
            } else {
                
            }
        }
        failure:^(NSError *error) {
     
        }];
        

    } else {
        //进入订单列表页；
        NSLog(@"进入云签章订单列表页");
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已有CA办理订单" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:([UIAlertAction actionWithTitle:@"去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WY_CAOrderMainViewController *tempController = [WY_CAOrderMainViewController new];
            tempController.selZJIndex = 0;
            tempController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tempController animated:YES];
        }])];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

/// 实体CA办理
- (void)CABanLi {
    if (self.usbkeyStatus == 0) {
        WY_CAHandleViewController *tempController = [WY_CAHandleViewController new];
        [self.navigationController pushViewController:tempController animated:YES];

    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您已有CA办理订单" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取 消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:([UIAlertAction actionWithTitle:@"去查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            WY_CAOrderMainViewController *tempController = [WY_CAOrderMainViewController new];
            tempController.selZJIndex = 1;
            tempController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tempController animated:YES];
        }])];
        [self presentViewController:alertController animated:YES completion:nil];

    }
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
