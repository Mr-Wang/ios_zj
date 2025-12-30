//
//  WY_HomeArticleItemView.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/8/18.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_HomeArticleItemView.h"
#import "WY_WLTools.h"

@implementation WY_HomeArticleItemView

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
        
    
    self.imgBg = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.imgBg];
    [self.imgBg setImage:[UIImage imageNamed:@"0818_syB1"]];
    
    self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(5), k360Width(5), self.width - k360Width(10), k360Width(50))];
    
    self.lblContent = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(5), k360Width(55), self.width - k360Width(10), k360Width(55))];
    
    self.lblDate = [[UILabel alloc] initWithFrame:CGRectMake(k360Width(5), self.height - k360Width(24), self.width - k360Width(14), k360Width(20))];
    self.lblContent.height = self.lblDate.top- self.lblContent.top;
    
    [self.lblTitle setNumberOfLines:2];
    [self.lblContent setNumberOfLines:2];
    [self.lblDate setNumberOfLines:1];
      
    [self.lblTitle setTextColor:[UIColor whiteColor]];
    [self.lblContent setTextColor:HEXCOLOR(0x767676)];
    [self.lblDate setTextColor:HEXCOLOR(0x767676)];
     
    
    [self addSubview:self.lblTitle];
    [self addSubview:self.lblContent];
    [self addSubview:self.lblDate];
    
    [self.lblTitle setFont:WY_FONTMedium(14)];
    [self.lblContent setFont:WY_FONTMedium(14)];
    [self.lblDate setFont:WY_FONTMedium(14)];
    [self.lblDate setTextAlignment:NSTextAlignmentRight];
}

- (void)showCellByItem:(WY_InfomationModel *)withModel {
    self.mWY_InfomationModel = withModel;
    NSString *typeStr = [WY_WLTools categoryStringByNum:withModel.categorynum];

    self.lblTitle.text = [NSString stringWithFormat:@"【%@】\n%@",typeStr,withModel.title];
    // 将HTML字符串转换为NSAttributedString
       NSDictionary *options = @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType };
       NSData *data = [withModel.infocontent dataUsingEncoding:NSUnicodeStringEncoding];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    [attrString setYy_font:WY_FONTMedium(14)];
    [attrString setYy_color:HEXCOLOR(0x767676)];
    
    
       // 将转义后的字符串赋值给UILabel
       self.lblContent.attributedText = attrString;
    
//    self.lblContent.attributedText = [[NSMutableAttributedString alloc] initWithString:[self filterHTML:withModel.infocontent]];// withModel.infocontent;
    self.lblDate.text = withModel.infodate;
    
    if (withModel.infodate.length > 10) {
            self.lblDate.text = [NSString stringWithFormat:@"%@",[withModel.infodate  substringToIndex:10]];
    } else {
        self.lblDate.text = [NSString stringWithFormat:@"%@",withModel.infodate] ;
    }
    
}
 
-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
//    NSString * regEx = @"<([^>]*)>";
//    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
@end
