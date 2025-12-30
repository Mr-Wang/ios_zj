//
//  MS_GYBBase64.m
//  TestDes
//
//  Created by 古玉彬 on 16/4/20.
//  Copyright © 2016年 ms. All rights reserved.
//

#import "MS_GYBBase64.h"
#define C2I(c) ((c >= '0' && c<='9') ? (c-'0') : ((c >= 'a' && c <= 'z') ? (c - 'a' + 10): ((c >= 'A' && c <= 'Z')?(c - 'A' + 10):(-1))))

@interface MS_GYBBase64 ()
+(int)char2Int:(char)c;
@end
@implementation MS_GYBBase64
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+(NSString *)encode:(NSData *)data
{
    if (data.length == 0)
        return nil;
    
    char *characters = malloc(data.length * 3 / 2);
    
    if (characters == NULL)
        return nil;
    
    int end = data.length - 3;
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == data.length - 2)
    {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == data.length - 1)
    {
        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
    
}

+(NSData *)decode:(NSString *)data
{
    if(data == nil || data.length <= 0) {
        return nil;
    }
    NSMutableData *rtnData = [[NSMutableData alloc]init];
    int slen = data.length;
    int index = 0;
    while (true) {
        while (index < slen && [data characterAtIndex:index] <= ' ') {
            index++;
        }
        if (index >= slen || index  + 3 >= slen) {
            break;
        }
        
        int byte = ([self char2Int:[data characterAtIndex:index]] << 18) + ([self char2Int:[data characterAtIndex:index + 1]] << 12) + ([self char2Int:[data characterAtIndex:index + 2]] << 6) + [self char2Int:[data characterAtIndex:index + 3]];
        Byte temp1 = (byte >> 16) & 255;
        [rtnData appendBytes:&temp1 length:1];
        if([data characterAtIndex:index + 2] == '=') {
            break;
        }
        Byte temp2 = (byte >> 8) & 255;
        [rtnData appendBytes:&temp2 length:1];
        if([data characterAtIndex:index + 3] == '=') {
            break;
        }
        Byte temp3 = byte & 255;
        [rtnData appendBytes:&temp3 length:1];
        index += 4;
        
    }
    return rtnData;
}

+(int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}

+ (NSData *)hexDataFromStr:(NSString *)str {

    const char* cs = str.UTF8String;
    
    int count = strlen(cs);
    
    int8_t bytes[count / 2];
    
    for(int i = 0; i<count; i+=2)
        
    {
        
        char c1 = *(cs + i);
        
        char c2 = *(cs + i + 1);
        
        if(C2I(c1) >= 0 && C2I(c2) >= 0)
            
        {
            
            bytes[i / 2] = C2I(c1) * 16 + C2I(c2);
            
        }
        
        else
            
        {
            
            return nil;
            
        }
        
    }
    
    return [NSData dataWithBytes:bytes length:count / 2];
    

}

+ (int)binaryToDecimal:(NSData *)data {
    
    const char * bstr =[data bytes];
    int d = 0;
    unsigned int len = strlen(bstr);
    
    if (len > 32)
        return -1;  //数位过长
    len--;
    
    int i = 0;
    for (i = 0; i <= len; i++)
    {
        d += (bstr[i] - '0') * (1 << (len - i));
    }
    
    return d;
}

+ (NSString *)ToHexStrWithBinData:(NSData *)data {
//    long long int tmpid = [self binaryToDecimal:data];
//    NSString *nLetterValue;
//    NSString *str =@"";
//    long long int ttmpig;
//    for (int i = 0; i<9; i++) {
//        ttmpig=tmpid%16;
//        tmpid=tmpid/16;
//        switch (ttmpig)
//        {
//            case 10:
//                nLetterValue =@"A";break;
//            case 11:
//                nLetterValue =@"B";break;
//            case 12:
//                nLetterValue =@"C";break;
//            case 13:
//                nLetterValue =@"D";break;
//            case 14:
//                nLetterValue =@"E";break;
//            case 15:
//                nLetterValue =@"F";break;
//            default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
//                
//        }
//        str = [nLetterValue stringByAppendingString:str];
//        if (tmpid == 0) {
//            break;
//        }
//        
//    }
//    return str;
//    
    if (!data) {
        return nil;
    }
    Byte *bytes = (Byte *)[data bytes];
    NSMutableString *str = [NSMutableString stringWithCapacity:data.length * 2];
    for (int i=0; i < data.length; i++){
        
        [str appendFormat:@"%0x", bytes[i]];
    }
    return [str uppercaseString];
    
//    Byte * bytes = [data bytes];
//    NSMutableString *hexStr = [[NSMutableString alloc]init];
//    int i = 0;
//    if(bytes)
//    {
//        while (bytes[i] != '\0')
//        {
//            NSString *hexByte = [NSString stringWithFormat:@"%x",bytes[i] & 0xff];///16进制数
//            if([hexByte length]==1)
//                [hexStr appendFormat:@"0%@", hexByte];
//            else
//                [hexStr appendFormat:@"%@", hexByte];
//            
//            i++;
//        }
//    }
//    return [hexStr uppercaseString];
}
@end
