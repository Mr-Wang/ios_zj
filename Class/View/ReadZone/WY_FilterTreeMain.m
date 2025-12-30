//
//  WY_FilterTreeMain.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_FilterTreeMain.h"
#import "WY_FilterTreeItemView.h"

@implementation WY_FilterTreeMain

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self makeUI];
        [self bindView];
     }
    return self;
}

- (void)makeUI {
    self.bgView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64 - JC_TabbarSafeBottomMargin)];
    [self.bgView setBackgroundColor:MHColorAlpha(0, 0, 0, 0.5)];
    [self.bgView addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgView];
    
    self.viewContent = [[UIView alloc] initWithFrame:CGRectMake(k360Width(64), 0, kScreenWidth - k360Width(64), self.bgView.height)];
    [self.viewContent setBackgroundColor:[UIColor whiteColor]];
    [self.viewContent rounded:k360Width(44) / 8 ];
    [self addSubview:self.viewContent];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), self.viewContent.width - k360Width(32), k360Width(24))];
    lblTitle.text = @"设置筛选条件";
    [lblTitle setTextColor:MSTHEMEColor];
    [lblTitle setFont:WY_FONTMedium(16)];
    [self.viewContent addSubview:lblTitle];
    
    UILabel *lblTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), lblTitle.bottom + k360Width(5), k360Width(100), k360Width(24))];
    lblTitle2.text = @"法律法规";
    [lblTitle2 setTextColor:[UIColor blackColor]];
    [lblTitle2 setFont:WY_FONTMedium(16)];
    [self.viewContent addSubview:lblTitle2];
    
    self.mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lblTitle2.bottom + k360Width(5), self.viewContent.width, self.viewContent.height - lblTitle2.bottom - k360Width(70))];
