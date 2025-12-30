//
//  ImageNewsDetailViewController.m
//  JiTongNews
//
//  Created by 王杨 on 14-11-11.
//  Copyright (c) 2014年 王杨. All rights reserved.
//

#import "ImageNewsDetailViewController.h"

@interface ImageNewsDetailViewController ()

@end

@implementation ImageNewsDetailViewController
@synthesize mIWPictureModel = _mIWPictureModel;
@synthesize mKlImg = _mKlImg;
 @synthesize picArr = _picArr;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"查看图片";
     
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self initMyView];
    int selectedIndex = 0;
    if (self.mIWPictureModel) {
        selectedIndex = (int)[self.picArr indexOfObject:self.mIWPictureModel];
    }
    [_mKlImg updateImageDate:self.picArr selectIndex:selectedIndex];
}

- (void)initMyView
{
    _mKlImg = [[KL_ImagesZoomController alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - JCNew64  - JC_TabbarSafeBottomMargin)imgViewSize:CGSizeZero];
    [self.view addSubview:_mKlImg];    
 }


/* 使用KL  End*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backBtnClick {
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (void)headRightAction {
    NSLog(@"点击了右上角按钮");
}
 
@end
