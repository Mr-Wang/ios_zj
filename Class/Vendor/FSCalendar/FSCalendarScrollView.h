//
//  FSCalendarScrollView.h
//  Test
//
//  Created by 樊盛 on 2019/4/29.
//  Copyright © 2019年 樊盛. All rights reserved.
//  单纯的日历scrollView

#import <UIKit/UIKit.h>

typedef void(^PassDateBlock)(NSDate *date);// 点击日期block
@interface FSCalendarScrollView : UIScrollView

/** 日期传递block */
@property (nonatomic, copy) PassDateBlock passDateBlock;

/** 当前月的日期 */
@property (nonatomic, strong) NSDate *currentMonthDate;

/** 当前选中的cell的日期（eg：7、19、31） */
@property (nonatomic, assign) NSInteger currentDateNumber;

/** 是否单行显示 */
@property (nonatomic, assign) BOOL isShowSingle;


/** 是否支持点击上下月日期-切换上下月 */
@property (nonatomic, assign) BOOL ispushToPreviousMonthOrNext;

//** 当前背景颜色蓝色dateString数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *pointsArrayBlue;


/** 当前背景颜色红色dateString数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *pointsArrayRed;

/** 刷新collectionView */
- (void)reloadCollectionViews;

/** 回到今天 */
- (void)refreshToCurrentDate;

/** 通过日期跳转日历的方法*/
- (void)refreshToByWithDate:(NSDate *)date;

@end
