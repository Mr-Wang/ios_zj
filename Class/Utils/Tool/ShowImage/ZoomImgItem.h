//
//  ZoomImgItem.h
//  ShowImgDome
//
//  Created by chuliangliang on 14-9-28.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KL_ImageZoomView.h"
//#import "XHCacheManager.h"

@interface ZoomImgItem : UITableViewCell
{
    KL_ImageZoomView *imageView;
}

@property (nonatomic, retain)NSString *imgName;
@property (nonatomic, retain)NSString *imgPictures;
@property (nonatomic, assign)CGSize imgSize;
@property (nonatomic, assign)CGSize size;

@end
