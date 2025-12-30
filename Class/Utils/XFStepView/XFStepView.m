//
//  XFStepView.m
//  SCPay
//
//  Created by weihongfang on 2017/6/26.
//  Copyright © 2017年 weihongfang. All rights reserved.
//

#import "XFStepView.h"

@interface XFStepView()

@property (nonatomic, strong)UIView *lineUndo;
@property (nonatomic, strong)UIView *lineDone;

@property (nonatomic, retain)NSMutableArray *cricleMarks;
@property (nonatomic, retain)NSMutableArray *titleLabels;

@property (nonatomic, strong)UILabel *lblIndicator;
@property (nonatomic, retain)NSMutableArray *statusLabels;
@end


@implementation XFStepView

- (instancetype)initWithFrame:(CGRect)frame Titles:(nonnull NSArray *)titles
{
    if ([super initWithFrame:frame])
    {
        _stepIndex = -1;
        _stepNoIndex = -1;
        _titles = titles;
        
        _lineUndo = [[UIView alloc]init];
        _lineUndo.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineUndo];
        
        _lineDone = [[UIView alloc]init];
        _lineDone.backgroundColor = TINTCOLOR;
        [self addSubview:_lineDone];
        
        
        _lblIndicator = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        _lblIndicator.textAlignment = NSTextAlignmentCenter;
        _lblIndicator.textColor = [UIColor whiteColor];
        _lblIndicator.backgroundColor = TINTCOLOR;
        _lblIndicator.layer.cornerRadius = 23.f / 2;
        _lblIndicator.layer.borderColor = [TINTCOLOR CGColor];
        _lblIndicator.layer.borderWidth = 1;
        _lblIndicator.layer.masksToBounds = YES;
        
        for (NSString *title in _titles)
        {
            UILabel *lbl = [[UILabel alloc]init];
            lbl.text = title;
            lbl.textColor = [UIColor lightGrayColor];
            lbl.font = [UIFont systemFontOfSize:14];
            lbl.textAlignment = NSTextAlignmentCenter;
            [lbl setNumberOfLines:2];
            [self addSubview:lbl];
            [self.titleLabels addObject:lbl];
            
            UIView *cricle = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
            cricle.backgroundColor = [UIColor lightGrayColor];
            cricle.layer.cornerRadius = 13.f / 2;
            [self addSubview:cricle];
            [self.cricleMarks addObject:cricle];
            
        }
        [self addSubview:_lblIndicator];
        
        for (NSString *title in _titles)
        {
            UIImageView *lblii = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
            [lblii setBackgroundColor:[UIColor whiteColor]];
//            lblii.textAlignment = NSTextAlignmentCenter;
//            lblii.textColor = TINTCOLOR;
//            lblii.backgroundColor = [UIColor whiteColor];
//            lblii.layer.cornerRadius = 23.f / 2;
//            lblii.layer.borderColor = [TINTCOLOR CGColor];
//            lblii.layer.borderWidth = 1;
//            lblii.layer.masksToBounds = YES;
            [lblii setHidden:YES];
            [self addSubview:lblii];
            [self.statusLabels addObject:lblii];
            
        }
        
        [self makeUI];
    }
    return self;
}

#pragma mark - method

- (void)makeUI
{
    NSInteger perWidth = self.frame.size.width / self.titles.count;
    
    _lineUndo.frame = CGRectMake(0, 0, self.frame.size.width - perWidth, 3);
    _lineUndo.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 4);
    
    CGFloat startX = _lineUndo.frame.origin.x;
    
    for (int i = 0; i < _titles.count; i++)
    {
        UIView *cricle = [_cricleMarks objectAtIndex:i];
        if (cricle != nil)
        {
            cricle.center = CGPointMake(i * perWidth + startX, _lineUndo.center.y);
        }
        
        UILabel *lbl = [_titleLabels objectAtIndex:i];
        if (lbl != nil)
        {
            lbl.frame = CGRectMake(perWidth * i, self.frame.size.height / 2 - k360Width(10), self.frame.size.width / _titles.count, k360Width(60));
        }
        
        
        UILabel *lblA = [_statusLabels objectAtIndex:i];
        if (lblA != nil)
        {
            lblA.center = CGPointMake(i * perWidth + startX, _lineUndo.center.y);
        }
        
        
    }
    
    self.stepIndex = _stepIndex;
    [self aaasetStepIndex:self.stepIndex];
}

- (NSMutableArray *)cricleMarks
{
    if (_cricleMarks == nil)
    {
        _cricleMarks = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _cricleMarks;
}

- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil)
    {
        _titleLabels = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _titleLabels;
}


