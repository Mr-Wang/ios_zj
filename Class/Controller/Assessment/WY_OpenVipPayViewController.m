//
//  WY_OpenVipPayViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/21.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_OpenVipPayViewController.h"
#import "WY_SelectInvoiceViewController.h"
#import "WY_MyBalanceViewController.h"
#import "YZAuthID.h"
#import "WY_CaOnlinePayCallBackModel.h"
#import "WY_VipOrderModel.h"

@interface WY_OpenVipPayViewController (){
     UIControl *colModel;
    float colLastY;
    UILabel *lblMoney;
    UIImageView *imgMoneySel;
    NSInteger selZSFLIndex; //知识分类
    //总金额- = 当前金额 * 当前选择人数
    float totalPrice ;
    //实际金额；
    float realPrice;
    //折扣
    float zheKou ;
    NSString *yuanZk;
    NSString *yuanAmount;
    //节省金额
    float jieShengPrice;
    BOOL isInvoice;
    UILabel *lblBottom;
    
    
    UIView *pdfView;
    UIButton *btnLeft;
    UIButton *btnRight;
    NSString *isAgree;
}
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) WY_SendEnrolmentMessageModel *mWY_SendEnrolmentMessageModel;

@property (nonatomic, strong) UILabel *lblTop;
//选择支付类型View
@property (nonatomic, strong) UIView *viewPayType;
//添加人员View
@property (nonatomic, strong) UIView *viewAddPeople;
@property (nonatomic, strong) UIView *viewFaPiao;
@property (nonatomic, strong) UIView *viewBottom;

@property (nonatomic, strong) UILabel *lblPrice;
@property (nonatomic, strong) UILabel *lblFaPiao;
@property (nonatomic, strong) UIButton *btnSubmit;
@property (nonatomic, strong) NSMutableArray *arrSelPeople;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic , strong) NSDictionary *dicSignUpSuccess;
@property (nonatomic , strong) NSString *pdfUrlStr;
@end

