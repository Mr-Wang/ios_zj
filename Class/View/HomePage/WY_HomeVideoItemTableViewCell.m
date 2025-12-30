//
//  WY_HomeVideoItemTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/4/7.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_HomeVideoItemTableViewCell.h"

@implementation WY_HomeVideoItemTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self makeUI];
        [self.colSender setUserInteractionEnabled:NO];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        self.userInteractionEnabled = YES;
        [self makeUI];
        [self.colSender setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)makeUI {
    self.colSender = [[UIControl alloc] init];
//    self.imgContent = [[UIImageView alloc] initWithFrame:CGRectMake(k360Width(16), k360Width(16), kScreenWidth - k360Width(32), k360Width(132))];
//    [self.imgContent rounded:k360Width(44)/8];
//    [self.contentView addSubview:_imgContent];
    
    // 头视图 banner
        self.headerView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(k360Width(16),  k360Width(5), (int)(kScreenWidth - k360Width(32)), k360Width(150))];
        self.headerView.autoScrollTimeInterval = 5.0f;
    //    self.headerView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        self.headerView.placeholderImage = [UIImage imageNamed:@"0211_CourseTop"];
        [self.headerView rounded:k360Width(40/8)];
        [self.contentView addSubview:self.headerView];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.headerView.bottom + 10, self.headerView.width, k360Width(22))];
    [self.lblTitle setFont: WY_FONTMedium(14)];
    [self.contentView addSubview:self.lblTitle];
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(16), self.lblTitle.bottom + 10, self.headerView.width, k360Width(22))];
    [self.lblDate setFont: WY_FONTRegular(14)];
    [self.lblDate setTextColor:HEXCOLOR(0x909090)];
    [self.contentView addSubview:self.lblDate];
    
    [self.contentView addSubview: self.colSender];
}

- (void)showCellByItem:(NSArray*)withArrModel {
    
    //填充滚动条图片url 模拟
       
       NSMutableArray *arrImageUrl = [[NSMutableArray alloc] init];
       for (WY_InfomationModel *rslModel in withArrModel) {
           [arrImageUrl addObject:[rslModel.imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
       }
       
       self.headerView.imageURLStringsGroup = arrImageUrl;
       WS(weakSelf)
       [self.headerView setItemDidScrollOperationBlock:^(NSInteger currentIndex) {
           weakSelf.mWY_InfomationModel = withArrModel[currentIndex];
           weakSelf.currentSelIndex = currentIndex;
           [weakSelf bindTitleData];
        }];
    self.mWY_InfomationModel = withArrModel[0];
    [self bindTitleData];

}
- (void) bindTitleData {
        self.lblTitle.text = self.mWY_InfomationModel.title;
        if ([self.mWY_InfomationModel.isRead isEqualToString:@"1"]) {
            [self.lblTitle setTextColor:APPTextGayColor];
        } else {
            [self.lblTitle setTextColor:[UIColor blackColor]];
        }
    //    [self.imgContent sd_setImageWithURL:[NSURL URLWithString:self.mWY_InfomationModel.imgurl]];
        NSString *typeStr = [WY_WLTools categoryStringByNum:self.mWY_InfomationModel.categorynum];
        
         self.lblDate.text = [NSString stringWithFormat:@"%@    %@",typeStr,self.mWY_InfomationModel.infodate];
        self.height = self.lblDate.bottom + k360Width(10);
        [self.colSender setFrame:self.bounds];
    self.colSender.top = self.lblTitle.top;
    self.colSender.height = self.lblDate.bottom - self.lblTitle.top;
}
@end
