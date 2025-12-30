//
//  UILabel+MS_Label.m
//  AnCheDangBu
//
//  Created by 古玉彬 on 16/10/10.
//  Copyright © 2016年 ms. All rights reserved.
//

#import "UILabel+MS_Label.h"

@implementation UILabel (MS_Label)


+ (instancetype)ms_labelWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    
    UILabel * lab = [UILabel new];
    lab.font = [UIFont systemFontOfSize:fontSize];
    lab.textColor = textColor;
    return lab;
}

+ (instancetype)ms_labelWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor title:(NSString *)title {
    
    UILabel * lab = [self ms_labelWithFontSize:fontSize textColor:textColor];
    
    lab.text = title;
    [lab sizeToFit];
    
    return lab;
}
@end
