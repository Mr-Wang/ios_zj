//
//  WY_SignUpViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/12.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SignUpViewController.h"
#import "WY_SignUpTopTableViewCell.h"
#import "WY_SignUpStudentItemTableViewCell.h"
#import "WY_TraEnrolPersonModel.h"
#import "WY_SendEnrolmentMessageModel.h"
#import "WY_AddPeoplelViewController.h"
#import "WY_SelectInvoiceViewController.h"
#import "WY_SignUpSuccessViewController.h"
#import "WY_OrderPayViewController.h"
#import "WY_OTD_JYXH_TableViewCell.h"
#import "ActionSheetStringPicker.h"
#import "SLCustomActivity.h"


@interface WY_SignUpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isInvoice;
    BOOL onlySelf;
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WY_OTD_JYXH_TableViewCell *jyxhCell;
@property (nonatomic, strong) NSMutableArray *arrSelStudents;
@property (nonatomic, strong) WY_SendEnrolmentMessageModel *mWY_SendEnrolmentMessageModel;
@property (nonatomic, strong) YYLabel *lblPriceSum;
@property (nonatomic, strong) UIButton *btnSubmit;
// 0不需要附件 1需要附件 标识次课程是否需要上传附件
@property (nonatomic, strong) NSString *isNeedAttachment;
@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];
    //usertype == 5 || orgtype == 3 //注册用户-只能报自己
// if ([self.mUser.UserType isEqualToString:@"5"] || [self.mUser.orgtype isEqualToString:@"3"]) {
     onlySelf = YES;
// } else {
//     onlySelf = NO;
// }
    
    //先写死 - 需要传附件的；
    self.isNeedAttachment = self.mWY_TraCourseDetailModel.isNeedAttachment;
     
    [self makeUI];
    [self dataBind];
}
- (void)makeUI {
    self.title = @"填写报名订单";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - k360Width(50) - JC_TabbarSafeBottomMargin)];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, kScreenWidth, k360Width(50))];
    UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,kScreenWidth, 1)];
    [imgLine setBackgroundColor:APPLineColor];
    [viewBottom addSubview:imgLine];
    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(7), kScreenWidth - k360Width(32), k360Width(44-8))];
    self.lblPriceSum = [[YYLabel alloc] initWithFrame:CGRectMake(0, k360Width(10), self.btnSubmit.left - k360Width(10), k360Width(30))];
    self.lblPriceSum.textAlignment = NSTextAlignmentRight;
    [self.lblPriceSum setHidden:YES];
    [self.btnSubmit.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnSubmit setTitle:@"立即报名" forState:UIControlStateNormal];
    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit rounded:k360Width(44)/8];
    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [viewBottom addSubview:self.btnSubmit];
    [viewBottom addSubview:self.lblPriceSum];
    [self.view addSubview:viewBottom];
    
    
}
/// <#Description#>
- (void)dataBind {
    self.arrSelStudents = [[NSMutableArray alloc] init];
    self.mUser = [[MS_BasicDataController sharedInstance].user yy_modelCopy];

    WY_TraEnrolPersonModel *trpModel = [WY_TraEnrolPersonModel new];
    trpModel.baomingidcard = self.mUser.idcardnum;
    trpModel.UserName = self.mUser.realname;
    trpModel.Phone = self.mUser.LoginID;
    trpModel.DanWeiName = self.mUser.DanWeiName;
    trpModel.isfree = @"1";
    trpModel.ClassGuid = self.mWY_TraCourseDetailModel.ClassGuid;
    //是否诚信库人员
    trpModel.isruku = @"否";
     NSInteger zjsex =  [self genderOfIDNumber:self.mUser.idcardnum];
            // 1男 2 女
           if (zjsex == 2) {
               trpModel.sex = @"2";
           } else {
               trpModel.sex = @"1";
           }
    trpModel.job = @"";
    trpModel.WeiXin = @"";
    trpModel.email = @"";
    [self.arrSelStudents addObject:trpModel];
    
    [self.tableView reloadData];
    [self calculatePriceSum];
}

