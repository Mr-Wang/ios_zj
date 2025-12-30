//
//  MSBasicModel.m
//  weibu
//
//  Created by 古玉彬 on 16/1/11.
//  Copyright © 2016年 msql. All rights reserved.
//

#import "MS_BasicModel.h"

@implementation MS_BasicModel

- (NSString *)uid {
    if (!_uid.length) {
        
        _uid = [[NSUUID UUID] UUIDString];
    }
    
    return _uid;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}


- (BOOL)shouldUpdateHeight {
    
    if (_shouldUpdateHeight) {
        
        return YES;
        _shouldUpdateHeight = NO;
    }
    
    return _shouldUpdateHeight;
}


- (NSString *)expendStr {
    if (self.isExpend) {
        _expendStr = @"expend";
    }
    else{
        _expendStr = @"noexpend";
    }
    
    return _expendStr;
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    
    //处理string 为null
    if(property.type.typeClass == [NSString class]) {
        
        if (oldValue == nil || [oldValue isKindOfClass:[NSNull class]]) {
            
            return @"";
        }
    }
    
    return oldValue;
}

@end
