//
//  XFStepView.h
//  SCPay
//
//  Created by weihongfang on 2017/6/26.
//  Copyright © 2017年 weihongfang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TINTCOLOR MSTHEMEColor

@interface XFStepView : UIView

@property (nonatomic, retain)NSArray * _Nonnull titles;

@property (nonatomic, assign)int stepIndex;
@property (nonatomic, assign)int stepNoIndex;
 
- (instancetype _Nonnull )initWithFrame:(CGRect)frame Titles:(nonnull NSArray *)titles;

- (void)setStepIndex:(int)stepIndex Animation:(BOOL)animation;
- (void)aaaaStepNoIndex:(int)withStepIndex;
- (void)aaaaStepYesIndex:(int)withStepIndex;
- (void)aaaaStepGthIndex:(int)withStepIndex;
- (void)aaasetStepIndex:(int)withStepIndex;
@end