- (NSInteger)genderOfIDNumber:(NSString *)IDNumber
{
      //  记录校验结果：0未知，1男，2女
    NSInteger result = 0;
    NSString *fontNumer = nil;
    
    if (IDNumber.length == 15)
    { // 15位身份证号码：第15位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(14, 1)];
 
    }else if (IDNumber.length == 18)
    { // 18位身份证号码：第17位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(16, 1)];
    }else
    { //  不是15位也不是18位，则不是正常的身份证号码，直接返回
        return result;
    }
    
    NSInteger genderNumber = [fontNumer integerValue];
    
    if(genderNumber % 2 == 1)
        result = 1;
    
    else if (genderNumber % 2 == 0)
        result = 2;
    return result;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,kHeight((12+20)*2), MSScreenW, kHeight(90)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   // 隐藏系统分割线
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor =MSColor(242, 242, 242);
        _tableView.sectionFooterHeight = k360Width(10);
        _tableView.sectionHeaderHeight = 0.01;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultUITableViewCell"];
        [_tableView registerClass:[WY_SignUpTopTableViewCell class] forCellReuseIdentifier:@"WY_SignUpTopTableViewCell"];

        [_tableView registerClass:[WY_SignUpStudentItemTableViewCell class] forCellReuseIdentifier:@"WY_SignUpStudentItemTableViewCell"];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
           // Fallback on earlier versions
        }

        
    }
    
    return _tableView;
}


#pragma mark - UITableViewDelegate (TableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.arrSelStudents != nil && self.arrSelStudents.count > 0) {
//        return 3;
        return 3 + [self.isNeedAttachment intValue];
    } else {
//        return 2;
        return 2 + [self.isNeedAttachment intValue];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
//        case 1:
//            return 2;
//            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.arrSelStudents.count;
            break;
        case 3:
            return 1;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
                WY_SignUpTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_SignUpTopTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell showCellByItem:self.mWY_TraCourseDetailModel];
            return cell;
        }
            break;
//            case 1:
//            {
//                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
//                cell.backgroundColor = [UIColor clearColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//                if (indexPath.row == 0) {
//                    cell.accessoryType = UITableViewCellAccessoryNone;
//                    cell.textLabel.text = @"支付方式";
//                    cell.detailTextLabel.text = @"在线支付";
//                    UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(43) ,kScreenWidth, 1)];
//                    [imgLine setBackgroundColor:APPLineColor];
//                    [cell addSubview:imgLine];
//                } else if (indexPath.row == 1) {
//                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                    cell.textLabel.text = @"发       票";
//                    if (self.mWY_SendEnrolmentMessageModel.InvoiceName.length > 0) {
//                        cell.detailTextLabel.text = self.mWY_SendEnrolmentMessageModel.InvoiceName;
//                    }
//                }
//                return cell;
//
//            }
//            break;
            case 1:
                   {
                       UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
                       cell.backgroundColor = [UIColor clearColor];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                       cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.textLabel.text = @"报名人员";
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"X%d人",self.arrSelStudents.count];
                       UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(43) ,kScreenWidth, 1)];
                       [imgLine setBackgroundColor:APPLineColor];
                       [cell addSubview:imgLine];

                       return cell;
                   }
            break;
            case 2:
                   {
                           WY_SignUpStudentItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_SignUpStudentItemTableViewCell"];
                       cell.selectionStyle = UITableViewCellSelectionStyleNone;
                       [cell showCellByItem:self.arrSelStudents[indexPath.row]];
                        return cell;
                   }
            break;
        case 3:
        {
            //这里放 一堆附件上传
            self.jyxhCell = [[WY_OTD_JYXH_TableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"WY_OTD_JYXH_TableViewCell"];
            self.jyxhCell.vcSender = self;
            [self.jyxhCell showCell];
            [self.jyxhCell setSelShareBlock:^(NSString * _Nonnull fileName, NSString * _Nonnull fileUrl) {
                NSURL *shareUrl = [NSURL URLWithString:fileUrl];
                NSData *dateImg = [NSData dataWithContentsOfURL:shareUrl];
                NSArray*activityItems =@[shareUrl,fileName,dateImg];
                
                SLCustomActivity * customActivit = [[SLCustomActivity alloc] initWithTitie:@"使用浏览器打开" withActivityImage:dateImg withUrl:shareUrl withType:@"CustomActivity" withShareContext:activityItems];
                NSArray *activities = @[customActivit];

                UIActivityViewController *activityVC = nil;
                if  (MH_iOS13_VERSTION_LATER) {
                    activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil ];//activities
                } else {
                    activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
                } 
                activityVC.modalPresentationStyle = UIModalPresentationFullScreen;
                //弹出分享的页面
                 [self presentViewController:activityVC animated:YES completion:nil];
                 // 分享后回调

                 activityVC.completionWithItemsHandler= ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray*_Nullable returnedItems,NSError*_Nullable activityError) {

                  if(completed) {

                   NSLog(@"completed");

                   //分享成功

                  }else {

                   NSLog(@"cancled");

                   //分享取消

                  }

                 };
            }];
            return self.jyxhCell;
        }
            break;
        default:
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     cell.textLabel.text = @"支付方式";
     cell.detailTextLabel.text = @"在线支付";

    return cell;
}
            break;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