@implementation WY_OpenVipPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    
    self.arrSelPeople = [NSMutableArray new];
    [self.arrSelPeople addObject:self.mUser];
    
    [self guolvUser];
    [self makeUI];
    [self updateSelPerpro];
}
///过滤可选择用户
- (void)guolvUser
{
    NSMutableArray *glUsers = [NSMutableArray new];
    
    if (self.mWY_VipMainModel.huiyuanUsers != nil && self.mWY_VipMainModel.huiyuanUsers.count > 0) {
        if ([self.isOpen isEqualToString:@"1"]) {
            //如果是开通会员 - 过滤掉 列表中- 已经是会员的用户；
            for (WY_UserModel *tempU in self.mWY_VipMainModel.huiyuanUsers) {
                if ([tempU.viplevel intValue] > 0) {
                    NSLog(@"%@不能开通VIP-, 他的会员级别：%@",tempU.realname,tempU.viplevel);
                } else {
                    [glUsers addObject:tempU];
                }
            }
            self.mWY_VipMainModel.huiyuanUsers = glUsers;
        } else if ([self.isOpen isEqualToString:@"2"]) {
            //如果是续费；
            
        }else if ([self.isOpen isEqualToString:@"3"]) {
            //如果是升级会员 - 过滤掉 列表中- 不是会员和 当前选择级别以上的用户；
            for (WY_UserModel *tempU in self.mWY_VipMainModel.huiyuanUsers) {
                if (tempU.viplevel && ([tempU.viplevel intValue] < self.selIndex + 1)) {
                    [glUsers addObject:tempU];
                } else {
                    NSLog(@"%@此用户不能升级, 他的会员级别：%@",tempU.realname,tempU.viplevel);
                    
                }
            }
            self.mWY_VipMainModel.huiyuanUsers = glUsers;
        }
    }
    
}
- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xfafafa)];
    self.mScrollView = [UIScrollView new];
    self.lblTop = [UILabel new];
    self.viewPayType = [UIView new];
    self.viewFaPiao = [UIView new];
    self.viewAddPeople = [UIView new];
    self.viewBottom = [UIView new];
    [self.view addSubview:self.viewBottom];
    [self.lblTop setFrame:CGRectMake(0, 0, kScreenWidth, k360Width(44))];
    [self.view addSubview:self.lblTop];
    
    [self.mScrollView setFrame:CGRectMake(0, self.lblTop.bottom, kScreenWidth, kScreenHeight - self.lblTop.bottom - k360Width(50) - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    [self.viewPayType setFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), k360Width(50))];
    [self.viewPayType setBackgroundColor:[UIColor whiteColor]];
    [self.viewPayType rounded:k360Width(44/8)];
    
    
    [self initCellTitle:@"支付方式" byLabel:nil withView:self.viewPayType isAcc:NO withBlcok:nil];
    
    lblMoney = [UILabel new];
    imgMoneySel = [UIImageView new];
    colLastY = k360Width(44);
    colModel = [self retControlBy:@"余额支付" byLabTitle:lblMoney byImage:[UIImage imageNamed:@"0224_myyue"] imgBaySel:imgMoneySel];
    colModel.selected = YES;
    lblBottom = [UILabel new];
    [self.mScrollView addSubview:lblBottom];
    [self.viewPayType addSubview:colModel];
    
    self.viewPayType.height = colModel.bottom;
    
    [self.viewAddPeople setFrame:CGRectMake(k360Width(16), self.viewPayType.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(44))];
    [self.viewAddPeople setBackgroundColor:[UIColor whiteColor]];
    [self.viewAddPeople rounded:k360Width(44/8)];
    
    [self.mScrollView addSubview:self.viewPayType];
    [self.mScrollView addSubview:self.viewAddPeople];
    
    
    if (self.mWY_VipMainModel.huiyuanUsers.count <= 0) {
        [self.viewAddPeople setHidden:YES];
        [self.viewFaPiao setFrame:CGRectMake(k360Width(16), self.viewPayType.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(44))];
        
    } else {
        [self.viewFaPiao setFrame:CGRectMake(k360Width(16), self.viewAddPeople.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(44))];
    }
    
    [self.mScrollView addSubview:self.viewFaPiao];
    
    [self.viewBottom setBackgroundColor:[UIColor whiteColor]];
    [self.viewBottom setFrame:CGRectMake(0, self.mScrollView.bottom, kScreenWidth, k360Width(50))];
    
    
    //添加人员；
    if (self.mWY_VipMainModel.huiyuanUsers.count > 0) {
        [self initCellTitle:@"添加人员" byLabel:nil withView:self.viewAddPeople isAcc:YES withBlcok:^{
            NSLog(@"点击了添加人员");
            [self selPerproItem];
        }];
    }
    self.lblFaPiao = [UILabel new];
    [self initCellTitle:@"发票" byLabel:self.lblFaPiao withView:self.viewFaPiao isAcc:YES withBlcok:^{
        NSLog(@"点击了发票按钮");
        
        //跳转到发票页；
        WY_SelectInvoiceViewController *tempController = [WY_SelectInvoiceViewController new];
        tempController.adviceType = @"1";
        tempController.isCanSave = YES;
        tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
        tempController.saveInvoiceBlock = ^(WY_SendEnrolmentMessageModel * _Nonnull saveModel) {
            self.mWY_SendEnrolmentMessageModel = saveModel;
            self.lblFaPiao.text = saveModel.InvoiceName;
        };
        [self.navigationController pushViewController:tempController animated:YES];
        
    }];
    
    self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(160), k360Width(50))];
    [self.lblPrice setNumberOfLines:2];
    [self.lblPrice setLineBreakMode:NSLineBreakByWordWrapping];
    //    [self.lblPrice  setText:@"实付金额：￥1615.5"];
    [self.viewBottom addSubview:self.lblPrice];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(116), 0, k360Width(100), k360Width(38))];
    [self.btnSubmit rounded:k360Width(44/4)];
    [self.btnSubmit setBackgroundColor:HEXCOLOR(0xE16532)];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    self.btnSubmit.centerY = self.lblPrice.centerY;
    [self.viewBottom addSubview:self.btnSubmit];
}
- (void)selPerproItem {
    //添加人员；
    if (self.mWY_VipMainModel.huiyuanUsers.count <=0) {
        [SVProgressHUD showErrorWithStatus:@"没有成员可以添加"];
        return;
    }
    
    
    
    NSMutableArray *usernames = [NSMutableArray new];
    for (WY_UserModel *tempUser in self.mWY_VipMainModel.huiyuanUsers) {
        if ([self.isOpen isEqualToString:@"3"]) {
            NSString * viptypeStr = @"";
            switch ([tempUser.viplevel intValue]) {
                case 1:
                {
                    viptypeStr = @"普通会员";
                }
                    break;
                case 2:
                {
                    viptypeStr = @"高级会员";
                }
                    break;
                case  3: {
                    viptypeStr = @"超级会员";
                }
                    break;
                default:
                    break;
            }
            
            [usernames addObject:[NSString stringWithFormat:@"%@ (当前等级：%@)",tempUser.realname,viptypeStr]];
        } else {
            [usernames addObject:tempUser.realname];
        }
        
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"请选择人员" rows:usernames initialSelection:selZSFLIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        selZSFLIndex = selectedIndex;
        
        WY_UserModel *tempUser =[self.mWY_VipMainModel.huiyuanUsers objectAtIndex:selectedIndex];
        BOOL isCz = NO;
        for (WY_UserModel *czUser in self.arrSelPeople) {
            if ([czUser.UserGuid isEqualToString:tempUser.UserGuid]) {
                isCz = YES;
                break;
            }
        }
        if (isCz) {
            [SVProgressHUD showErrorWithStatus:@"已添加该成员无需重复添加"];
            return ;
        } else {
            [self.arrSelPeople addObject:[self.mWY_VipMainModel.huiyuanUsers objectAtIndex:selectedIndex]];
            [self updateSelPerpro];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
    
}

- (void) updateSelPerpro {
    NSMutableAttributedString *strAtt1 = [[NSMutableAttributedString alloc] initWithString:@"您已选中"];
    NSMutableAttributedString *strAtt3 = [[NSMutableAttributedString alloc] initWithString:@"套餐"];
    
    WY_VipItemModel *vipItemModel = [self.mWY_VipMainModel.orderPrice objectAtIndex:self.selIndex];

    NSString *vipStr = [NSString stringWithFormat:@"“%@”",vipItemModel.dz];
     NSMutableAttributedString *strAtt2 = [[NSMutableAttributedString alloc] initWithString:vipStr];
    [strAtt1 setYy_font:WY_FONTRegular(14)];
    
    [strAtt3 setYy_font:WY_FONTRegular(14)];
    
    [strAtt2 setYy_font:WY_FONTMedium(16)];
    [strAtt2 setYy_color:MSTHEMEColor];
    [strAtt1 appendAttributedString:strAtt2];
    [strAtt1 appendAttributedString:strAtt3];
    self.lblTop.attributedText = strAtt1;
    
    [self.lblTop setTextAlignment:NSTextAlignmentCenter];
    if (self.mWY_VipMainModel.huiyuanUsers.count > 0) {
        for (UIView *tView in self.viewAddPeople.subviews) {
            if (tView.tag != 1002) {
                [tView removeFromSuperview];
            }
        }
        
        
        int lastY = k360Width(44);
        for (WY_UserModel *userItem in self.arrSelPeople) {
            UIView *viewAddP = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, self.viewAddPeople.width, k360Width(44))];
            UIButton *btnDel = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(0), 0, k360Width(44), k360Width(44))];
            //        [btnDel setBackgroundColor:[UIColor redColor]];
            [btnDel setBackgroundImage:[UIImage imageNamed:@"delUser"] forState:UIControlStateNormal];
            [btnDel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                NSLog(@"点击了删除人员");
                if (self.mWY_VipMainModel.huiyuanUsers == nil || self.mWY_VipMainModel.huiyuanUsers.count <= 0) {
                    [SVProgressHUD showErrorWithStatus:@"不能删除自己"];
                    return ;
                } else {
                    [self.arrSelPeople removeObject:userItem];
                    [self updateSelPerpro];
                }
            }];
            [viewAddP addSubview:btnDel];
            
            UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(btnDel.right + k360Width(10), 0, viewAddP.width - btnDel.right - k360Width(20), k360Width(44))];
            lblName.text = userItem.realname;
            [lblName setFont:WY_FONTMedium(14)];
            [viewAddP addSubview:lblName];
            
            UIImageView *imgLine = [UIImageView new];
            [imgLine setFrame:CGRectMake(0, k360Width(44) - 1, viewAddP.width, 1)];
            [imgLine setBackgroundColor:APPLineColor];
            [viewAddP addSubview:imgLine];
            
            btnDel.centerY = lblName.centerY;
            [self.viewAddPeople addSubview:viewAddP];
            lastY = viewAddP.bottom;
        }
        self.viewAddPeople.height = lastY;
        [self.viewFaPiao setFrame:CGRectMake(k360Width(16), self.viewAddPeople.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(44))];
        [self.mScrollView setContentSize:CGSizeMake(0, self.viewFaPiao.bottom + k360Width(16))];
        
    }
    [self CalculateTotalPrice];
    
}
- (void)showRealPriceLab {
    //如果没有打折
    if (zheKou == 1) {
        //            realPrice = totalPrice;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"实付金额："];
        [attStr setYy_font:WY_FONTRegular(14)];
        NSMutableAttributedString *attStrA = [[NSMutableAttributedString alloc] initWithString:@"￥ "];
        [attStrA setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStrA setYy_color:HEXCOLOR(0xE38D38)];
        [attStr appendAttributedString:attStrA];
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",realPrice]];
        [attStr1 setYy_color:HEXCOLOR(0xE48C36)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr appendAttributedString:attStr1];
        
        self.lblPrice.attributedText = attStr;
        
    } else {
        //            //实际金额 = 总金额 * 折扣
        //            realPrice = totalPrice * zheKou;
        //            //节省金额 = 总金额 - 实际金额；
        //            jieShengPrice = totalPrice - realPrice;
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"实付金额："];
        [attStr setYy_font:WY_FONTRegular(14)];
        NSMutableAttributedString *attStrA = [[NSMutableAttributedString alloc] initWithString:@"￥ "];
        [attStrA setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStrA setYy_color:HEXCOLOR(0xE38D38)];
        [attStr appendAttributedString:attStrA];
        
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",realPrice]];
        [attStr1 setYy_color:HEXCOLOR(0xE48C36)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr appendAttributedString:attStr1];
        
        NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n已享受%.0f折优惠，节省%.2f元",zheKou,jieShengPrice]];
        [attStr2 setYy_color:APPTextGayColor];
        [attStr2 setYy_font:WY_FONTRegular(12)];
        [attStr appendAttributedString:attStr2];
        self.lblPrice.attributedText = attStr;
    }
    
}

