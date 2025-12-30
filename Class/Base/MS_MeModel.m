//
//  MS_MeModel.m
//  AnCheDangBu
//
//  Created by 古玉彬 on 16/9/21.
//  Copyright © 2016年 ms. All rights reserved.
//

#import "MS_MeModel.h"


static MS_MeModel * _userModel = nil;

@implementation MS_MeModel


+ (instancetype)shareMeModel
{
    
    if (!_userModel) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _userModel = [[MS_MeModel alloc] init];
        
        });
        
    }
    
    return _userModel;
    
}


+ (void)setInstances:(id)obj {
    
    _userModel = nil;
    
    _userModel = obj;
}

+ (void)removeObj {
    
    _userModel = nil;
    
}

@end
