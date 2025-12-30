//
//  KeyChainStore.h
//  CsvClubPro
//
//  Created by Mac on 2019/10/16.
//  Copyright © 2019 王杨. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface KeyChainStore : NSObject
+ (void)save:(NSString*)service data:(id)data;
+ (id)load:(NSString*)service;
+ (void)deleteKeyData:(NSString*)service;
/**  获取UUID*/
+ (NSString *)getUUIDByKeyChain;
@end 
