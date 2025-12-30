//
//  WY_SelMajorView.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/15.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WY_SelMajorView.h"
#import "WY_MajorPhotoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WY_SelMajorView : UIView
@property (nonatomic ,strong) UIControl *colSelType;
@property (nonatomic ,strong) UILabel *lblType;
@property (nonatomic ,strong) UIImageView *imgAcc;
@property (nonatomic ,strong) UILabel *lblTs1;
@property (nonatomic ,strong) UILabel *lblTs2;
//是否主评专业
@property (nonatomic ,strong) UILabel *lblIsZp;

@property (nonatomic ,strong) UILabel *lblTs3;
@property (nonatomic ,strong) NSMutableArray *arrZczs;
@property (nonatomic ,strong) NSMutableArray *arrZgzs;
@property (nonatomic ,strong) UIButton *btnDelMajor;
//老专业-professionCode 集合 拼接
@property (nonatomic ,strong) NSString *sCode;
//老专业实体
@property (nonatomic ,strong) WY_MajorPhotoModel *oldModel;

//职称证书
@property (nonatomic ,strong) UIScrollView *scrollViewZczs;
//资格证书
@property (nonatomic ,strong) UIScrollView *scrollViewZgzs;
@property (nonatomic ,strong) WY_MajorPhotoModel *mWY_MajorPhotoModel;
@property (nonatomic,copy) void(^selPicItemBlock)(int rowIndex,NSMutableArray *arrUrls);

@property (nonatomic,copy) void(^addZczsPicItemBlock)(WY_SelMajorView *smView);

@property (nonatomic,copy) void(^addZgzsPicItemBlock)(WY_SelMajorView *smView);
@property (nonatomic,copy) void(^lblIsZpBlock)(WY_SelMajorView *smView);

@property (nonatomic) int rowIndex;

@property (nonatomic, strong) NSMutableArray *arrGylh;
@property (nonatomic, strong) NSMutableArray *arrGylhStrs;
@property (nonatomic, strong) NSMutableArray *arrLcss;
@property (nonatomic, strong) NSMutableArray *arrLcssStrs; 
@property (nonatomic) NSInteger selIndexGylh;
@property (nonatomic) NSInteger selIndexLcss;

@property (nonatomic, strong) NSMutableArray *arrXiBie;
@property (nonatomic, strong) NSMutableArray *arrXiBieStrs;
@property (nonatomic) NSInteger selIndexXiBie;
@property (nonatomic , strong) NSString *jujueContent;
@property (nonatomic, strong) NSString * reason;
@property (nonatomic) BOOL canEdit;
@property (nonatomic) BOOL canBFEdit;
//1是新入库专家
@property (nonatomic) int isFormal;

- (void)showCellByModel:(WY_MajorPhotoModel *)withMajorPhotoModel;
- (void)showNewCellByModel:(WY_MajorPhotoModel *)withMajorPhotoModel;
- (void)showOldCellByModel:(WY_MajorPhotoModel *)withMajorPhotoModel;

/// 初始化职称证书Imgs
- (void)initZczsImgs;
- (void)initZgzsImgs;
@end

NS_ASSUME_NONNULL_END
