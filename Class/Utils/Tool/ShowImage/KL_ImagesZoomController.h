//
//  KL_ImagesZoomController.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWPictureModel.h"
//#import "NewsPagesDataModel.h"
//#import "MagazinesPagesModel.h"

@protocol KL_ImagesZoomControllerDelegate;

@interface KL_ImagesZoomController : UIView<UITableViewDelegate,UITableViewDataSource>
- (id)initWithFrame:(CGRect)frame imgViewSize:(CGSize)size;
@property (nonatomic, retain)NSMutableArray *objs;
@property (nonatomic) int myCellIndex;
@property (nonatomic,assign,setter = setDelegate:) id<KL_ImagesZoomControllerDelegate> delegate;

- (void)updateImageDate:(NSArray *)imageArr selectIndex:(NSInteger)index;
@end

@protocol KL_ImagesZoomControllerDelegate <NSObject>

@optional
- (void)KL_ImagesPageRun:(int)pageIndex;

@end