///计算总价
- (void)CalculateTotalPrice {
    //当前选择VipItem ;
    WY_VipItemModel *vipItemModel = [self.mWY_VipMainModel.orderPrice objectAtIndex:self.selIndex];
    WY_TopUpModel *tempTuModel = [self.mWY_VipMainModel.codeMain objectAtIndex:0];
    
    
    
    [lblBottom setFrame:CGRectMake(k360Width(16), self.viewFaPiao.bottom + k360Width(16), kScreenWidth - k360Width(32), k360Width(200))];
    [lblBottom setFont:WY_FONTRegular(14)];
    [lblBottom setTextColor:[UIColor redColor]];
    [lblBottom setNumberOfLines:0];
    [lblBottom setText:[NSString stringWithFormat:@"  *%@",tempTuModel.nsDescription]];
    [self.mScrollView setContentSize:CGSizeMake(0, lblBottom.bottom + k360Width(10))];
    //总金额- = 当前金额 * 当前选择人数
    //    totalPrice = [vipItemModel.newprice floatValue] * self.arrSelPeople.count;
    //    //实际金额；
    //    realPrice = 0;
    //    //折扣
    //    zheKou = 1;
    //    //节省金额
    //    jieShengPrice = 0;
    
    if (self.arrSelPeople.count > 0) {
        for (WY_TopUpModel *topUpModel in self.mWY_VipMainModel.codeMain) {
            //如果当前选择充值的人数-总金额 》= 可折扣的金额
            if (totalPrice >= [topUpModel.itemText intValue]) {
                zheKou = [topUpModel.itemValue floatValue];
                break;
            }
        }
    }else {
        //没有选择人员；- 金额为0； 且点击按钮提示- 请添加人员；
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"实付金额："];
        [attStr setYy_font:WY_FONTRegular(14)];
        NSMutableAttributedString *attStrA = [[NSMutableAttributedString alloc] initWithString:@"￥ "];
        [attStrA setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(14)]];
        [attStrA setYy_color:HEXCOLOR(0xE38D38)];
        [attStr appendAttributedString:attStrA];
        
        NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"0.00"];
        [attStr1 setYy_color:HEXCOLOR(0xE48C36)];
        [attStr1 setYy_font:[UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:k360Width(28)]];
        [attStr appendAttributedString:attStr1];
        
        self.lblPrice.attributedText = attStr;
    }
    
    
    //        if ([self.isOpen isEqualToString:@"3"]) {
    //如果是升级
    NSMutableArray *traEnrolPersons = [NSMutableArray new];
    for (WY_UserModel *tempUser in self.arrSelPeople) {
        WY_TraEnrolPersonModel *tempTepUser = [WY_TraEnrolPersonModel new];
        tempTepUser.UserGuid = tempUser.UserGuid;
        tempTepUser.UserName = tempUser.realname;
        WY_VipItemModel *vipItemModel = [self.mWY_VipMainModel.orderPrice objectAtIndex:self.selIndex];
        tempTepUser.viplevel = [NSString stringWithFormat:@"%@",vipItemModel.gmlx];
        [traEnrolPersons addObject:tempTepUser];
    }
    NSLog(@"%@",[traEnrolPersons yy_modelToJSONString])
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getVipPrice_HTTP params:nil jsonData:[traEnrolPersons yy_modelToJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            WY_VipMainModel *vipPriceModel = [WY_VipMainModel modelWithJSON:res[@"data"]];
            //                    totalPrice = [vipItem`Model.newprice floatValue] * self.arrSelPeople.count;
            //                    //实际金额；
            //                    realPrice = 0;
            //                    //折扣
            //                    zheKou = 1;
            //                    //节省金额
            //                    jieShengPrice = 0;
            totalPrice = [vipPriceModel.amount floatValue];
            yuanZk = vipPriceModel.zk;
            yuanAmount = vipPriceModel.amount;
            if ([vipPriceModel.zk floatValue]== 1) {
                //折扣
                zheKou = 1;
                jieShengPrice = 0;
                realPrice = totalPrice;
            } else {
                zheKou = [vipPriceModel.zk floatValue] * 10;
                realPrice = [vipPriceModel.realAmount floatValue];
                jieShengPrice = totalPrice - realPrice;
            }
            [self showRealPriceLab];
            NSLog(@"aaa");
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
    
    
}


