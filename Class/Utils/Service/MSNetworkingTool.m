//
//  MSNetworkingTool.m
//  weibu
//
//  Created by lidong on 16/1/8.     
//  Copyright © 2016年 msql. All rights reserved.
//

#import "MSNetworkingTool.h"
#import "MS_CommonTool.h"
#import "NSDate+InternetDateTime.h"

@class MS_BasicDataController;
@implementation MSNetworkingTool


+ (void)load {
    
    //开启网络状态监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params jsonData:(NSData *)jsonData success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    //如果有用户登录 ，参数中加入userid 和  header中加入 token
       if([MS_BasicDataController sharedInstance].user && [MS_BasicDataController sharedInstance].user.UserGuid.length > 0) {
           NSMutableDictionary *dicPost = nil;
           if (!params) {
                dicPost = [[NSMutableDictionary alloc] init];
           } else {
               dicPost = [[NSMutableDictionary alloc] initWithDictionary:params];

           }
           [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
           params = dicPost;
       }
    NSLog(@"请求URL：%@ \n post请求参数：%@",url,params);
       
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:url];
    if (jsonData && params) {
        [urlStr appendFormat:@"?"];
        for (NSString *dicKey in params.allKeys) {
            if (![dicKey isEqualToString: [params.allKeys firstObject]]) {
                [urlStr appendFormat:@"&"];
            }
            [urlStr appendFormat:@"%@=%@",dicKey,[params[dicKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:params error:nil];
    if (jsonData) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // 设置body
        [request setHTTPBody:jsonData];
        [request setTimeoutInterval:60.0];
    }
    //如果有用户登录 ，参数中加入userid 和  header中加入 token
    if([MS_BasicDataController sharedInstance].user && [MS_BasicDataController sharedInstance].user.UserGuid.length > 0) {
         [request setValue:[MS_BasicDataController sharedInstance].user.token forHTTPHeaderField:@"token"];
        [request setValue:[MS_BasicDataController sharedInstance].user.UserGuid forHTTPHeaderField:@"UserGuid"];
    }
    [request setValue:@"1" forHTTPHeaderField:@"isZjapp"];
    [request setValue:[GlobalConfig appVersion] forHTTPHeaderField:@"curAppVersionCode"];
    [request setValue:@"iOS" forHTTPHeaderField:@"systemType"];
    
    AFHTTPResponseSerializer * responceSerializer = [AFHTTPResponseSerializer serializer];
    responceSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
    
    [mgr setResponseSerializer:responceSerializer];

    
    [[mgr dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSHTTPURLResponse *responseA = (NSHTTPURLResponse *)response;
            NSDictionary *allHeaders = responseA.allHeaderFields;
            NSString *dateServer = [allHeaders objectForKey:@"Date"];
            // 转换方法
            NSDate *inputDate = [NSDate dateFromRFC822String:dateServer];
            //存储服务器时间；
            [NSDate wySetServerTime:inputDate];
            if (success) {
                success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
            }
        }
        else {
            NSString *errorCode = error.userInfo[@"NSLocalizedDescription"];
            
            if (([url rangeOfString:BASE_IP].length > 0 || [url rangeOfString:BASE_ZJ_IP].length > 0) && [errorCode rangeOfString:@"401"].length > 0) {
                NSLog(@"没有登录, 跳转登录页");
                NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
                [notifyCenter postNotificationName:NOTIFY_RELOGIN object:nil];
            }
            if (failure) {
                failure(error);
            }
        }
    }] resume];
}


+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params jsonData:(NSData *)jsonData success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    //如果有用户登录 ，参数中加入userid 和  header中加入 token
       if([MS_BasicDataController sharedInstance].user && [MS_BasicDataController sharedInstance].user.UserGuid.length > 0) {
           NSMutableDictionary *dicPost = nil;
           if (!params) {
                dicPost = [[NSMutableDictionary alloc] init];
           } else {
               dicPost = [[NSMutableDictionary alloc] initWithDictionary:params];

           }
           [dicPost setObject:[MS_BasicDataController sharedInstance].user.UserGuid forKey:@"UserGuid"];
           params = dicPost;
       }
    NSLog(@"请求URL：%@ \n post请求参数：%@",url,params);
       
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:params error:nil];
    if (jsonData) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // 设置body
        [request setHTTPBody:jsonData];
        [request setTimeoutInterval:30.0];
    }
    //如果有用户登录 ，参数中加入userid 和  header中加入 token
    if([MS_BasicDataController sharedInstance].user && [MS_BasicDataController sharedInstance].user.UserGuid.length > 0) {
         [request setValue:[MS_BasicDataController sharedInstance].user.token forHTTPHeaderField:@"token"];
        [request setValue:[MS_BasicDataController sharedInstance].user.UserGuid forHTTPHeaderField:@"UserGuid"];
    }
    [request setValue:@"1" forHTTPHeaderField:@"isZjapp"];
    [request setValue:[GlobalConfig appVersion] forHTTPHeaderField:@"curAppVersionCode"];
    [request setValue:@"iOS" forHTTPHeaderField:@"systemType"];
    
    AFHTTPResponseSerializer * responceSerializer = [AFHTTPResponseSerializer serializer];
    responceSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
    
    [mgr setResponseSerializer:responceSerializer];

    
    [[mgr dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSHTTPURLResponse *responseA = (NSHTTPURLResponse *)response;
            NSDictionary *allHeaders = responseA.allHeaderFields;
            NSString *dateServer = [allHeaders objectForKey:@"Date"];
            // 转换方法
            NSDate *inputDate = [NSDate dateFromRFC822String:dateServer];
            //存储服务器时间；
            [NSDate wySetServerTime:inputDate];

            if (success) {
                success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }] resume];
}


