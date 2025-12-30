//
//  WY_AnnouncementView.h
//  MigratoryBirds
//
//  Created by Doj on 2018/6/27.
//  Copyright © 2018年 Doj. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WY_AnnouncementViewDelegate <NSObject>

@required
// cell 的contentTextField的文本发生改变时调用
- (void)Announcement:(NSInteger )idx;

@end


@interface WY_AnnouncementView : UIView


@property (weak, nonatomic) id<WY_AnnouncementViewDelegate> delegate;

-(void) titleArr:(NSArray *)titleArr;


@end
