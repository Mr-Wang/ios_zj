//
//  BaseView.h
//  JiangJ
//
//  Created by pinjiang on 30/3/18.
//  Copyright © 2018年 jsmysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
typedef void (^SheetSelectedBlock)(NSInteger index);
@interface BaseView : UIView

@property (nonatomic,strong)id target;

-(BOOL)existString:(NSString *)string;

-(void)setupRefresh:(UITableView *)tableView withTarget:(id)target;
-(UIView *)createSheetViewWithTitles:(NSArray *)titles
                               block:(SheetSelectedBlock)block;


@end