+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30.0];
    
    AFHTTPResponseSerializer * responceSerializer = [AFHTTPResponseSerializer serializer];
    responceSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
    [mgr setResponseSerializer:responceSerializer];
    
//    [mgr.requestSerializer setValue:@"B0CE4F04-C288-4A5B-8D68-B56C39F646A8" forHTTPHeaderField:@"Cookie"];
    [mgr setRequestSerializer:requestSerializer];
     
    [mgr POST:url parameters:params headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {

            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             NSDictionary *allHeaders = response.allHeaderFields;
            NSString *dateServer = [allHeaders objectForKey:@"Date"];
            // 转换方法
            NSDate *inputDate = [NSDate dateFromRFC822String:dateServer];
            //存储服务器时间；
            [NSDate wySetServerTime:inputDate];

            MSLog(@"%@   %@",response.allHeaderFields,response.allHeaderFields[@"Set-Cookie"]);

            success([NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (BOOL)isNetWorkConnected {
    
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus > 0;
}


+ (void) netRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (void (^)(NSDictionary *returnData)) successBlock
                   WithErrorCodeBlock: (void (^)(void)) errorBlock
                     WithFailureBlock: (void (^)(NSError *error)) failureBlock
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setTimeoutInterval:30.0];
    AFHTTPResponseSerializer * responceSerializer = [AFHTTPResponseSerializer serializer];
    responceSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript",@"text/plain", nil];
    [mgr setResponseSerializer:responceSerializer];
    [mgr setRequestSerializer:requestSerializer];
    
    
//    requestURLString = [NSString stringWithFormat:@"%@%@", BASE_URL, requestURLString];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:parameter];
//    NSString *time = [GlobalConfig getNowTimeTimestamp];
//    [dict setObject:time forKey:@"timestamp"];
//
//    NSString *token = [self getToken];
//    if (![token isEqualToString:@" "]) {
//        [dict setObject:token forKey:@"token"];
//    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
//    NSString *str = [MS_CommonTool getNeedSignStrFrom:dict];
//    NSString *codeStr = [MS_GYBDesEncode encodeStr:str];
//    [param setObject:codeStr forKey:@"sign"];
    
    NSLog(@"接口地址==%@", requestURLString);
    NSLog(@"接口参数==%@", param);
    
    [mgr POST:requestURLString parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (successBlock) {
            successBlock(dic);
            NSLog(@"接口成功返回==%@", dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(error);
        }
        NSLog(@"接口请求失败返回%@", error.description);
    }];
}
@end
