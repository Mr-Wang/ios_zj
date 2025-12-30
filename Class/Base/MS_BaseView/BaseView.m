//
//  BaseView.m
//  JiangJ
//
//  Created by pinjiang on 30/3/18.
//  Copyright © 2018年 jsmysoft. All rights reserved.
//

#import "BaseView.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>
#import "AppDelegate.h"
@interface BaseView()<UIActionSheetDelegate>
{
    SheetSelectedBlock _block;
}
@end
@implementation BaseView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



-(BOOL)existString:(NSString *)string
{
    BOOL flag = NO;
    if (string&&string.length&&![string isEqualToString:@"<null>"]) {
        flag = YES;
    }
    return flag;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


-(void)setupRefresh:(UITableView *)tableView withTarget:(id)target
{
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:@selector(headerRereshing)];
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:@selector(footerRereshing)];
}

-(UIView *)createSheetViewWithTitles:(NSArray *)titles
                               block:(SheetSelectedBlock)block
{
    _block = block;
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: nil];
    for (NSString * title in titles) {
        [sheet addButtonWithTitle:title];
    }
    return sheet;
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector])//ios8
    {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]])
        {
            alertController.view.tintColor = [UIColor darkGrayColor];
        }
    }
    else//ios7
    {
        for( UIView * subView in actionSheet.subviews )
        {
            if( [subView isKindOfClass:[UIButton class]] )
            {
                UIButton * btn = (UIButton*)subView;
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
        }
    }
    
}
-(void)headerRereshing
{
    
}
-(void)footerRereshing
{
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        buttonIndex = -10;
    }
    if (_block)
    {
        _block(buttonIndex);
    }
}


-(void)dealloc
{
    NSLog(@"视图  %@   已摧毁\n",NSStringFromClass([self class]));
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