//        case 1:
//        {
//            if (indexPath.row == 1) {
//                if ([self.mWY_TraCourseDetailModel.Price floatValue] == 0) {
//                    [SVProgressHUD showErrorWithStatus:@"免费商品，无需开具发票"];
//                    return;
//                } else {
//                    //跳转到发票页；
//                    WY_SelectInvoiceViewController *tempController = [WY_SelectInvoiceViewController new];
//                    tempController.adviceType = self.mWY_TraCourseDetailModel.adviceType;
//                    tempController.isCanSave = YES;
//                    tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
//                    tempController.saveInvoiceBlock = ^(WY_SendEnrolmentMessageModel * _Nonnull saveModel) {
//                        self.mWY_SendEnrolmentMessageModel = saveModel;
//                        [self.tableView reloadData];
//                    };
//                    [self.navigationController pushViewController:tempController animated:YES];
//                }
//            }
//        }
//            break;
//        case 1:
//            {
//                //添加报名人员
//                if (self.arrSelStudents.count >= self.canGovNum) {
//                    [SVProgressHUD showErrorWithStatus:@"本课程设置了单位人数数量限制，目前已达到上限，下次还有机会学习，感谢您的支持和理解！"];
//                    return;
//                }
//
//                if (self.arrSelStudents.count >= 1 && onlySelf) {
//                    [SVProgressHUD showErrorWithStatus:@"您只能给自己报名，不能添加其他人员"];
//                    return;
//                }
//
//                WY_AddPeoplelViewController *tempController = [WY_AddPeoplelViewController new];
//                tempController.isAddOrUpdate = 1;
//                tempController.onlySelf = onlySelf;
//                tempController.addSuccessBlock = ^(WY_TraEnrolPersonModel * _Nonnull selModel) {
//                    if ([self.mWY_TraCourseDetailModel.Price floatValue] > 0) {
//                        selModel.isfree = @"0";
//                    } else {
//                        selModel.isfree = @"1";
//                    }
//                    selModel.ClassGuid = self.mWY_TraCourseDetailModel.ClassGuid;
//                    for (WY_TraEnrolPersonModel *trpModel in self.arrSelStudents) {
//                        if ([trpModel.baomingidcard isEqualToString:selModel.baomingidcard]) {
//                            [SVProgressHUD showErrorWithStatus:@"报名人员不可重复添加"];
//                            return ;
//                        }
//                    }
//                    [self.arrSelStudents addObject:selModel];
//                    [self calculatePriceSum];
//                    [tableView reloadData];
//                };
//                [self.navigationController pushViewController:tempController animated:YES];
//            }
//            break;
        case 2:
        {
            WY_AddPeoplelViewController *tempController = [WY_AddPeoplelViewController new];
            tempController.isAddOrUpdate = 2;
                tempController.onlySelf = YES;
            tempController.selModel = self.arrSelStudents[indexPath.row];
            tempController.updateSuccessBlock = ^(WY_TraEnrolPersonModel * _Nonnull selModel) {
                [tableView reloadData];
            };
            [self.navigationController pushViewController:tempController animated:YES];

        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     switch (indexPath.section) {
            case 0:
             //订单详情cell
                return k360Width(100);
                break;
//            case 1:
//             //支付方式、发票cell
//                return k360Width(44);
//                break;
            case 1:
             //人员title
                return k360Width(44);
                break;
            case 2:
             //人员列表高度
                return k360Width(80);
                break;
         case 3:
             return k360Width(600);
             break;
            default:
                return 0;
                break;
        }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section > 0) {
        return 0.001;
    }
    return k360Width(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = MSColor(242, 242, 242);
    return view;

}

