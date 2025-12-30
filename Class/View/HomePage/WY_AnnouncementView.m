//
//  WY_AnnouncementView.m
//
//
//  Created by Wy on 2018/6/27.
//  Copyright © 2018年 Wy. All rights reserved.
//

#import "WY_AnnouncementView.h"
#import "SDCycleScrollView.h"

@interface WY_AnnouncementView()<SDCycleScrollViewDelegate>
{
    NSArray *_imagesURLStrings;
}

@property (nonatomic , weak)  SDCycleScrollView *customCellScrollView;/* <#注释#> */
@property (nonatomic , weak)  SDCycleScrollView *picScrollView;/*  */

@property (nonatomic , strong) UIView *bgView;/* <#注释#> */


@property (nonatomic , strong) UIImageView *announ;/* 公告图片 */
@property (nonatomic , strong) UIImageView *recommended;/* 推荐图片 */

@end

@implementation WY_AnnouncementView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self ADDSUBVIEWS];
        
        [self pageUI];
    }
    return self;
}
 


-(void)ADDSUBVIEWS{
     
    [self addSubview:self.announ];
    [self addSubview:self.recommended];
    [self.announ setFrame:CGRectMake(k360Width(16), k360Width(12), k360Width(20), k360Width(20))];
}


-(void)pageUI{
    // 图片配文字
    NSArray *titles = @[@"文字轮播1",
                        @"文字轮播2",
                        @"文字轮播3",
                        @"文字轮播4"
                        ];
    
    // 网络加载 --- 创建只上下滚动展示文字的轮播器
    // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
    SDCycleScrollView *cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(self.announ.right + k360Width(5), k360Width(12), (int)(self.width - self.announ.right - k360Width(10)), k360Width(20)) delegate:self placeholderImage:nil];
    cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
    cycleScrollView4.onlyDisplayText = YES;
    NSMutableArray *titlesArray = [NSMutableArray new];
    [titlesArray addObjectsFromArray:titles];

    [cycleScrollView4 disableScrollGesture];
    cycleScrollView4.titleLabelBackgroundColor= [UIColor clearColor];
    cycleScrollView4.titleLabelTextColor = MSTHEMEColor;
    cycleScrollView4.titleLabelTextFont =  WY_FONTRegular(16);
    
    
    [self addSubview:cycleScrollView4];
    self.customCellScrollView = cycleScrollView4;
}


-(void)titleArr:(NSArray *)titleArr{
        self.customCellScrollView.titlesGroup = [titleArr copy];
}
 
-(UIImageView *)announ{
    if (!_announ) {
        _announ = [[UIImageView alloc] init];
        _announ.image = [UIImage imageNamed:@"lb"];
    }
    return _announ;
}


-(UIImageView *)recommended{
    if (!_recommended) {
        _recommended = [[UIImageView alloc] init];
        _recommended.image = [UIImage imageNamed:@"home_icon_recommend"];
    }
    return _recommended;
}

//轮播图代理
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
//    NSLog(@"---点击了第%ld公告", (long)index);
    [self.delegate Announcement:index];
    
}

@end
