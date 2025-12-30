//
//  SVProgressHUD+MS_SVProgressHUD.h
//  AnCheDangBu
//
//  Created by 古玉彬 on 16/12/3.
//  Copyright © 2016年 ms. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (MS_SVProgressHUD)

+ (void)showWithStatus:(NSString*)status maskType:(SVProgressHUDMaskType)maskType;

+ (void)ms_dismiss;


@end
