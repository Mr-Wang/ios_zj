//
//  WY_NationalNodesViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2024/1/23.
//  Copyright © 2024 王杨. All rights reserved.
//

#import "WY_NationalNodesViewController.h"
#import "WY_NNNewOperationRecordViewController.h"

@interface WY_NationalNodesViewController (){
    int lastY;
    
}
//审核状态
@property (nonatomic , strong) UILabel *lblTop;
@property (nonatomic , strong) UILabel *lblZp1;
@property (nonatomic , strong) UILabel *lblZp2;
@property (nonatomic , strong) UILabel *lblIsGJ;
@property (nonatomic , strong) UILabel *lblIsNew;
@property (nonatomic , strong) UILabel *lblGJExamine;//国家节点审核状态
@property (nonatomic , strong) UILabel *lblNewExamine;//国家节点审核状态

@property (nonatomic , strong) UIView *viewTop;
@property (nonatomic , strong) UIButton *btnSubmit;

@property (nonatomic , strong) UIScrollView *mScrollView;
@property (nonatomic, strong) WY_UserModel *mUser;
@property (nonatomic , strong) NSMutableDictionary *dicData;

@end

@implementation WY_NationalNodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新机制及国家节点库专家";
    [self makeUI];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    [self dataSource];
    
}
- (void)makeUI {
//    [self initTopView];
    
    [self.view setBackgroundColor:HEXCOLOR(0xF1F1F1)];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight  - JCNew64 - k360Width(55) - JC_TabbarSafeBottomMargin)];
    [self.view addSubview:self.mScrollView];
    
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k375Width(25), self.mScrollView.bottom, k375Width(326), k360Width(44))];
    [self.btnSubmit setTitle:@"提交" forState:UIControlStateNormal];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSubmit];
    
    
    UIButton *cancleButton = [[UIButton alloc] init];
    cancleButton.frame = CGRectMake(0, 0, 44, 44);
    [cancleButton setTitle:@"审核记录" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:cancleButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)dataSource {
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [dicPost setObject:self.mUser.realname forKey:@"expertName"];
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_getExpertMainEvaluationInformation_HTTP params:nil jsonData:[dicPost mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0) {
            self.dicData = [[NSMutableDictionary alloc] initWithDictionary:res[@"data"]];
            [self bindView];
          } else {
            [self.view makeToast:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self.view makeToast:@"请求失败，请稍后再试"];
        
    }];
}

- (void)initTopView { 
    self.lblTop = [UILabel new];
    [self.lblTop setFrame:CGRectMake(k360Width(6), k360Width(6), kScreenWidth-k360Width(12), k360Width(36))];
    [self.lblTop rounded:k360Width(5)];
    [self.lblTop setBackgroundColor:HEXCOLOR(0xffefdd)];
    [self.lblTop setTextColor:HEXCOLOR(0xFFA360)];
    [self.lblTop setText:@"  审核状态：审核中"];
    [self.view addSubview:self.lblTop];
}