#pragma mark --左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //第二组可以左滑删除
    if (indexPath.section == 3) {
        //usertype == 5 || orgtype == 3 //注册用户-只能报自己
        return !onlySelf;
    }
    return NO;
}
 
//// 定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//        if (indexPath.section == 3) {
//            [self.arrSelStudents removeObjectAtIndex:indexPath.row];
//            [self calculatePriceSum];
//            [self.tableView reloadData];
// //            NSString *user_no = [self.actor_cpllaboredArray[indexPath.row] valueForKey:@"user_no"];
////            [self fetch_api_Recruit_withdraw:user_no];
//
//        }
//    }
//}
//
//// 修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
 #pragma mark - 计算总价-并刷新列表
- (void)calculatePriceSum {
    float priceSum = [self.mWY_TraCourseDetailModel.Price floatValue] * self.arrSelStudents.count;
    NSLog(@"总价：%.2f",priceSum);
    NSMutableAttributedString *attPriceStr = [[NSMutableAttributedString alloc] initWithString:@"合计："];
    [attPriceStr setYy_font:WY_FONTRegular(16)];
    [attPriceStr setYy_color:HEXCOLOR(0x3C3B39)];
 
    NSMutableAttributedString *attPriceStr2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",priceSum]];
    [attPriceStr2 setYy_color:HEXCOLOR(0xD94C5A)];
     [attPriceStr2 setYy_font:WY_FONTRegular(20)];
    [attPriceStr setYy_alignment:NSTextAlignmentRight];
    [attPriceStr appendAttributedString:attPriceStr2];
    self.lblPriceSum.attributedText = attPriceStr;
 }
#pragma mark --点击了提交按钮
- (void)btnSubmitAction {
    NSLog(@"点击了提交按钮");
//    if (self.arrSelStudents.count <= 0) {
//        [SVProgressHUD showErrorWithStatus:@"请添加报名人员"];
//        return;
//    }
//    if ([self.mWY_TraCourseDetailModel.Price floatValue] > 0 && self.mWY_SendEnrolmentMessageModel.InvoiceName.length <= 0) {
//        UIAlertController *tempAlert = [UIAlertController alertControllerWithTitle:@"您确定不开发票?" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [tempAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//        [tempAlert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            isInvoice = NO;
//            [self submitFrom];
//        }]];
//        [self presentViewController:tempAlert animated:YES completion:nil];
//    } else {
//        isInvoice = YES;
//        [self submitFrom];
//    }
    isInvoice = NO;
    
    //这里判断 是否是协会报名的， 如果是 需要判断附件非空
    if ([self.isNeedAttachment intValue] == 1) {
        if (self.jyxhCell.arrEttachmentUrl.count <= 0) {
            NSLog(@"没有上传附件");
            [SVProgressHUD showErrorWithStatus:@"请上传报名表附件"];
            return;
        }
    }
    [self submitFrom];
}


