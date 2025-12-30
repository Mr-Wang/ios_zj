//
//  MS_NewfeaturePageControl.m
//  MET
//
//  Created by Mrxiaowu on 16/5/16.
//  Copyright © 2016年 zheng. All rights reserved.
//

#import "MS_NewfeaturePageControl.h"
#define newfeatureImageCount 3
@interface MS_NewfeaturePageControl()
{ 
    
}


@end
@implementation MS_NewfeaturePageControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}
-(void) updateDots

{
    for (int i=0; i<[self.subviews count]; i++) {
        
        UIView* dot = [self.subviews objectAtIndex:i];
        CGSize size;
        size.height = 8;     //自定义圆点的大小
        size.width = 8;      //自定义圆点的大小
        
        if (i == self.currentPage) {
            size.height = 8;     //自定义圆点的大小
            size.width = 13;
        }
        
        [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.height)];
        
        UIImageView * img;
        if (dot.subviews.count) {
            
            img = [dot.subviews firstObject];
        }
        else{
            img = [UIImageView new];
//            img.frame = dot.bounds;
            [dot addSubview:img];
        }
        
        img.frame = dot.bounds;
         
    
    }
    
}
-(void) setCurrentPage:(NSInteger)page

{
    
    [super setCurrentPage:page];
    
    [self updateDots];
    
}


@end
