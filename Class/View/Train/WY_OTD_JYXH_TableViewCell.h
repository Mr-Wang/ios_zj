//
//  WY_OTD_JYXH_TableViewCell.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2022/3/17.
//  Copyright © 2022 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface WY_OTD_JYXH_TableViewCell : UITableViewCell

@property (nonatomic , strong) UIView *viewTop1;
@property (nonatomic , strong) UIView *viewTop2;
@property (nonatomic , strong) UIView *viewTop3A;
@property (nonatomic , strong) UIView *viewTop3;

@property (nonatomic , strong) UIScrollView *scrollViewImgsTop1;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop2;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop3;
@property (nonatomic , strong) UIScrollView *scrollViewImgsTop3A;


@property (nonatomic , strong) NSMutableArray *arrEttachmentUrl;
@property (nonatomic , strong) NSMutableArray *arrEttachmentZhiCUrl;
@property (nonatomic , strong) NSMutableArray *arrEttachmentWorkUrl;
@property (nonatomic , strong) NSMutableArray *arrEttachmentAwardUrl;

@property (nonatomic,copy)void(^selEditEndImageBlock)(UIImage *imgEdit);
@property (nonatomic,copy)void(^selShareBlock)(NSString *fileName, NSString *fileUrl);
@property (nonatomic, strong) UIViewController * vcSender;
- (void)showCell;

@end

NS_ASSUME_NONNULL_END
