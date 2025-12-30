//
//  WY_selPicView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WY_selPicView : UIView
@property (nonatomic, strong) UIButton *btnImg;
@property (nonatomic, strong) UIButton *btnDel;
@property (nonatomic) int rowIndex;


- (void)showCellByImgUrl:(NSString *)withImgUrl ByIsDel:(BOOL) isDel;
@end

NS_ASSUME_NONNULL_END
