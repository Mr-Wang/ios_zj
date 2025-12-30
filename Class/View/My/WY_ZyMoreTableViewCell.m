//
//  WY_ZyMoreTableViewCell.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/6/28.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_ZyMoreTableViewCell.h"

@implementation WY_ZyMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
        [self.colSender setUserInteractionEnabled:NO];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        self.userInteractionEnabled = YES;
        [self makeUI];
        [self.colSender setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)makeUI {
    [self setBackgroundColor:HEXCOLOR(0xFAFAFA)];
//    self.colSender = [[UIControl alloc] init];
    self.lblTitle = [UILabel new];
    [self.lblTitle setFrame:CGRectMake(k375Width(10), k375Width(5), k375Width(200),  k375Width(30))];
    [self.lblTitle setFont:[UIFont fontWithName:@"Source Han Sans SC" size:k375Width(14)]];
    [self.lblTitle setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.lblTitle];
     
    self.lblRight1 = [UILabel new];
    [self.lblRight1 setFrame:CGRectMake(k375Width(5), k375Width(5), kScreenWidth - k375Width(20),  k375Width(30))];
    [self.lblRight1 setFont:[UIFont fontWithName:@"Source Han Sans SC" size:k375Width(14)]];
    [self.lblRight1 setTextColor:[UIColor blackColor]];
    [self.lblRight1 setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.lblRight1];
     
    
    
    self.lblStatus = [UILabel new];
    [self.lblStatus setFrame:CGRectMake(k375Width(10),self.lblTitle.bottom + k375Width(10), kScreenWidth, k375Width(30))];
    [self.lblStatus setFont:[UIFont fontWithName:@"Source Han Sans SC" size:k375Width(14)]];
    [self.lblStatus setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:self.lblStatus];
    
    self.lblRight2 = [UILabel new];
    [self.lblRight2 setFrame:CGRectMake(k375Width(5), self.lblTitle.bottom + k375Width(10), kScreenWidth - k375Width(20),  k375Width(30))];
    [self.lblRight2 setFont:[UIFont fontWithName:@"Source Han Sans SC" size:k375Width(14)]];
    [self.lblRight2 setTextColor:[UIColor blackColor]];
    [self.lblRight2 setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.lblRight2];
    
    self.imgLineA = [UIImageView new];
    [self.imgLineA setFrame:CGRectMake(0, self.lblRight2.bottom + k360Width(10), kScreenWidth, k360Width(1))];
    [self.imgLineA setBackgroundColor:APPLineColor];
    [self.contentView addSubview:self.imgLineA];
    
}
- (void)showCellByItem:(NSDictionary *)withWY_CurZyModel withInt:(int)withInt
{
    self.lblTitle.text = @"专家专业:";
    self.lblStatus.text = @"批准时间";
    self.height = self.lblStatus.bottom + k375Width(10);
    NSMutableString *strValue = [[NSMutableString alloc] init];
    int i = 0;
    NSMutableArray *arrAexPro = [[NSMutableArray alloc] initWithArray:withWY_CurZyModel[@"aexpertProfessions"]];
    for (NSDictionary *dicItem in arrAexPro) {
        
        [strValue appendString: [NSString stringWithFormat:@"%d.%@",i+1,dicItem[@"professionName"]]];
        if  (i < arrAexPro.count - 1) {
            [strValue appendString:@"\n"];
        }
        i ++;
    }
    
    self.lblRight1.text = strValue;
    [self.lblRight1 setFrame:CGRectMake(k375Width(16), self.lblTitle.bottom, kScreenWidth - k360Width(32), k360Width(30))];
    [self.lblRight1 setNumberOfLines:0];
    [self.lblRight1 setLineBreakMode:NSLineBreakByWordWrapping];
    [self.lblRight1 sizeToFit];
    
    [self.lblRight2 setTop:self.lblRight1.bottom + k360Width(10)];
    [self.lblStatus setTop:self.lblRight1.bottom + k360Width(10)];
    self.lblRight2.text = withWY_CurZyModel[@"approvalTime"];
    
    [self.imgLineA setFrame:CGRectMake(0, self.lblRight2.bottom + k360Width(10), kScreenWidth, k360Width(1))];

    self.height = self.imgLineA.bottom;
}

@end
