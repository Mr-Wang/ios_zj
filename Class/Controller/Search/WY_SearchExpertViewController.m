//
//  WY_SearchExpertViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/5/25.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_SearchExpertViewController.h"
#import "ZJScrollPageView.h"//选择控制器]
#import "WY_HistoryProjListViewController.h"

@interface WY_SearchExpertViewController () <UITextFieldDelegate> {
    UIView *viewTop;
    UITextField *txtSearch;
}

@property (nonatomic , strong) UIView *viewSearch;
@property (nonatomic , strong) NSArray *arrgrList;
@property (nonatomic , strong) NSArray *arrreList;

@property (nonatomic)NSInteger selZJIndex;

@property (nonatomic, weak) ZJScrollPageView *scrollPageView;//选择控制器
@property (nonatomic , strong)  NSArray *titleArr;/* 选择控制器title*/
@end

@implementation WY_SearchExpertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self makeUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
 }

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)makeUI {
    [self.view setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self initHeaderView];
    [self ZJScorollPageUI];//轮播选择控制器
    [self initSearchView];
    [self bindDataSearchView];
}


-(void)ZJScorollPageUI{
    //必要的设置, 如果没有设置可能导致内容显示不正常
       self.automaticallyAdjustsScrollViewInsets = NO;
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    //显示滚动条
     style.scrollContentView = NO;
     style.segmentHeight = 0;//k360Width(52);
    self.titleArr =@[@"文章"];
    
     
    // 初始化
    ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, viewTop.bottom, kScreenWidth, kScreenHeight - viewTop.bottom) segmentStyle:style titles:self.titleArr parentViewController:self delegate:self];
    self.scrollPageView = scrollPageView;
    [self.view addSubview:scrollPageView];
     
 }


#pragma mark - ZJScrollPageViewChildVcDelegate
- (NSInteger)numberOfChildViewControllers {
    return self.titleArr.count;
}
- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    if (index > self.titleArr.count-1) {
        index = self.titleArr.count - 1;
    }
    if (index == 0) {
        [self.navigationItem.rightBarButtonItem.customView setHidden:NO];
    } else {
        [self.navigationItem.rightBarButtonItem.customView setHidden:YES];
    }
//    return nil;
    self.selZJIndex = index;
    
    WY_HistoryProjListViewController<ZJScrollPageViewChildVcDelegate> *fourview = (WY_HistoryProjListViewController *)reuseViewController;
    if (!fourview) {
        fourview = [[WY_HistoryProjListViewController alloc] init];
    }
    fourview.keyword = self.keyword;
     return fourview;
}