- (UIControl *)retControlBy:(NSString *)titleStr byLabTitle:(UILabel *)withLabTitle byImage:(UIImage *)withImg imgBaySel:(UIImageView *)imgBaySel {
    UIControl *view2 = [[UIControl alloc] initWithFrame:CGRectMake(0, colLastY, self.viewPayType.width, k360Width(44))];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    UIImageView *imgWx = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(10), k360Width(24), k360Width(24))];
    [imgWx setImage:withImg];
    [view2 addSubview:imgWx];
    
    
    [withLabTitle setFrame:CGRectMake(imgWx.right + k360Width(10),  0, self.viewPayType.width, k360Width(44))];
    [withLabTitle setFont:[UIFont fontWithName:@"PingFangSC" size:k360Width(14)]];
    [withLabTitle setText:titleStr];
    [withLabTitle setTextAlignment:NSTextAlignmentLeft];
    [view2 addSubview:withLabTitle];
    
    
    [imgBaySel setFrame:CGRectMake(self.viewPayType.width - k360Width(34 + 16), k360Width(10), k360Width(24), k360Width(24))];
    [imgBaySel setImage:[UIImage imageNamed:@"yuan2_p"]];
    [view2 addSubview:imgBaySel];
    colLastY = view2.bottom + k360Width(2);
    return view2;
}
- (void)initCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel withView:(UIView *)withView isAcc:(BOOL)isAcc   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, 0, withView.width, k360Width(44))];
    viewTemp.tag = 1002;
    [withView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    lblTitle.text = titleStr;
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(withView.width - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
    
    if (withLabel) {
        [withLabel setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), 0, k360Width(250) - accLeft, viewTemp.height)];
        //        [withLabel setNumberOfLines:0];
        //        [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [withLabel setTextAlignment:NSTextAlignmentRight];
        [withLabel setFont:WY_FONTRegular(14)];
        //        [withLabel sizeToFit];
        withLabel.left = withView.width - withLabel.width - k360Width(16) - accLeft;
        //        if (withLabel.height < k360Width(12)) {
        //            withLabel.height = k360Width(12);
        //        }
        //
        //        viewTemp.height = withLabel.bottom + k360Width(16);
        [viewTemp addSubview:withLabel];
        
    }
    
    lblTitle.height = viewTemp.height;
    if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    //    UIImageView *imgLine = [UIImageView new];
    //    [imgLine setBackgroundColor:APPLineColor];
    //    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1,  , 1)];
    //    [viewTemp addSubview:imgLine];
    
}

