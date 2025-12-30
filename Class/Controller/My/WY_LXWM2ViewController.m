//
//  WY_LXWM2ViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/5.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_LXWM2ViewController.h"

@interface WY_LXWM2ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrSource;

@property (nonatomic, strong) WY_UserModel *mUser;
@end

@implementation WY_LXWM2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mUser = [MS_BasicDataController sharedInstance].user;

    [self makeUI];
    [self dataBind];
}
- (void)viewWillAppear:(BOOL)animated {
    self.mUser = [MS_BasicDataController sharedInstance].user;
}
- (void)makeUI {
    self.title = @"“指尖上的形式主义”投诉举报";
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];

     [self.tableView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
 
}

- (void)dataBind {
    self.arrSource = [NSMutableArray new];
    NSMutableDictionary *dic1 = [NSMutableDictionary new];
    NSMutableDictionary *dic2 = [NSMutableDictionary new];
    [self.arrSource addObject:dic1];
    [self.arrSource addObject:dic2];
  
    [dic1 setObject:@"举报电话" forKey:@"name"];
    [dic1 setObject:@"13644976603" forKey:@"value"];
    [dic1 setObject:@"2" forKey:@"typeid"];
     
    [dic2 setObject:@"举报邮箱" forKey:@"name"];
    [dic2 setObject:@"caupln@163.com" forKey:@"value"];
    [dic2 setObject:@"3" forKey:@"typeid"];
    [self.tableView reloadData];
}


- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   // 隐藏系统分割线
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor =MSColor(242, 242, 242);
        _tableView.sectionFooterHeight = k360Width(10);
        _tableView.sectionHeaderHeight = 0.01;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DefaultUITableViewCell"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *dicItem = self.arrSource[indexPath.row];
    
     UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DefaultUITableViewCell"];
     cell.backgroundColor = [UIColor clearColor];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([dicItem[@"typeid"] isEqualToString:@"1"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    }
     cell.textLabel.text = dicItem[@"name"];
     cell.detailTextLabel.text = dicItem[@"value"];
    
     [cell.detailTextLabel setFont:WY_FONTRegular(14)];
    [cell.textLabel setFont:WY_FONTRegular(14)];
    [cell.detailTextLabel setFont:WY_FONTRegular(14)];
     UIImageView* imgLine = [[UIImageView alloc] initWithFrame:CGRectMake(0,k360Width(44) - 2,kScreenWidth,2)];
     [imgLine setBackgroundColor:APPLineColor];
     [cell addSubview:imgLine];
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dicItem = self.arrSource[indexPath.row];
    NSLog(@"点击了按钮：%@",dicItem[@"typeid"]);
    switch ([dicItem[@"typeid"] intValue]) {
        case 2:
        {
            //打电话
            [GlobalConfig makeCall:dicItem[@"value"]];
        }
            break;
        case 3:
        {
            //发邮箱
            [GlobalConfig sendEmail:dicItem[@"value"] cc:@"" subject:@"" body:@""];

        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return k360Width(44);
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
@end
