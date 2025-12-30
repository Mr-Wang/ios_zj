//
//  IWPictureModel.h
//  iPlanner_IOS
//
//  Created by 王杨 on 15-4-6.
//  Copyright (c) 2015年 王杨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IWPictureModel : NSObject
@property (nonatomic, retain) NSString *nsbmiddle_pic;
@property (nonatomic) int nsid;
@property (nonatomic, retain) NSString *nsoriginal_pic;
@property (nonatomic) CGSize nssize_preview;
@property (nonatomic, retain) NSString *nsthumbnail_pic;
@property (nonatomic, retain) UIImage *img_pic;
- (void)setJsonPostPictureDateModel:(NSDictionary*)jsonDic;
@end