- (void)bindView {
    
    if ([self.dicData[@"newMainProfessionID"] isEqual:[NSNull null]]) {
        //没有设置主评专业，请前往专家信息页去设置；
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您没有设置主评专业，请前往专家信息页去设置" preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];

        return;
    }
        
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    
    [self.mScrollView removeAllSubviews];
    
    self.lblZp1 = [UILabel new];
    self.lblZp2 = [UILabel new];
    self.lblIsGJ = [UILabel new];
    self.lblIsNew = [UILabel new];
      
    self.lblZp2.text = self.dicData[@"newMainProfessionName"];
      
    switch ([self.dicData[@"isxjz"] intValue]) {
        case 0:
            {
                self.lblIsNew.text = @"请选择";
            }
            break;
        case 1:
            {
                self.lblIsNew.text = @"是";
            }
            break;
        case 2:
            {
                self.lblIsNew.text = @"否";
            }
            break;
            
        default:
            break;
    }
    
    switch ([self.dicData[@"isgj"] intValue]) {
        case 0:
            {
                self.lblIsGJ.text = @"请选择";
            }
            break;
        case 1:
            {
                self.lblIsGJ.text = @"是";
            }
            break;
        case 2:
            {
                self.lblIsGJ.text = @"否";
            }
            break;
            
        default:
            break;
    }
    
    
    lastY = k360Width(5);
     
    [self initCellTitle:@"新专业主评：" byLabel:self.lblZp2 isAcc:NO withBlcok:nil];
    
    lastY +=  k360Width(16);
    
    [self initCellTitle:@"是否申请成为新机制专家：" byLabel:self.lblIsNew isAcc:YES withBlcok:^{
        if ([self.dicData[@"newMechanismStatus"] intValue] != 0 &&  [self.dicData[@"newMechanismStatus"] intValue] != 4 && [self.dicData[@"isxjz"] intValue] == 2 ){
            [SVProgressHUD showErrorWithStatus:@"当前状态不可修改"];
            return;
            }
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否申请成为新机制专家" preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.lblIsNew.text = @"是";
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.lblIsNew.text = @"否";
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
    }];
    
    self.lblNewExamine = [UILabel new];
    [self.lblNewExamine setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.lblNewExamine setBackgroundColor:[UIColor whiteColor]];
    [self.lblNewExamine setNumberOfLines:0];
    [self.lblNewExamine setLineBreakMode:NSLineBreakByWordWrapping];
    [self.mScrollView addSubview:self.lblNewExamine];
    
    //    当前状态：编辑中0、市级待核验1、省级待核验2、审核通过3、审核拒绝4
    NSString * newStatusStr = @"";
    switch ([self.dicData[@"newMechanismStatus"] intValue]) {
        case 0:
        {
            newStatusStr = @"当前状态：编辑中";
        }
            break;
        case 1:
        {
            newStatusStr = @"当前状态：市级待核验";
        }
            break;
        case 2:
        {
            newStatusStr = @"当前状态：省级待核验";
        }
            break;
            
        case 3:
        {
            newStatusStr = @"当前状态：审核通过";
        }
            break;
            
        case 4:
        {
            newStatusStr = [NSString stringWithFormat:@"当前状态：审核拒绝\n拒绝原因：%@",self.dicData[@"newMechanismContent"]];
        }
            break;
            
        default:
            break;
    }
    NSMutableAttributedString *attNewExamine = [[NSMutableAttributedString alloc] initWithString:newStatusStr];
    [attNewExamine setYy_headIndent:k360Width(16)];
    [attNewExamine setYy_firstLineHeadIndent:k360Width(16)];
    [attNewExamine setYy_lineSpacing:k360Width(8)];
    [attNewExamine setYy_font:WY_FONTMedium(12)];
    [self.lblNewExamine setAttributedText:attNewExamine];
    [self.lblNewExamine sizeToFit];
    self.lblNewExamine.height += k360Width(16);
    self.lblNewExamine.width = kScreenWidth;
    if ([self.dicData[@"newMechanismStatus"] isEqual:[NSNull null]]) {
        [self.lblNewExamine setHidden:YES];
        lastY += k360Width(16);
    } else {
        [self.lblNewExamine setHidden:NO];
        lastY = self.lblNewExamine.bottom + k360Width(16);
    }
    
    
    [self initCellTitle:@"是否申请成为国家节点库专家：" byLabel:self.lblIsGJ isAcc:YES withBlcok:^{
        
        if ([self.dicData[@"nationalNodeStatus"] intValue] != 0 &&  [self.dicData[@"nationalNodeStatus"] intValue] != 4 && [self.dicData[@"isgj"] intValue] == 2 ){
            [SVProgressHUD showErrorWithStatus:@"当前状态不可修改"];
            return;
            }
     
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否申请成为国家节点库专家" preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.lblIsGJ.text = @"是";
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.lblIsGJ.text = @"否";
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertControl animated:YES completion:nil];
    }];
    
    self.lblGJExamine = [UILabel new];
    [self.lblGJExamine setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.lblGJExamine setBackgroundColor:[UIColor whiteColor]];
    [self.mScrollView addSubview:self.lblGJExamine];
    
    //    当前状态：编辑中0、市级待核验1、省级待核验2、审核通过3、审核拒绝4
    NSString * gjStatusStr = @"";
    switch ([self.dicData[@"nationalNodeStatus"] intValue]) {
        case 0:
        {
            gjStatusStr = @"当前状态：编辑中";
        }
            break;
        case 1:
        {
            gjStatusStr = @"当前状态：市级待核验";
        }
            break;
        case 2:
        {
            gjStatusStr = @"当前状态：省级待核验";
        }
            break;
            
        case 3:
        {
            gjStatusStr = @"当前状态：审核通过";
        }
            break;
            
        case 4:
        {
            gjStatusStr = [NSString stringWithFormat:@"当前状态：审核拒绝\n拒绝原因：%@",self.dicData[@"nationalNodeApprovalcontent"]];
        }
            break;
            
        default:
            break;
    }
    
    NSMutableAttributedString *attGJExamine = [[NSMutableAttributedString alloc] initWithString:gjStatusStr];
    [attGJExamine setYy_headIndent:k360Width(16)];
    [attGJExamine setYy_firstLineHeadIndent:k360Width(16)];
    [attGJExamine setYy_lineSpacing:k360Width(8)];
    [attGJExamine setYy_font:WY_FONTMedium(12)];
    [self.lblGJExamine setAttributedText:attGJExamine];
 
    if ([self.dicData[@"nationalNodeStatus"] isEqual:[NSNull null]]) {
        [self.lblGJExamine setHidden:YES];
        lastY += k360Width(16);
    } else {
        [self.lblGJExamine setHidden:NO];
        lastY = self.lblGJExamine.bottom + k360Width(16);
    }
    
}