//    [self.mScrollView setBackgroundColor:[UIColor blueColor]];
    [self.viewContent addSubview:self.mScrollView];
    
    UIButton *btnAfresh = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(10), self.mScrollView.bottom + k360Width(5), (self.viewContent.width - k360Width(10 *4)) / 2, k360Width(44))];
    [btnAfresh setTitle:@"重选" forState:UIControlStateNormal];
    [btnAfresh setBackgroundColor:HEXCOLOR(0x84807D)];
    [btnAfresh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAfresh rounded:k360Width(44) / 8 ];
    [btnAfresh addTarget:self action:@selector(btnAfreshAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viewContent addSubview:btnAfresh];
    
    UIButton *btnDefinite = [[UIButton alloc] initWithFrame:CGRectMake(btnAfresh.right + k360Width(20), self.mScrollView.bottom + k360Width(5), (self.viewContent.width - k360Width(10 *4)) / 2, k360Width(44))];
    [btnDefinite setTitle:@"确定" forState:UIControlStateNormal];
    [btnDefinite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnDefinite setBackgroundColor:MSTHEMEColor];
    [btnDefinite rounded:k360Width(44) / 8 ];
[btnDefinite addTarget:self action:@selector(btnDefiniteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.viewContent addSubview:btnDefinite];
     
    
}
#pragma mark --点击了确定按钮； 提交到上一页
- (void)btnDefiniteAction {
    if (self.selFilterModelBlock) {
        self.selFilterModelBlock(self.selModel);
    }
    [self hideView];
}
#pragma mark --点击了重置按钮； 提交到上一页
- (void)btnAfreshAction {
    if (self.selModel != nil) {
        self.selModel.isSel = NO;
        [self refreshSelectData:self.selModel];
    }
}

#pragma mark --绑定数据
- (void)bindView {
     
    self.arrDataSource = [[NSMutableArray alloc] init];
    WY_FilterTreeModel *model1 = [WY_FilterTreeModel new];
    model1.nsTitle = @"法律和行政法规";
    model1.nsID = @"5001001";
    [self.arrDataSource addObject:model1];
    
    WY_FilterTreeModel *model2 = [WY_FilterTreeModel new];
       model2.nsTitle = @"部门规章及规范性文件";
       model2.nsID = @"5001003";
       [self.arrDataSource addObject:model2];
       
    model2.arrChilds = [[NSMutableArray alloc] init];
    
    //子集
       WY_FilterTreeModel *model21 = [WY_FilterTreeModel new];
        model21.nsTitle = @"政府采购";
        model21.nsID = @"5001003001";
    model21.nsParentID = @"5001003";
        [model2.arrChilds addObject:model21];
          model21.arrChilds = [[NSMutableArray alloc] init];
    //子集子集
    
    NSArray *arrStr21 = [[NSArray alloc]  initWithObjects:@"政府采购综合管理",@"政府采购品目分类",@"集中采购机构",@"公共资源交易平台",@"社会采购代理机构和服务收费",@"政府采购信息发布",@"政府采购程序",@"政府采购处罚",@"政府采购专家管理",@"政府采购质疑投诉",@"政府采购进口产品",@"政府购买服务",@"政府和社会资本合作（PPP）",@"政府采购节能产品",@"政府采购促进中小企业发展",@"中央单位政府采购",@"政府采购诚信建设",@"政府采购其他", nil];
    
    for (int i = 0 ; i< arrStr21.count; i ++) {
        NSString *strAA = arrStr21[i];
         WY_FilterTreeModel *model2101 = [WY_FilterTreeModel new];
          model2101.nsTitle = strAA;
            model2101.nsID = [NSString stringWithFormat:@"%ld",5001003001001 + i];
           model2101.nsParentID = @"5001003001";
          [model21.arrChilds addObject:model2101];
    }
        //子集
        WY_FilterTreeModel *model22 = [WY_FilterTreeModel new];
        model22.nsTitle = @"招标投标";
        model22.nsID = @"5001003002";
    model22.nsParentID = @"5001003";
        [model2.arrChilds addObject:model22];
          model22.arrChilds = [[NSMutableArray alloc] init];
//子集子集
    NSArray *arrStr22 = [[NSArray alloc]  initWithObjects:@"综合管理",@"工程建设",@"信用体系建设",@"公共资源交易平台", nil];
       for (int i = 0 ; i< arrStr22.count; i ++) {
           NSString *strAA = arrStr22[i];
            WY_FilterTreeModel *model2201 = [WY_FilterTreeModel new];
             model2201.nsTitle = strAA;
               model2201.nsID = [NSString stringWithFormat:@"%ld",5001003002001 + i];
              model2201.nsParentID = @"5001003002";
             [model22.arrChilds addObject:model2201];
       }
    WY_FilterTreeModel *model3 = [WY_FilterTreeModel new];
    model3.nsTitle = @"辽宁省规章及规范性文件";
    model3.nsID = @"5001004";
    [self.arrDataSource addObject:model3];
    
    NSLog(@"aaaa");
    [self refreshView];
}
- (void)refreshSelectData:(WY_FilterTreeModel *)tempModel {
    
    if (tempModel.isSel) {
        self.selModel = tempModel;
        
        for (WY_FilterTreeModel *tempModelA in self.arrDataSource) {
            tempModelA.isSel = NO;
            if ([tempModel.nsID isEqualToString:tempModelA.nsID]) {
                 tempModelA.isSel = YES;
            }
            if ([tempModel.nsParentID isEqualToString:tempModelA.nsID]) {
                tempModelA.isSel = YES;
            }
            for (WY_FilterTreeModel *tempModelB in tempModelA.arrChilds) {
                tempModelB.isSel = NO;
                if ([tempModel.nsID isEqualToString:tempModelA.nsID] || [tempModel.nsID isEqualToString:tempModelB.nsID]) {
                     tempModelA.isSel = YES;
                    tempModelB.isSel = YES;
                }
                if ([tempModel.nsParentID isEqualToString:tempModelB.nsID]) {
                    tempModelA.isSel = YES;
                    tempModelB.isSel = YES;
                }
                for (WY_FilterTreeModel *tempModelC in tempModelB.arrChilds) {
                    tempModelC.isSel = NO;
                    if ([tempModel.nsID isEqualToString:tempModelA.nsID] || [tempModel.nsID isEqualToString:tempModelB.nsID]|| [tempModel.nsID isEqualToString:tempModelC.nsID]) {
                         tempModelA.isSel = YES;
                        tempModelB.isSel = YES;
                        tempModelC.isSel = YES;
                    }
                    if ([tempModel.nsParentID isEqualToString:tempModelC.nsID]) {
                        tempModelA.isSel = YES;
                        tempModelB.isSel = YES;
                        tempModelC.isSel = YES;
                    }
                }
            }
        }
        self.selModel.isSel = YES;
    } else {
        self.selModel = nil;
        for (WY_FilterTreeModel *tempModelA in self.arrDataSource) {
            tempModelA.isSel = NO;
            for (WY_FilterTreeModel *tempModelB in tempModelA.arrChilds) {
                tempModelB.isSel = NO;
                for (WY_FilterTreeModel *tempModelC in tempModelB.arrChilds) {
                    tempModelC.isSel = NO;
                }
            }
        }
    }
    
        [self refreshView];
}
- (void)refreshView {
    [self.mScrollView removeAllSubviews];
    
    int lastY = 0;
    for (WY_FilterTreeModel *tempModel in self.arrDataSource) {
         WY_FilterTreeItemView *ftiView = [[WY_FilterTreeItemView alloc] initWithFrame:CGRectMake(0,lastY , self.mScrollView.width, k360Width(44))];
        [ftiView showCellByItem:tempModel];
       
        ftiView.selOpenOrCloseBlock = ^(WY_FilterTreeModel * _Nonnull ftModel) {
            [self refreshView];
        };
        
        ftiView.selItemBlock = ^(WY_FilterTreeModel * _Nonnull ftModel) {
            [self refreshSelectData:ftModel];
               
        };
               
        [self.mScrollView addSubview:ftiView];
        lastY = ftiView.bottom;
        if (tempModel.arrChilds != nil && tempModel.isOpen) {
             for (WY_FilterTreeModel *tempModelA in tempModel.arrChilds) {
                 WY_FilterTreeItemView *ftiViewA = [[WY_FilterTreeItemView alloc] initWithFrame:CGRectMake(k360Width(16),lastY , self.mScrollView.width, k360Width(44))];
                [ftiViewA showCellByItem:tempModelA];
                [self.mScrollView addSubview:ftiViewA];
                lastY = ftiViewA.bottom;
                
                 ftiViewA.selOpenOrCloseBlock = ^(WY_FilterTreeModel * _Nonnull ftModel) {
                     [self refreshView];
                 };
                 
                 ftiViewA.selItemBlock = ^(WY_FilterTreeModel * _Nonnull ftModel) {
                            [self refreshSelectData:ftModel];
                 };
                       
                 
                if (tempModelA.arrChilds != nil  && tempModelA.isOpen) {
                     for (WY_FilterTreeModel *tempModelB in tempModelA.arrChilds) {
                         WY_FilterTreeItemView *ftiViewB = [[WY_FilterTreeItemView alloc] initWithFrame:CGRectMake(k360Width(32),lastY , self.mScrollView.width, k360Width(44))];
                        [ftiViewB showCellByItem:tempModelB];
                        [self.mScrollView addSubview:ftiViewB];
                         ftiViewB.selOpenOrCloseBlock = ^(WY_FilterTreeModel * _Nonnull ftModel) {
                             [self refreshView];
                         };
                         
                         ftiViewB.selItemBlock = ^(WY_FilterTreeModel * _Nonnull ftModel) {
                                    [self refreshSelectData:ftModel];
                         };
                               
                        lastY = ftiViewB.bottom;
                    }

                }
                
            }

        }
     }
    
    [self.mScrollView setContentSize:CGSizeMake(self.mScrollView.width, lastY)];

}
#pragma mark --显示View
- (void)showView {
    [self setHidden:NO];
    
    
}
#pragma mark --隐藏View
-(void)hideView {
    [self setHidden:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
