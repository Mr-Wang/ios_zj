//
//  WY_AvoidanceUnitViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2021/4/28.
//  Copyright © 2021 王杨. All rights reserved.
//

#import "WY_AvoidanceUnitViewController.h"
#import "WY_ZJCompanyModel.h"

@interface WY_AvoidanceUnitViewController () {
    UIView *viewZdhb;
    int lastY;
}
@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic , strong) UIButton *btnSubmit;
@property (nonatomic , strong) NSMutableArray *arrZdhb;
@property (nonatomic , strong) NSMutableArray *voidCompany;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_AvoidanceUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.主动申请回避单位
    [self makeUI];
    [self dataBind];
}
- (void)makeUI {
    self.title = @"回避单位";
    [self.view setBackgroundColor:HEXCOLOR(0xF4F5F9)];

    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"保  存" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];

    
    viewZdhb = [[UIView alloc] initWithFrame:CGRectMake(0, k360Width(10), kScreenWidth, k360Width(100))];
    [viewZdhb setBackgroundColor:[UIColor whiteColor]];
    UILabel *lblZdhb = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), 0, kScreenWidth - k360Width(32), k360Width(80))];
    lblZdhb.tag = 1001;
    NSMutableAttributedString *attStr0 = [[NSMutableAttributedString alloc] initWithString:@"单独维护回避单位信息时保存即可，不必提交专家信息审核，以免给您造成不必要的麻烦。\n"];
    [attStr0 setYy_font:WY_FONTMedium(14)];
    [attStr0 setYy_color:[UIColor redColor]];
    
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"主动申请回避单位:"];
    [attStr1 setYy_font:WY_FONTMedium(14)];
    [attStr1 setYy_color:[UIColor blackColor]];
    [attStr0 appendAttributedString:attStr1];
     lblZdhb.attributedText = attStr0;
    [lblZdhb setNumberOfLines:0];
    [viewZdhb addSubview:lblZdhb];
     [self.mScrollView addSubview:viewZdhb];

    
}


- (void)dataBind {
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:self.mUser.idcardnum forKey:@"idCard"];
     NSString *urlStr = zj_expertGetActiveAvoidanceCompany_HTTP;
    
        [[MS_BasicDataController sharedInstance] postWithURL:urlStr params:postDic jsonData:nil showProgressView:YES success:^(id successCallBack) {
        NSLog(@"获取数据成功");
        if (successCallBack) {
             self.arrZdhb =  [[NSMutableArray alloc] initWithArray:[NSArray yy_modelArrayWithClass:[WY_ZJCompanyModel class] json:successCallBack]];

            [self bindView];
         }
     } failure:^(NSString *failureCallBack) {
         [SVProgressHUD showErrorWithStatus:failureCallBack];
     } ErrorInfo:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"获取数据失败，请稍后再试"];
    }];
    
     
}

- (void)bindView {
//    self.arrZdhb = [[NSMutableArray alloc] initWithArray:self.mWY_ExpertMessageModel.voidCompany];

    [self initviewZdhb];
}

- (void)initviewZdhb {
    viewZdhb.top =  k360Width(10);
    for (UIView *viewIn in viewZdhb.subviews) {
        if (viewIn.tag != 1001) {
            [viewIn removeFromSuperview];
        }
    }
    int lastYZdhb = k360Width(80);
    for (WY_ZJCompanyModel *comModel in self.arrZdhb) {
        UIView *zdhbViewItem = [[UIView alloc] initWithFrame:CGRectMake(0, lastYZdhb, kScreenWidth, k360Width(44))];
        UIButton *btnDel = [UIButton new];
        [btnDel setFrame:CGRectMake(k360Width(16), k360Width(10), k360Width(22), k360Width(22))];
        [btnDel setImage:[UIImage imageNamed:@"0622_del"] forState:UIControlStateNormal];
        [btnDel setImage:[UIImage imageNamed:@"0622_del"] forState:UIControlStateSelected];
        [zdhbViewItem addSubview:btnDel];
        [viewZdhb addSubview:zdhbViewItem];
        UITextField *lblName = [UITextField new];
        [lblName setFrame:CGRectMake(btnDel.right + k360Width(5), 0, kScreenWidth - lblName.right - k360Width(10), k360Width(44))];
        lblName.text = comModel.companyName;
        lblName.placeholder = @"请输入主动回避单位名称";
        [lblName addBlockForControlEvents:UIControlEventEditingChanged block:^(id  _Nonnull sender) {
            NSLog(@"这里是输入后内容：%@",lblName.text);
            comModel.companyName = lblName.text;
            comModel.expertIdCard = self.mUser.idcardnum;
        }];
        [btnDel addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (btnDel.selected) {
                NSLog(@"调接口删除");
//                [SVProgressHUD showErrorWithStatus:@"不能删除已设置的回避单位"];
                 
                NSMutableDictionary *postDicZZ = [NSMutableDictionary new];
                [postDicZZ setObject:comModel.id forKey:@"id"];
                [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_expertDeleteActiveAvoidanceCompany_HTTP params:postDicZZ jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
                    if ([code integerValue] == 0) {
                        [self.arrZdhb removeObject:comModel];
                        [self initviewZdhb];
                    } else {
                        [self.view makeToast:res[@"msg"]];
                    }
                } failure:^(NSError *error) {
                    [self.view makeToast:@"请求失败，请稍后再试"];
                    
                }];
                
                return ;
              }
            [self.arrZdhb removeObject:comModel];
            [self initviewZdhb];
        }];
        
        [zdhbViewItem addSubview:lblName];
        if ([comModel.isDel isEqualToString:@"1"]) {
            [btnDel setSelected:NO];
            [lblName setUserInteractionEnabled:YES];
        } else {
            [btnDel setSelected:YES];
            [lblName setUserInteractionEnabled:NO];
        }
        lastYZdhb = zdhbViewItem.bottom;
    }
    
    UIButton *btnAddZdhb = [[UIButton alloc] initWithFrame:CGRectMake(0, lastYZdhb + k360Width(10), k375Width(130), k375Width(32))];
    btnAddZdhb.centerX = viewZdhb.centerX;
    
    [btnAddZdhb setTitle:@"新增回避单位" forState:UIControlStateNormal];
    [btnAddZdhb setImage:[UIImage imageNamed:@"0615_AddMj"] forState:UIControlStateNormal];
    [btnAddZdhb setTitleColor:HEXCOLOR(0x448eee) forState:UIControlStateNormal];
    [btnAddZdhb rounded:k375Width(32/4) width:1 color:HEXCOLOR(0x448eee)];
    [btnAddZdhb.titleLabel setFont:WY_FONT375Medium(17)];
    [btnAddZdhb addTarget:self action:@selector(btnAddZdhbAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewZdhb addSubview:btnAddZdhb];
    
    viewZdhb.height = btnAddZdhb.bottom + k375Width(10);
    
    
//    viewYDW.top = viewZdhb.bottom + k360Width(10);
    [self.mScrollView setContentSize:CGSizeMake(0, viewZdhb.bottom + k360Width(10))];

}

