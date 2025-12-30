//
//  ImageNewsDetailViewController.h
//  JiTongNews
//
//  Created by 王杨 on 14-11-11.
//  Copyright (c) 2014年 王杨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWPictureModel.h"
#import "KL_ImageZoomView.h"
#import "KL_ImagesZoomController.h"

@interface ImageNewsDetailViewController : UIViewController {
}

@property (nonatomic, retain) IWPictureModel* mIWPictureModel;
@property (nonatomic, retain) IBOutlet UIButton *btnBack;
@property (nonatomic, retain) KL_ImagesZoomController *mKlImg;
@property (nonatomic, retain) NSMutableArray *picArr;

 @end