- (void)submitFrom{
    if (self.mWY_SendEnrolmentMessageModel == nil ) {
        self.mWY_SendEnrolmentMessageModel = [WY_SendEnrolmentMessageModel new];
    }
    if ([self.isNeedAttachment intValue] == 1) {
        WY_TraEnrolPersonModel *trpModel = self.arrSelStudents[0];
        trpModel.ettachmentUrl =  [self.jyxhCell.arrEttachmentUrl componentsJoinedByString:@","];
        
        if (self.jyxhCell.arrEttachmentWorkUrl.count > 0) {
            trpModel.ettachmentWorkUrl =  [self.jyxhCell.arrEttachmentWorkUrl componentsJoinedByString:@","];
        } else {
            trpModel.ettachmentWorkUrl =  @"";
        }
        if (self.jyxhCell.arrEttachmentAwardUrl.count > 0) {
            trpModel.ettachmentAwardUrl =  [self.jyxhCell.arrEttachmentAwardUrl componentsJoinedByString:@","];        } else {
                trpModel.ettachmentAwardUrl = @"";
            }
        if (self.jyxhCell.arrEttachmentZhiCUrl.count > 0) {
            trpModel.ettachmentZhiCUrl =  [self.jyxhCell.arrEttachmentZhiCUrl componentsJoinedByString:@","];
        } else {
            trpModel.ettachmentZhiCUrl = @"";
        }
    }
    self.mWY_SendEnrolmentMessageModel.invoiceoftype = @"0";
    self.mWY_SendEnrolmentMessageModel.InvoiceType = @"0";
    float priceSum = [self.mWY_TraCourseDetailModel.Price floatValue] * self.arrSelStudents.count;
    self.mWY_SendEnrolmentMessageModel.Amount = [NSString stringWithFormat:@"%.2f",priceSum];
    self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans = self.arrSelStudents;
    //0320 -ADD -增加字段-price、serviceType、adviceType
    self.mWY_SendEnrolmentMessageModel.price = self.mWY_TraCourseDetailModel.Price;
    self.mWY_SendEnrolmentMessageModel.serviceType = self.mWY_TraCourseDetailModel.serviceType;
    self.mWY_SendEnrolmentMessageModel.adviceType = self.mWY_TraCourseDetailModel.adviceType;
    self.mWY_SendEnrolmentMessageModel.CGRUserName = self.mUser.realname;
    if ([self.mWY_TraCourseDetailModel.Price floatValue] == 0) {
               self.mWY_SendEnrolmentMessageModel.isInvoice = NO;
           } else {
               self.mWY_SendEnrolmentMessageModel.isInvoice = isInvoice;
           
           }
    NSLog(@"这里提交json:%@",[self.mWY_SendEnrolmentMessageModel toJSONString]);
    
    //
//    WY_SignUpSuccessViewController *tempController = [WY_SignUpSuccessViewController new];
//    tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
//    tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
//    tempController.dicSignUpSuccess = @{@"optTime":@"2020-02-19 15:37:58",@"orderGuid":@"202002191537583785",@"orderId":@"CLASSAPPXX202002191537589138"};
//    [self.navigationController pushViewController:tempController animated:YES];

 
//    NSLog(@"测试功能 ----  上线需要注释掉- ");
//    WY_OrderPayViewController *tempController = [WY_OrderPayViewController new];
//    tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
//    tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
//    tempController.dicSignUpSuccess = @{@"optTime":@"2020-02-19 15:37:58",@"orderGuid":@"202002191537583785",@"orderId":@"CLASSAPPXX202002191537589138"};
//    [self.navigationController pushViewController:tempController animated:YES];
//    return;
//    //
    
    NSMutableDictionary *dicPost = [NSMutableDictionary new];
    [dicPost setObject:[self.mWY_SendEnrolmentMessageModel toJSONString] forKey:@"orderDetailBean"];
     [[MS_BasicDataController sharedInstance] postWithReturnCode:traEnrolGenerate_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
        if ([code integerValue] == 0 ) {
            NSLog(@"提交成功");
            if ([self.mWY_SendEnrolmentMessageModel.Amount floatValue] > 0) {
                WY_OrderPayViewController *tempController = [WY_OrderPayViewController new];
                tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
                tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
                tempController.dicSignUpSuccess = res[@"data"];
                [self.navigationController pushViewController:tempController animated:YES];
            } else {
                WY_SignUpSuccessViewController *tempController = [WY_SignUpSuccessViewController new];
                tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
                tempController.mWY_TraCourseDetailModel = self.mWY_TraCourseDetailModel;
                tempController.dicSignUpSuccess = res[@"data"];
                [self.navigationController pushViewController:tempController animated:YES];

            }
        } else {
            [SVProgressHUD showErrorWithStatus:res[@"msg"]];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络不给力"];
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
