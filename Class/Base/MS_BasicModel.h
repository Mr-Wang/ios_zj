//
//  MSBasicModel.h
//  weibu
//
//  Created by 古玉彬 on 16/1/11.
//  Copyright © 2016年 msql. All rights reserved.
//

#import <Foundation/Foundation.h>

#define proStr(str) @property (nonatomic, copy) NSString * (str)

#define proArr(arr) @property (nonatomic, copy) NSArray * (arr)

#define proInteger(i) @property (nonatomic, assign) NSInteger (i)

#define proMuArr(muArr) @property (nonatomic, strong) NSMutableArray * (muArr)

#define proDate(date) @property (nonatomic, copy) NSDate * (date)

#define proBool(flag) @property (nonatomic, assign) BOOL (flag)

#define proNumber(i) @property (nonatomic, copy) NSNumber * (i)

@interface MS_BasicModel : NSObject


@property (nonatomic, copy) NSString * uid;


@property (nonatomic, assign) BOOL isExpend;

@property (nonatomic, copy) NSString * expendStr;

/**
 *  是否需要更新高度
 */
@property (nonatomic, assign) BOOL shouldUpdateHeight;
@end