- (void)initHeaderView {
    viewTop = [UIView new];
    [viewTop setFrame:CGRectMake(0, 0, kScreenHeight, JCNew64)];
    [viewTop setBackgroundColor:MSTHEMEColor];
    [self.view addSubview:viewTop];
    
    UIImageView *loginImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1127_ss"]];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, k360Width(40), k360Width(40))];
    loginImgV.center = lv.center;
    [lv addSubview:loginImgV];
    
    txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(k360Width(30 + 16), MH_APPLICATION_STATUS_BAR_HEIGHT + k360Width(10), k360Width(290), k360Width(30))];
    txtSearch.leftViewMode = UITextFieldViewModeAlways;
    txtSearch.leftView = lv;
    [txtSearch setFont:WY_FONTRegular(14)];
    [txtSearch setPlaceholder:@"搜索你感兴趣的内容"];
    [txtSearch rounded:k360Width(30 / 8)];
    txtSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    [txtSearch setBackgroundColor:[UIColor whiteColor]];
    txtSearch.delegate = self;
    txtSearch.returnKeyType = UIReturnKeySearch;
     [viewTop addSubview:txtSearch];

    UIButton * btnBack = [UIButton new];
    [btnBack setFrame:CGRectMake(k360Width(0), 0, k360Width(44), k360Width(44))];
    [btnBack setImage:[UIImage imageNamed:@"0225_quizback"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside];
    [viewTop addSubview:btnBack];
    btnBack.centerY = txtSearch.centerY;
    viewTop.height = txtSearch.bottom + k360Width(10);

}
- (void)initSearchView {
    self.viewSearch = [[UIView alloc] initWithFrame:CGRectMake(0, viewTop.bottom, kScreenWidth, kScreenHeight - viewTop.bottom)];
    [self.viewSearch setBackgroundColor:HEXCOLOR(0xFAFAFA)];
    [self.view addSubview:self.viewSearch];
    
    
}
- (void) bindDataSearchView {
     NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
     NSString *dicSearchHomeStr = [userDef objectForKey:@"dicSearchExper"];
      if (dicSearchHomeStr) {
         self.arrgrList = [[NSMutableArray alloc] initWithArray:[dicSearchHomeStr componentsSeparatedByString:@"rf!g"]];
     } else {
         self.arrgrList = [[NSMutableArray alloc] init];
     }
      [self bindSearchView];
}
- (void) bindSearchView {
    [self.viewSearch removeAllSubviews];
    
    float lastY = 0;
    UILabel *lblTitle1 = [UILabel new];
    [lblTitle1 setFrame:CGRectMake(k360Width(16), k360Width(10), kScreenWidth - k360Width(32), k360Width(44))];
    lblTitle1.text = @"搜索历史";
    [lblTitle1 setFont:WY_FONTMedium(16)];
    [self.viewSearch addSubview:lblTitle1];
    
    
    lastY = lblTitle1.bottom;
 
 
    if (self.arrgrList.count) {
        float Start_X  = k360Width(16);           // 第一个按钮的X坐标
        float Start_Y = lastY + k360Width(16);       // 第一个按钮的Y坐标
        float  Width_Space = k360Width(10);     // 2个按钮之间的横间距
        float  Height_Space = k360Width(8);// 竖间距
        float  Button_Height = k360Width(35);// 高
        float  Button_Width = (kScreenWidth - k360Width(32+20)) / 3; //k360Width(44);// 宽
        NSArray* reversedArray = [[self.arrgrList reverseObjectEnumerator] allObjects];
        int maxCount =  reversedArray.count;
        if (maxCount > 9) {
            maxCount = 9;
        }
            for (int i =0; i < maxCount; i ++) {
            NSInteger index = i % 3;
            NSInteger page = i / 3;
            // 圆角按钮
            UIButton *aBt = [[UIButton alloc]initWithFrame:CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height)];
                [aBt setTitle: reversedArray[i] forState:UIControlStateNormal];
                [aBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [aBt rounded:k360Width(44/8) width:1 color:APPTextGayColor];
                [aBt addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
                    [self seetDicSearchHome: reversedArray[i]];
                    [self bindView: reversedArray[i]];
                }];
                [self.viewSearch addSubview:aBt];
                lastY = aBt.bottom;
         }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self seetDicSearchHome:textField.text];
    [self bindSearchView];
    [self bindView:textField.text];

    return YES;
}

- (void)seetDicSearchHome:(NSString *)txtStr {
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *dicSearchHomeStr = [userDef objectForKey:@"dicSearchExper"];
    NSMutableArray * arrSearchList = nil;
    if (dicSearchHomeStr) {
        arrSearchList = [[NSMutableArray alloc] initWithArray:[dicSearchHomeStr componentsSeparatedByString:@"rf!g"]];
    } else {
        arrSearchList = [[NSMutableArray alloc] init];
    }
    txtStr = [txtStr stringByTrim];
    if (txtStr.length > 0) {
        [arrSearchList addObject:txtStr];
        [userDef setObject:[arrSearchList componentsJoinedByString:@"rf!g"] forKey:@"dicSearchExper"];
    }
}

- (void)btnBackAction {
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bindView:(NSString *)searchText {
    NSLog(@"搜索了：%@",searchText);
    [self.viewSearch setHidden:YES];
    self.keyword = searchText;
    txtSearch.text = searchText;
    NSNotificationCenter *notifyHomeSearch = [NSNotificationCenter defaultCenter];
    [notifyHomeSearch postNotificationName:@"ExpertSearchNotify" object:searchText];
}
@end