- (void)initCellTitle:(NSString *)titleStr byLabel:(UILabel *)withLabel isAcc:(BOOL)isAcc   withBlcok:(void (^)(void))withBlcok {
    UIControl *viewTemp = [UIControl new];
    [viewTemp setBackgroundColor:[UIColor whiteColor]];
    [viewTemp setFrame:CGRectMake(0, lastY, kScreenWidth, k360Width(44))];
    [self.mScrollView addSubview:viewTemp];
    
    UILabel *lblTitle = [UILabel new];
    [lblTitle setTextColor:[UIColor grayColor]];
    
    [lblTitle setFrame:CGRectMake(k360Width(16), 0, k360Width(280), viewTemp.height)];
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
    
    
    [withLabel setFrame:CGRectMake(k360Width(16), lblTitle.bottom, kScreenWidth - k360Width(32), k360Width(44))];
    [withLabel setNumberOfLines:0];
    [withLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [withLabel setFont:WY_FONTRegular(14)];
    [withLabel sizeToFit];
 
    if (withLabel.height < k360Width(12)) {
        withLabel.height = k360Width(12);
    }
    
    viewTemp.height = withLabel.bottom + k360Width(16);
    [viewTemp addSubview:withLabel];
    
//    lblTitle.height = viewTemp.height;
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


- (void)navRightAction {
    NSLog(@"操作记录");
    WY_NNNewOperationRecordViewController *tempController = [WY_NNNewOperationRecordViewController new];
    [self.navigationController pushViewController:tempController animated:YES];
}


- (void)btnSubmitAction {
    //审核状态  编辑中和审核拒绝可以改， 其他不能改；
//    当前状态：编辑中0、市级待核验1、省级待核验2、审核通过3、审核拒绝4
    
    if ([self.dicData[@"nationalNodeStatus"] intValue] != 0 &&  [self.dicData[@"nationalNodeStatus"] intValue] != 4 && [self.dicData[@"newMechanismStatus"] intValue] != 0 &&  [self.dicData[@"newMechanismStatus"] intValue] != 4 ) {
        [SVProgressHUD showErrorWithStatus:@"当前状态不可提交"];
        return;
    }
    
    NSLog(@"点击了提交订单");
    if ([self.lblIsGJ.text isEqualToString:@"请选择"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择是否申请成为国家节点库专家"];
        return;
    }
    if ([self.lblIsNew.text isEqualToString:@"请选择"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择是否申请成为新机制专家"];
        return;
    }
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:self.mUser.idcardnum forKey:@"idCard"];
    [dicPost setObject:self.mUser.realname forKey:@"expertName"];
    [dicPost setObject:[self.lblIsGJ.text isEqualToString:@"是"]?@"1":@"2" forKey:@"isgj"];
    [dicPost setObject:[self.lblIsNew.text isEqualToString:@"是"]?@"1":@"2" forKey:@"isxjz"];
    [dicPost setObject:self.dicData[@"oldMainProfessionID"] forKey:@"oldMainProfessionID"];
    [dicPost setObject:self.dicData[@"newMainProfessionID"] forKey:@"newMainProfessionID"];
    [dicPost setObject:self.dicData[@"newMechanismStatus"] forKey:@"newMechanismStatus"];
    [dicPost setObject:self.dicData[@"nationalNodeStatus"] forKey:@"nationalNodeStatus"];
   
    
    
    [[MS_BasicDataController sharedInstance] postWithReturnCode:zj_insertNationalNodesOrNewMechanism_HTTP params:nil jsonData:[dicPost mj_JSONData] showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 200) {
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