- (void)btnSubmitAction {
    NSLog(@"点击了提交按钮");
    if (self.arrSelPeople.count <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请添加人员"];
        return;
    }
    if (realPrice > 0 && self.mWY_SendEnrolmentMessageModel.InvoiceName.length <= 0) {
        UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"您确定不开发票?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [tempAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [tempAlert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            isInvoice = NO;
            [self btnGoInfoAction];
        }]];
        [self presentViewController:tempAlert animated:YES completion:nil];
    } else {
        isInvoice = YES;
        [self btnGoInfoAction];
    }
}


- (void)submitFrom{
    if (self.mWY_SendEnrolmentMessageModel == nil ) {
        self.mWY_SendEnrolmentMessageModel = [WY_SendEnrolmentMessageModel new];
    }
    
    self.mWY_SendEnrolmentMessageModel.Amount = [NSString stringWithFormat:@"%.2f",realPrice];
    //        self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans = self.arrSelStudents;
    //0320 -ADD -增加字段-price、serviceType、adviceType
    //        self.mWY_SendEnrolmentMessageModel.price = self.mWY_TraCourseDetailModel.Price;
    //        self.mWY_SendEnrolmentMessageModel.serviceType = self.mWY_TraCourseDetailModel.serviceType;
    //        self.mWY_SendEnrolmentMessageModel.adviceType = self.mWY_TraCourseDetailModel.adviceType;
    self.mWY_SendEnrolmentMessageModel.CGRUserName = self.mUser.realname;
    
    NSMutableArray *traEnrolPersons = [NSMutableArray new];
    for (WY_UserModel *tempUser in self.arrSelPeople) {
        WY_TraEnrolPersonModel *tempTepUser = [WY_TraEnrolPersonModel new];
        tempTepUser.UserGuid = tempUser.UserGuid;
        tempTepUser.UserName = tempUser.realname;
        WY_VipItemModel *vipItemModel = [self.mWY_VipMainModel.orderPrice objectAtIndex:self.selIndex];
        tempTepUser.viplevel = vipItemModel.gmlx;
        [traEnrolPersons addObject:tempTepUser];
    }
    
    self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans = traEnrolPersons;
    
    if (realPrice == 0) {
        self.mWY_SendEnrolmentMessageModel.isInvoice = NO;
    } else {
        self.mWY_SendEnrolmentMessageModel.isInvoice = isInvoice;
        
    }
    self.mWY_SendEnrolmentMessageModel.Isca = @"17";
    NSLog(@"这里提交json:%@",[self.mWY_SendEnrolmentMessageModel toJSONString]);
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:[self.mWY_SendEnrolmentMessageModel toJSONString] forKey:@"orderDetailBean"];
    [[MS_BasicDataController sharedInstance] postWithReturnCode:generateOrder_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            NSLog(@"提交成功");
            self.dicSignUpSuccess = res[@"data"];
            [self yuePay];
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
    }];
    
    
}


