//
//  UILabel+MS_Label.h
//  AnCheDangBu
//
//  Created by 古玉彬 on 16/10/10.
//  Copyright © 2016年 ms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MS_Label)


+ (instancetype)ms_labelWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;

+ (instancetype)ms_labelWithFontSize:(CGFloat)fontSize textColor:(UIColor *)textColor title:(NSString *)title;
@end
