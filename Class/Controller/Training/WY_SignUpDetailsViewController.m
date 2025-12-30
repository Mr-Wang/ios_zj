//
//  WY_SignUpDetailsViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/19.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SignUpDetailsViewController.h"
#import "WY_SignUpTopTableViewCell.h"
#import "WY_SignUpStudentItemTableViewCell.h"
#import "WY_TraEnrolPersonModel.h"
#import "WY_SendEnrolmentMessageModel.h"
#import "WY_AddPeoplelViewController.h"
#import "WY_SelectInvoiceViewController.h"
#import "WY_OrderInfoTableViewCell.h"

@interface WY_SignUpDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrSelStudents;
@property (nonatomic, strong) YYLabel *lblPriceSum;
@property (nonatomic, strong) UIButton *btnSubmit;

@end

@implementation WY_SignUpDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
    [self dataBind];
}
- (void)makeUI {
    self.title = @"课程订单详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    
//    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, kScreenWidth, k360Width(50))];
//    UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,0 ,kScreenWidth, 1)];
//    [imgLine setBackgroundColor:APPLineColor];
//    [viewBottom addSubview:imgLine];
//    self.btnSubmit = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - k360Width(16 + 110), k360Width(7), k360Width(110), k360Width(44-8))];
//    self.lblPriceSum = [[YYLabel alloc] initWithFrame:CGRectMake(0, k360Width(10), self.btnSubmit.left - k360Width(10), k360Width(30))];
//    self.lblPriceSum.textAlignment = NSTextAlignmentRight;
//    [self.btnSubmit setTitle:@"提交订单" forState:UIControlStateNormal];
//    [self.btnSubmit setBackgroundColor:MSTHEMEColor];
//    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.btnSubmit rounded:k360Width(44)/8];
//    [self.btnSubmit addTarget:self action:@selector(btnSubmitAction) forControlEvents:UIControlEventTouchUpInside];
//
//    [viewBottom addSubview:self.btnSubmit];
//    [viewBottom addSubview:self.lblPriceSum];
//    [self.view addSubview:viewBottom];
    
    
}
- (void)dataBind {
    
    if (self.orderid) {
        NSMutableDictionary *dicPost = [NSMutableDictionary new];
        [dicPost setObject:self.orderid forKey:@"id"];
        [[MS_BasicDataController sharedInstance] postWithReturnCode:traEnrolDetail_HTTP params:dicPost jsonData:nil showProgressView:YES success:^(id res, NSString *code) {
              if ([code integerValue] == 0 ) {
                  self.mWY_SendEnrolmentMessageModel = [WY_SendEnrolmentMessageModel yy_modelWithJSON:res[@"data"][@"orderDetailBean"]];
                  self.mWY_TraCourseDetailModel = [WY_TraCourseDetailModel modelWithJSON:res[@"data"][@"traCourseDetailBean"]];
                  self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans = [NSArray yy_modelArrayWithClass:[WY_TraEnrolPersonModel class] json:res[@"data"][@"enrolPersonList"]];
                  self.dicSignUpSuccess = @{@"orderId":self.mWY_SendEnrolmentMessageModel.OrderNo};
                  self.arrSelStudents = [[NSMutableArray alloc] initWithArray:self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans];
                  if ([res[@"data"][@"orderPayBean"][@"onlinePayMethod"]  intValue] == 4) {
                      //余额支付
                      self.paymethod = @"04";
                  }
                  [self.tableView reloadData];
              } else {
                  [SVProgressHUD showErrorWithStatus:res[@"msg"]];
              }
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }];

    } else {
        self.arrSelStudents = [[NSMutableArray alloc] initWithArray:self.mWY_SendEnrolmentMessageModel.traEnrolPersonBeans];
        [self.tableView reloadData];
    }
    
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
        
        [_tableView registerClass:[WY_OrderInfoTableViewCell class] forCellReuseIdentifier:@"WY_OrderInfoTableViewCell"];
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
         return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.arrSelStudents.count;
            break;
        case 3:
            return 1;
            break;
//            case 4:
//            return 1;
//            break;
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
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"上课人数";
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
//            case 3:
//                   {
//                       UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
//                       cell.backgroundColor = [UIColor clearColor];
//                       cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                       cell.accessoryType = UITableViewCellAccessoryNone;
//                       cell.textLabel.text = @"总支付";
//                       //发票金额
////                       cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%@",self.mWY_SendEnrolmentMessageModel.Amount];
//                       //
//                       float countAmount = self.arrSelStudents.count * [self.mWY_TraCourseDetailModel.Price floatValue];
//                       cell.detailTextLabel.text = [NSString stringWithFormat:@"￥%.2f",countAmount];
//
//
//                       UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(43) ,kScreenWidth, 1)];
//                       [imgLine setBackgroundColor:APPLineColor];
//                       [cell addSubview:imgLine];
//                       return cell;
//                   }
//            break;
            case 3:
        {
            
            WY_OrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WY_OrderInfoTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.priceStr = self.mWY_TraCourseDetailModel.Price;
            cell.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
            [cell showCellByItem:self.dicSignUpSuccess withPaymethod:self.paymethod];
            cell.gotoInvoiceBlock = ^{
                    WY_SelectInvoiceViewController *tempController = [WY_SelectInvoiceViewController new];
                tempController.isCanSave = NO;
                tempController.mWY_SendEnrolmentMessageModel = self.mWY_SendEnrolmentMessageModel;
                 [self.navigationController pushViewController:tempController animated:YES];

            };
             return cell;
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
     
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     switch (indexPath.section) {
            case 0:
             //订单详情cell
                return k360Width(113);
                break;
            case 1:
             //支付方式、发票cell
                return k360Width(44);
                break;
            case 2:
             //人员列表高度
             return k360Width(80);
                break;
//            case 3:
//             //总支付
//             return k360Width(44);
//                break;
             case 3:
             //总支付
             return k360Width(200);
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
    if (section == 0 || section == 2) {
        return k360Width(10);
    }
    return 0.001;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = MSColor(242, 242, 242);
    return view;
}

@end
