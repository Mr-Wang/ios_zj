//
//  SVProgressHUD+MS_SVProgressHUD.m
//  AnCheDangBu
//
//  Created by 古玉彬 on 16/12/3.
//  Copyright © 2016年 ms. All rights reserved.
//

#import "SVProgressHUD+MS_SVProgressHUD.h"
#import <SDWebImage/UIImage+GIF.h>
#import "UILabel+MS_Label.h"


static UIView * hudView;
static int showCount = 0;

@implementation SVProgressHUD (MS_SVProgressHUD)

+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType {
    
    
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
    
    if (hudView) {
        
        [[UIApplication sharedApplication].delegate window].userInteractionEnabled = YES;
        [hudView removeFromSuperview];
        hudView = nil;
    }
    
    showCount++;

    UIView * toastView = [UIView new];
//    toastView.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.5];
    toastView.backgroundColor = [UIColor clearColor];

    toastView.layer.cornerRadius = 10.0f;
    toastView.alpha = 0.0;
    
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:toastView];
    window.userInteractionEnabled = NO;
    
  
    
    UIImage *img = [UIImage sd_animatedGIFNamed:@"加载动画@3x"];
    
    UIImageView * carProgressImageView = [UIImageView new];
    carProgressImageView.image = img;
    
    
    carProgressImageView.layer.cornerRadius = 20.0f;
    carProgressImageView.layer.masksToBounds = YES;
    carProgressImageView.alpha = 0.75;
    
    [toastView addSubview:carProgressImageView];
    
    if (status.length) {
        

        UILabel * infoLabel = [UILabel ms_labelWithFontSize:12.0f textColor:[UIColor whiteColor] title:status];
        
        infoLabel.numberOfLines = 0;
        infoLabel.textAlignment = NSTextAlignmentCenter;
        [toastView addSubview:infoLabel];
        
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(window);
            make.width.greaterThanOrEqualTo(@(95));
            make.height.greaterThanOrEqualTo(@(95));
            make.bottom.equalTo(infoLabel.mas_bottom).offset(5);
        }];
        
        [carProgressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(toastView.mas_top).offset(20);
            make.centerX.equalTo(toastView.mas_centerX).offset(-3);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(carProgressImageView.mas_width);
        }];
        
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(toastView).offset(3);
            make.right.equalTo(toastView).offset(-3);
            make.width.lessThanOrEqualTo(@(100));
            make.top.equalTo(carProgressImageView.mas_bottom).offset(3);
        }];
        
    }
    else{
        
        [toastView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(window);
            make.width.height.mas_equalTo(80);
        }];
        
        [carProgressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(toastView.mas_centerY);
            make.centerX.equalTo(toastView.mas_centerX);
            make.width.mas_equalTo(toastView.mas_width).offset(-10);
            make.height.mas_equalTo(carProgressImageView.mas_width).multipliedBy(1);
        }];
    }
    
    
    
    hudView = toastView;

    [UIView animateWithDuration:0.3 animations:^{
        toastView.alpha = 1.0f;
    }];
    
}


+ (void)showWithStatus:(NSString *)status {
    [self showWithStatus:status maskType:0];
}

+ (void)ms_dismiss {
    
    showCount--;
    
    if (showCount > 0) {
        
        return;
    }
    
    [SVProgressHUD dismiss];

    [[UIApplication sharedApplication].delegate window].userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        hudView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hudView removeFromSuperview];
        hudView = nil;
    });

}


@end
