//
//  IWPictureModel.m
//  iPlanner_IOS
//
//  Created by 王杨 on 15-4-6.
//  Copyright (c) 2015年 王杨. All rights reserved.
//

#import "IWPictureModel.h"

@implementation IWPictureModel
@synthesize nsbmiddle_pic,nsid,nsoriginal_pic,nssize_preview,nsthumbnail_pic;

- (void)setJsonPostPictureDateModel:(NSDictionary*)jsonDic {
    self.nsbmiddle_pic = [jsonDic objectForKey:@"bmiddle_pic"];
    self.nsid = [[jsonDic objectForKey:@"id"] intValue];
    self.nsoriginal_pic = [jsonDic objectForKey:@"original_pic"];
    self.nsthumbnail_pic = [jsonDic objectForKey:@"thumbnail_pic"];
    NSArray *arrSize =  [jsonDic objectForKey:@"size_preview"];
    float picWidth = 0;
    float picHeight = 0;
    if  (arrSize != nil && (NSNull *)arrSize != [NSNull null] && arrSize.count > 0) {
        picWidth = [[arrSize objectAtIndex:0] floatValue];
        picHeight = [[arrSize objectAtIndex:1] floatValue];        
    } else {
        picWidth = 100;
        picHeight = 100;
    }    
    self.nssize_preview = CGSizeMake(picWidth, picHeight);
}

@end
