//
//  MS_PhotoCarCollectionViewCell.m
//  MigratoryBirds
//
//  Created by Doj on 2018/6/30.
//  Copyright © 2018年 Doj. All rights reserved.
//

#import "MS_PhotoCarCollectionViewCell.h"

@implementation MS_PhotoCarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubviews];
        [self p_addMasonry];
    }
    
    return self;
}

-(void)addSubviews{
    
    [self.contentView addSubview:self.addPhoto];
    [self.addPhoto addSubview:self.deletePhoto];
}


-(void)p_addMasonry{
    
    // 灰色view
    [self.addPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    //删除图片
    [self.deletePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(self.addPhoto.top).mas_offset(3);
        make.right.mas_offset(self.addPhoto.right).mas_offset(-3);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
        
    }];
    
}


-(UIImageView *)addPhoto{
    if (!_addPhoto) {
        _addPhoto = [[UIImageView alloc] init];
        _addPhoto.userInteractionEnabled = YES;
        _addPhoto.image = [UIImage imageNamed:@"service_btn_addphoto"];
        
    }
    return _addPhoto;
}

-(UIButton *)deletePhoto{
    if (!_deletePhoto) {
        _deletePhoto = [[UIButton alloc] init];
        [_deletePhoto setImage:[UIImage imageNamed:@"service_btn_photodelete"] forState:(UIControlStateNormal)];
        
    }
    return _deletePhoto;
}

@end