- (NSMutableArray *)statusLabels
{
    if (_statusLabels == nil)
    {
        _statusLabels = [NSMutableArray arrayWithCapacity:self.titles.count];
    }
    return _statusLabels;
}



#pragma mark - public method

- (void)aaasetStepIndex:(int)withStepIndex
{
    self.stepIndex = withStepIndex;
    if (self.stepIndex >= 0 && self.stepIndex < self.titles.count)
    {
        [_lblIndicator setHidden:NO];
        
        CGFloat perWidth = self.frame.size.width / _titles.count;
        _lblIndicator.text = [NSString stringWithFormat:@"%d", _stepIndex + 1];
        _lblIndicator.center = ((UIView *)[_cricleMarks objectAtIndex:_stepIndex]).center;
        
        _lineDone.frame = CGRectMake(_lineUndo.frame.origin.x, _lineUndo.frame.origin.y, perWidth * _stepIndex, _lineUndo.frame.size.height);
        
        for (int i = 0; i < _titles.count; i++)
        {
            UIView *cricle = [_cricleMarks objectAtIndex:i];
            if (cricle != nil)
            {
                if (i <= _stepIndex)
                {
                    cricle.backgroundColor = TINTCOLOR;
                }
                else
                {
                    cricle.backgroundColor = [UIColor lightGrayColor];
                }
            }
            UILabel *lbl = [_titleLabels objectAtIndex:i];
            UIImageView *lblA = [_statusLabels objectAtIndex:i];
            if (lbl != nil)
            {
                if (i < self.stepIndex)
                {
                    lbl.textColor = HEXCOLOR(0x1AC653);
//                    lblA.textColor = HEXCOLOR(0x1AC653);
//                    lblA.layer.borderColor = [HEXCOLOR(0x1AC653) CGColor];
                    [lblA setImage:[UIImage imageNamed:@"0722_wsxx_yes"]];
                    [lblA setHidden:NO];
//                    [lblA setText:@"√"];
                } else if (i == self.stepIndex) {
                    lbl.textColor = TINTCOLOR;
                    [lblA setHidden:YES];
                }
                else
                {
                    lbl.textColor = [UIColor lightGrayColor];
                    [lblA setHidden:YES];
                }
            }
        }
    } else {
        [_lblIndicator setHidden:YES];
    }
}


- (void)aaaaStepNoIndex:(int)withStepIndex
{
    //    self.stepNoIndex = stepIndex;
    //    _lblIndicator.text = @"X";
    //      _lblIndicator.textColor = [UIColor redColor];
    //     _lblIndicator.layer.borderColor = [[UIColor redColor] CGColor];
    
    UILabel *lbl = [_titleLabels objectAtIndex:withStepIndex];
    lbl.textColor = HEXCOLOR(0xFB1827);
    UIImageView *lblA = [_statusLabels objectAtIndex:withStepIndex];
    [lblA setImage:[UIImage imageNamed:@"0722_wsxx_no"]];
//    UILabel *lblA = [_statusLabels objectAtIndex:withStepIndex];
//    lblA.textColor = HEXCOLOR(0xFB1827);
//    lblA.layer.borderColor = [HEXCOLOR(0xFB1827) CGColor];
    [lblA setHidden:NO];
//    [lblA setText:@"X"];
    
    return;
}

- (void)aaaaStepYesIndex:(int)withStepIndex
{
    UILabel *lbl = [_titleLabels objectAtIndex:withStepIndex];
    lbl.textColor = HEXCOLOR(0x1AC653);
    UIImageView *lblA = [_statusLabels objectAtIndex:withStepIndex];
    [lblA setImage:[UIImage imageNamed:@"0722_wsxx_yes"]];

//    UILabel *lblA = [_statusLabels objectAtIndex:withStepIndex];
//    lblA.textColor = HEXCOLOR(0x1AC653);
//    lblA.layer.borderColor = [HEXCOLOR(0x1AC653) CGColor];
    [lblA setHidden:NO];
//    [lblA setText:@"√"];
    
    return;
}
- (void)aaaaStepGthIndex:(int)withStepIndex
{
    UILabel *lbl = [_titleLabels objectAtIndex:withStepIndex];
    lbl.textColor = HEXCOLOR(0xE5A631);
    UIImageView *lblA = [_statusLabels objectAtIndex:withStepIndex];
    [lblA setImage:[UIImage imageNamed:@"0722_wsxx_gth"]];
    [lblA setHidden:NO];
    
    return;
}


- (void)setStepIndex:(int)stepIndex Animation:(BOOL)animation
{
    if (stepIndex >= 0 && stepIndex < self.titles.count)
    {
        if (animation)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.stepIndex = stepIndex;
            }];
        }
        else
        {
            self.stepIndex = stepIndex;
        }
    }
}


@end