- (void)btnGoInfoAction {
    
    //判断是否已同意协议-
    if (![isAgree isEqualToString:@"1"]) {
        //没有同意过- 提示
        [self bindPDFData];
        return;
    }
    //余额支付
    NSLog(@"余额- 是否充足判断");
    [[MS_BasicDataController sharedInstance] postWithReturnCode:getAppCoin_HTTP params:nil jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            //              [SVProgressHUD showSuccessWithStatus:res[@"msg"]];
            NSString *nstotal = @"0";
            if (![res[@"data"] isEqual:[NSNull null]]) {
                if (![res[@"data"][@"total"] isEqual:[NSNull null]]) {
                    nstotal = res[@"data"][@"total"];
                }
            }
            if ([nstotal floatValue] < [self.mWY_SendEnrolmentMessageModel.Amount floatValue]) {
                float difference = abs([nstotal floatValue] - [self.mWY_SendEnrolmentMessageModel.Amount floatValue]);
                //余额不足
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前余额不足，是否去充值?" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }])];
                [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    WY_MyBalanceViewController *tempController = [WY_MyBalanceViewController new];
                    tempController.difference = difference;
                    [self.navigationController pushViewController:tempController animated:YES];
                    
                }])];
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
                //余额支付
                NSString *msgStr = [NSString stringWithFormat:@"确定用余额支付吗？当前余额：%.2f",[nstotal floatValue]];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msgStr preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }])];
                [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self authVerification];
                    
                }])];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求失败，请稍后再试"];
    }];
    
    
}
#pragma mark - 验证TouchID/FaceID
- (void)authVerification {
    
    YZAuthID *authID = [[YZAuthID alloc] init];
    
    [authID yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
        
        if (state == YZAuthIDStateNotSupport) { // 不支持TouchID/FaceID
            NSLog(@"对不起，当前设备不支持指纹/面容ID");
            //            [SVProgressHUD showErrorWithStatus:@"对不起，当前设备不支持指纹/面容ID"];
            [self submitFrom];
        } else if(state == YZAuthIDStateFail) { // 认证失败
            NSLog(@"指纹/面容ID不正确，认证失败");
            [SVProgressHUD showErrorWithStatus:@"指纹/面容ID不正确，认证失败"];
        } else if(state == YZAuthIDStateTouchIDLockout) {   // 多次错误，已被锁定
            NSLog(@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码");
            [SVProgressHUD showErrorWithStatus:@"多次错误，指纹/面容ID已被锁定，请到手机解锁界面输入密码"];
        } else if (state == YZAuthIDStateSuccess) { // TouchID/FaceID验证成功
            NSLog(@"认证成功！");
            [self submitFrom];
        }
        
    }];
}
- (void)yuePay {
    NSLog(@"余额支付");
    //    [btnGoInfo setEnabled:NO];
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:self.dicSignUpSuccess[@"OrderNo"] forKey:@"orderNo"];
    //    [postDic setObject:self.mWY_TraCourseDetailModel.ClassGuid forKey:@"ClassGuid"];
    //    [postDic setObject:self.mWY_TraCourseDetailModel.Title forKey:@"detailText"];
    if (self.selIndex == 0) {
        
        [postDic setObject:@"普通会员" forKey:@"detailText"];
        
    } else if (self.selIndex == 1) {
        [postDic setObject:@"高级会员" forKey:@"detailText"];
    } else {
        [postDic setObject:@"超级会员" forKey:@"detailText"];
    }
    
    
    WY_VipItemModel *vipItemModel = [self.mWY_VipMainModel.orderPrice objectAtIndex:self.selIndex];

    
    WY_VipOrderModel *tempModel = [WY_VipOrderModel new];
    tempModel.traEnrolPersonBeans = self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans;
    tempModel.huiyuanVipXx = [WY_HuiyuanVipXxModel new];
    tempModel.huiyuanVipXx.infoType = self.isOpen;
    tempModel.huiyuanVipXx.infoCount = [NSString stringWithFormat:@"%zd",self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans.count];
    tempModel.huiyuanVipXx.price = vipItemModel.newprice;
    tempModel.huiyuanVipXx.zk = yuanZk;
    tempModel.huiyuanVipXx.reallPrice = [NSString stringWithFormat:@"%.2f",realPrice];
    tempModel.huiyuanVipXx.totalPrice = yuanAmount;
    WY_TraEnrolPersonModel *tempFristUser = [self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans firstObject];
    tempModel.huiyuanVipXx.vipType = tempFristUser.viplevel;
    
    NSMutableArray *usernames = [NSMutableArray new];
    NSMutableArray *userguids = [NSMutableArray new];
    
    for (WY_TraEnrolPersonModel *tempEnrPerModel in self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans) {
        [usernames addObject: tempEnrPerModel.UserName];
        [userguids addObject: tempEnrPerModel.UserGuid];
    }
    tempModel.huiyuanVipXx.userInfo = [userguids componentsJoinedByString:@","];
    tempModel.huiyuanVipXx.userNameInfo = [usernames componentsJoinedByString:@","];
    NSLog(@"json:%@",[tempModel toJSONString]);
    [[MS_BasicDataController sharedInstance] postWithReturnCode:appCoinpayVIP_HTTP params:postDic jsonData:[tempModel toJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            NSLog(@"购买VIP成功");
            [SVProgressHUD showSuccessWithStatus:res[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
            //                 [btnGoInfo setEnabled:YES];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        //           [btnGoInfo setEnabled:YES];
    }];
    
}

- (void)bindPDFData {
    //    参数String danWeiName, String vipLevel, String userName
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:@(self.selIndex + 1) forKey:@"vipLevel"];
    if (self.mUser.DanWeiName) {
        [dicPost setObject:self.mUser.DanWeiName forKey:@"danWeiName"];
    } else {
        [dicPost setObject:@"" forKey:@"danWeiName"];
    }
    if (self.mUser.realname) {
        [dicPost setObject:self.mUser.realname forKey:@"userName"];
    } else {
        [dicPost setObject:@"" forKey:@"userName"];
    }
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:CreatePdf_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        self.pdfUrlStr = res[@"data"];
        [self bindPDFView];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"PDF生成失败"];
    }];
    
    
}

