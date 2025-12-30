//
//  WY_PhotoTableViewCell.h
//  MigratoryBirds
//
//  Created by wangyang on 2018/6/30.
//  Copyright © 2018年 wangyang. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WY_PhotoTableViewCellDelegate <NSObject>

@required
// cell 的contentTextField的文本发生改变时调用
- (void)IndexPath:(NSIndexPath *)indexPath;
- (void)deleteIndex:(NSInteger)index;
@end


@interface WY_PhotoTableViewCell : UIView

@property (weak, nonatomic) id<WY_PhotoTableViewCellDelegate> delegate;


-(void)imgArr:(NSMutableArray *)imgArr maxCount:(int)mCount;


@end