- (void)btnAddZdhbAction:(UIButton *)btnSender {
    WY_ZJCompanyModel *comModel = [WY_ZJCompanyModel new];
    comModel.companyName = @"";
    comModel.isDel = @"1";
    comModel.expertIdCard = self.mUser.idcardnum;
    [self.arrZdhb addObject:comModel];
    [self initviewZdhb];
}
- (void)initCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel isAcc:(BOOL)isAcc   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setTextColor:[UIColor grayColor]];

    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(200), viewTemp.height)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"*"];
    [attStr setYy_color:[UIColor redColor]];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attStr appendAttributedString:attStr1];
    lblTitle.attributedText = attStr;
    
    [lblTitle setFont:WY_FONTMedium(14)];
    [viewTemp addSubview:lblTitle];
    
    int accLeft = 0;
    UIImageView *imgAcc;
    if (isAcc) {
        imgAcc = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(22 + 16), k360Width(44 - 10) / 2, k360Width(22), k360Width(22))];
        [imgAcc setImage:[UIImage imageNamed:@"accup"]];
        [viewTemp addSubview:imgAcc];
        accLeft = imgAcc.width + k360Width(5);
    }
    
    
    [withLabel setFrame:CGRectMake(viewTemp.width - k360Width(250 + 16), k360Width(16), k360Width(250) - accLeft, k360Width(44))];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setTextAlignment:NSTextAlignmentRight];
    [withLabel setFont:WY_FONTRegular(14)];
    [withLabel sizeToFit];
    withLabel.left = kScreenWidth - withLabel.width - k360Width(16) - accLeft;
    if (withLabel.height < k360Width(12)) {
        withLabel.height = k360Width(12);
    }
    
    viewTemp.height = withLabel.bottom + k360Width(16);
    [viewTemp addSubview:withLabel];
    
    lblTitle.height = viewTemp.height;
    if (isAcc) {
        imgAcc.top = (viewTemp.height -imgAcc.height) / 2;
        [viewTemp addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            if (withBlcok) {
                withBlcok();
            }
        }];
    }
    UIImageView *imgLine = [UIImageView new];
    [imgLine setBackgroundColor:APPLineColor];
    [imgLine setFrame:CGRectMake(0, viewTemp.height - 1, kScreenWidth, 1)];
    [viewTemp addSubview:imgLine];
    lastY = viewTemp.bottom;
    
}

- (void)btnSubmitAction {
    //添加列表
//
    /**
     *   专家证件号
     */
//    private String expertIdCard;

    /**
     *   单位名称
     */
//    private String companyName;


    for (WY_ZJCompanyModel *cjCoModel in self.arrZdhb) {
       if ([cjCoModel.companyName isEqualToString:@""]) {
             [SVProgressHUD showErrorWithStatus:@"请在主动回避单位中填写内容"];
             return;

        }
    }
    

    NSMutableArray *arrAddZdhb = [NSMutableArray new];
    for (WY_ZJCompanyModel *tempModel in self.arrZdhb) {
        
        if ([tempModel.isDel isEqualToString:@"1"]) {
            [arrAddZdhb addObject:tempModel];
        }
        
        int i =0;
        for (WY_ZJCompanyModel *tempModelA in self.arrZdhb) {
            if ([tempModel.companyName isEqualToString:tempModelA.companyName]) {
                i++;
            }
        }
        if (i >= 2) {
            [SVProgressHUD showErrorWithStatus:@"请删除重复回避单位"];
            return;
        }
        
    }
    if (arrAddZdhb.count <= 0) {
//        [SVProgressHUD showErrorWithStatus:@"请添加主动回避单位"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
     
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_expertUpdateActiveAvoidanceCompany_HTTP params:nil jsonData:[arrAddZdhb yy_modelToJSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            [self.view makeToast:res[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
         } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
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
