//
//  MS_GYBDesEncode.m
//  chetizi
//
//  Created by 古玉彬 on 16/4/20.
//  Copyright © 2016年 msl. All rights reserved.
//

#import "MS_GYBDesEncode.h"
//引入IOS自带密码库
#import <CommonCrypto/CommonCryptor.h>
#import "MS_GYBBase64.h"
//空字符串
#define     LocalStr_None           @""

//KEY 密钥
static const NSString * key = @"keycansr";
//对称串
static const NSString * fal = @"asdewqrf";

const Byte iv[] = {'a','s','d','e','w','q','r','f'};

@implementation MS_GYBDesEncode



+ (NSString *)encodeStr:(NSString *)dataString {
    
    if (dataString && ![dataString isEqualToString:LocalStr_None]) {
        
        NSString *ciphertext = nil;
        NSData *textData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [textData length];
        unsigned char buffer[1024 * 10];
        memset(buffer, 0, sizeof(char));
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding,
                                              [key UTF8String], kCCKeySizeDES,
                                              iv,
                                              [textData bytes], dataLength,
                                              buffer, 1024 * 10,
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            
            NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
//            ciphertext = [MS_GYBBase64 ToHexStrWithBinData:data];
//            ciphertext = [MS_GYBBase64 encode:data];
            ciphertext = [data base64Encoding];
        }
        return ciphertext;
    }
    else {
        return LocalStr_None;
    }
    
    return nil;
}


+ (NSString *)decodeStr:(NSString *)dataString {
    
    if (![dataString isKindOfClass:[NSString class]]) {
        return LocalStr_None;
    }
    if (dataString && ![dataString isEqualToString:LocalStr_None]) {
        
        NSString *plaintext = nil;
//        NSData *cipherdata = [MS_GYBBase64 hexDataFromStr:dataString];
        NSData * cipherdata  = [MS_GYBBase64 decode:dataString];
        unsigned char buffer[1024 * 2];
        memset(buffer, 0, sizeof(char));
        size_t numBytesDecrypted = 0;
        // kCCOptionPKCS7Padding|kCCOptionECBMode 最主要在这步
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding,
                                              [key UTF8String], kCCKeySizeDES,
                                              iv,
                                              [cipherdata bytes], [cipherdata length],
                                              buffer, 1024 * 2,
                                              &numBytesDecrypted);
        if(cryptStatus == kCCSuccess) {
            NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
            plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
        }
        return plaintext;
        
    }
    else {
        return LocalStr_None;
    }
}



@end
