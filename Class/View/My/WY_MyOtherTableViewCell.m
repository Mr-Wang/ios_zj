//
//  WY_MyOtherTableViewCell.m
//  DormitoryManagementPro
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "WY_MyOtherTableViewCell.h"

@implementation WY_MyOtherTableViewCell
 

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self addSubViews];
             
        [self p_addMasonry];
               
        
    }
    return self;
}



-(void)addSubViews{
    self.rightLab = [UILabel new];
    [self.contentView addSubview:self.logoImg];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.rImg];
      [self.contentView addSubview:self.lineView];

    [self.contentView addSubview:self.rightLab];
    
}


#pragma mark - # Private Methods
- (void)p_addMasonry {
    
    
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kWidth(24*2));
        make.width.height.mas_equalTo(kHeight(22*2));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    // 标题title
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImg.mas_right).mas_offset(kWidth(14*2));
        make.height.mas_equalTo(kHeight(24*2));
        make.centerY.mas_equalTo(self.contentView);
    }];
    // 向右按钮
    [self.rImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kWidth(18*2));
        make.width.mas_equalTo(kWidth(22*2));
        make.height.mas_equalTo(kWidth(22*2));
        make.centerY.mas_equalTo(self.contentView);
    }]; 
    // 线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
  
    // 向右按钮
       [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.mas_equalTo(-kWidth(48*2));
           make.width.mas_equalTo(kWidth(82*2));
           make.height.mas_equalTo(kWidth(22*2));
           make.centerY.mas_equalTo(self.contentView);
       }];
 
}

#pragma mark - # Getter
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
 
        [_titleLab setFont:WY_FONTMedium(14)];

    }
    return _titleLab;
}
 
- (UIImageView *)rImg {
    if (!_rImg) {
        _rImg = [[UIImageView alloc] init];
        _rImg.image = [UIImage imageNamed:@"servicedetail_btn_in"];
    }
    return _rImg;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = MSColor(242, 242, 242);
    }
    return _lineView;
    
}

-(UIImageView *)logoImg{
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] init];
    }
    return _logoImg;
}


@end
