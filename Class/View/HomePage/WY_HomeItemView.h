//
//  WY_HomeItemView.h
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/10.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_HomeItemView : UIControl
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *lblTitle;

- (void)bindViewWith:(UIImage *)image titleStr:(NSString *)titleStr ;
@end

NS_ASSUME_NONNULL_END