- (void)bindPDFView {
    
    NSString *titleStr = self.title;
    
    self.title = @"会员服务协议";
    //才 跳转 协议
    pdfView = [UIView new];
    [pdfView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.view addSubview: pdfView];
    [pdfView setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    
    NSString *pdfurl = [self.pdfUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pdfurl]]];
    [pdfView addSubview:webview];
    
    btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, webview.bottom, kScreenWidth / 2, k360Width(50))];
    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2, webview.bottom, kScreenWidth / 2, k360Width(50))];
    [btnLeft setTitle:@"拒 绝" forState:UIControlStateNormal];
    [btnRight setTitle:@"同 意" forState:UIControlStateNormal];
    [btnLeft setBackgroundColor:HEXCOLOR(0xFE5238)];
    [btnRight setBackgroundColor:MSTHEMEColor];
    
    [btnLeft.titleLabel setFont:WY_FONTMedium(16)];
    [btnRight.titleLabel setFont:WY_FONTMedium(16)];
    
    [btnLeft setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [btnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [btnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [pdfView addSubview:btnLeft];
    [pdfView addSubview:btnRight];
    [btnLeft addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSLog(@"拒绝");
        self.title = titleStr;
        isAgree = @"0";
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        [dicPost setObject:pdfurl forKey:@"url"];
        [[MS_BasicDataController sharedInstance] postWithReturnCode:deletePDF_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
            [pdfView setHidden:YES];
        } failure:^(NSError *error) {
            [pdfView setHidden:YES];
        }];
        
    }];
    
    [btnRight addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.title = titleStr;
        isAgree = @"1";
        [pdfView setHidden:YES];
        [self btnGoInfoAction];
    }];
    
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
