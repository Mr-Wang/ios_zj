//
//  WY_FilterTreeItemView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/1/14.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_FilterTreeItemView.h"

@implementation WY_FilterTreeItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self makeUI];
      }
    return self;
}

- (void)makeUI {
    self.btnItem = [[UIButton alloc] initWithFrame:CGRectMake(k360Width(16), 0, k360Width(170), k360Width(22))];
    self.btnZhanKai = [[UIButton alloc] initWithFrame:CGRectMake(self.btnItem.right + k360Width(16), 0, k360Width(22), k360Width(22))];
    [self.btnItem setImage:[UIImage imageNamed:@"icon_checkbox_s"] forState:UIControlStateNormal];
    [self.btnItem setImage:[UIImage imageNamed:@"icon_checkbox_lxx"] forState:UIControlStateSelected];
    [self.btnItem setTitleEdgeInsets:UIEdgeInsetsMake(0, k360Width(5), 0, 0)];
    [self.btnZhanKai setImage:[UIImage imageNamed:@"accup"] forState:UIControlStateNormal];
    [self.btnZhanKai setImage:[UIImage imageNamed:@"accdown"] forState:UIControlStateSelected];
    [self addSubview:self.btnItem];
    [self addSubview:self.btnZhanKai];
}
- (void)showCellByItem:(WY_FilterTreeModel *)itemModel {
    self.mWY_FilterTreeModel = itemModel;
    [self.btnItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnItem setSelected:itemModel.isSel];
    [self.btnZhanKai setSelected:itemModel.isOpen];
    self.btnItem.frame = CGRectMake(k360Width(16), 0, k360Width(230), k360Width(44));
 
    [self.btnItem setTitle:itemModel.nsTitle forState:UIControlStateNormal];
    [self.btnItem.titleLabel setFont:WY_FONTMedium(14)];
    [self.btnItem.titleLabel setNumberOfLines:0];
    [self.btnItem.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.btnItem.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [self.btnItem setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
 
    CGSize btnItemTitleSize = [self mh_stringSizeWithFont:WY_FONTMedium(14) str:itemModel.nsTitle maxWidth:k360Width(230) maxHeight:k360Width(44)];
//    [self.btnItem setBackgroundColor:[UIColor redColor]];
    self.btnItem.width = btnItemTitleSize.width + k360Width(44);
    self.btnZhanKai.frame = CGRectMake(btnItemTitleSize.width + k360Width(44) + k360Width(16), 0, k360Width(44), k360Width(44));
    if (itemModel.arrChilds == nil) {
        [self.btnZhanKai setHidden:YES];
    }
    
    [self.btnItem addTarget:self action:@selector(btnItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnZhanKai addTarget:self action:@selector(btnZhanKaiAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btnItemAction:(UIButton *)btnSender {
    [btnSender setSelected:!btnSender.selected];
    self.mWY_FilterTreeModel.isSel = btnSender.selected;
    if (self.selItemBlock) {
        self.selItemBlock(self.mWY_FilterTreeModel);
    }
}

- (void)btnZhanKaiAction:(UIButton *)btnSender {
    [btnSender setSelected:!btnSender.selected];
    self.mWY_FilterTreeModel.isOpen = btnSender.selected;
    if (self.selOpenOrCloseBlock) {
        self.selOpenOrCloseBlock(self.mWY_FilterTreeModel);
    }
}

- (CGSize)mh_stringSizeWithFont:(UIFont *)font str:(NSString*)str maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    CGSize maxSize = CGSizeMake(maxWidth, maxHeight);
    attr[NSFontAttributeName] = font;
    return [str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attr context:nil].size;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
