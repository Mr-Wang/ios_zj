//
//  MS_BasicDataController.m
//  WanZhu
//
//  Created by 古玉彬 on 16/7/6.
//  Copyright © 2016年 ms. All rights reserved.
//

#import "MS_BasicDataController.h"
#import "MSNetworkingTool.h"


@interface MS_BasicDataController ()

@end
@implementation MS_BasicDataController
@synthesize user = _user;

+(instancetype) sharedInstance {
    static MS_BasicDataController * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [MS_BasicDataController new];
    });
    return sharedInstance;;
}

- (void)postWithURL:(NSString *)url params:(NSDictionary *)params jsonData:(NSData *)jsonData showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes
{
     //拼接网络地址
    NSString * absoluteUrl = [GlobalConfig getAbsoluteUrl:url];
    if (show) {
        
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    }
   
    [MSNetworkingTool postWithURL:absoluteUrl params:params jsonData:jsonData success:^(id json) {
        
        if ([[NSString stringWithFormat:@"%@",json[@"code"]] isEqualToString:@"0"]) {
            if (successResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                successResp(json[@"data"]);
            }
        }else{
            if (failureResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                failureResp(json[@"msg"]);
            }
        }
        
    } failure:^(NSError *error) {
        
        if (errorRes) {
            MSLog(@"%@",error);
            if (show) {
                [SVProgressHUD ms_dismiss];
                
            }
            errorRes(error);
        }
    }];
}

- (void)postWithReturnCode:(NSString *)url params:(NSDictionary *)params jsonData:(NSData *)jsonData showProgressView:(BOOL)show success:(void (^)(id res, NSString *code))successResp failure:(void (^)(NSError *error))failureResp {
     //拼接网络地址
     NSString * absoluteUrl = [GlobalConfig getAbsoluteUrl:url];

    if (show) {
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    }
     [MSNetworkingTool postWithURL:absoluteUrl params:params jsonData:jsonData success:^(id json) {
        if (successResp) {
            if (show) {
                
                [SVProgressHUD ms_dismiss];

            }
            
            successResp(json,json[@"code"]);
        }
        
    } failure:^(NSError *error) {
        
        if (failureResp) {
            if (show) {

                [SVProgressHUD ms_dismiss];
            }
            
            failureResp(error);
            
        }
    }];
}

- (void)getWithReturnCode:(NSString *)url params:(NSDictionary *)params jsonData:(NSData *)jsonData showProgressView:(BOOL)show success:(void (^)(id res, NSString *code))successResp failure:(void (^)(NSError *error))failureResp {
     //拼接网络地址
     NSString * absoluteUrl = [GlobalConfig getAbsoluteUrl:url];

    if (show) {
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    }
     [MSNetworkingTool getWithURL:absoluteUrl params:params jsonData:jsonData success:^(id json) {
        if (successResp) {
            if (show) {
                
                [SVProgressHUD ms_dismiss];

            }
            
            successResp(json,json[@"code"]);
        }
        
    } failure:^(NSError *error) {
        
        if (failureResp) {
            if (show) {

                [SVProgressHUD ms_dismiss];
            }
            
            failureResp(error);
            
        }
    }];
} 
//数据请求
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes {
    
    //拼接网络地址
    
    NSString * absoluteUrl = [GlobalConfig getAbsoluteUrl:url];
    
    if (show) {
        
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    }
    
    [MSNetworkingTool postWithURL:absoluteUrl params:params success:^(id json) {
        
        
        
        if ([[NSString stringWithFormat:@"%@",json[@"code"]] isEqualToString:@"10001"]) {
            if (successResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                successResp(json[@"data"]);
            }
        }else if ([[NSString stringWithFormat:@"%@",json[@"code"]] isEqualToString:@"40007"])
        {
            
            if (failureResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                failureResp(@"40007");
            }
        }else if ([[NSString stringWithFormat:@"%@",json[@"code"]] isEqualToString:@"41005"])
        {
            if (failureResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                failureResp(@"41005");
            }
        }else if ([[NSString stringWithFormat:@"%@",json[@"code"]] isEqualToString:@"41001"])
        {
            if (failureResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                failureResp(@"41001");
            }
        }
        else if ([[NSString stringWithFormat:@"%@",json[@"code"]] isEqualToString:@"41008"])
        {
            if (failureResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                failureResp(@"41008");
            }
        }else if ([[NSString stringWithFormat:@"%@",json[@"code"]] isEqualToString:@"60005"])
        {
            if (failureResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                failureResp(@"60005");
            }
        }else{
            if (failureResp) {
                if (show) {
                    [SVProgressHUD ms_dismiss];
                }
                failureResp(json[@"message"]);
            }
        }
        
    } failure:^(NSError *error) {
        
        if (errorRes) {
            MSLog(@"%@",error);
            if (show) {
                [SVProgressHUD ms_dismiss];
                
            }
            errorRes(error);
        }
    }];
}





- (void)postWithReturnModel:(Class)model isReturnArr:(BOOL)isArr url:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show success:(SuccessBlock)success failure:(Failure)failure ErrorInfo:(Error)errorRes {
    
    [self postWithURL:url params:params showProgressView:show success:^(id successCallBack) {
        
        id result;
    
        
        if (isArr) {
            
          result =  [model mj_objectArrayWithKeyValuesArray:successCallBack];
            
        }
        else{
            
           result = [model mj_objectWithKeyValues:successCallBack];
        }
        
        if (success) {
            
            success(result);
        }
        
    } failure:^(NSString *failureCallBack) {
        
        if (failure) {
            
            failure(failureCallBack);
        }
    } ErrorInfo:^(NSError *error) {
        
        if (errorRes) {
            errorRes(error);
        }
    }];
}

 
/**
 *  上传多张图片
 *
 *  @param url      文件路径
 *  @param params   参数
 *  @param show     是否显示菊花
 *  @param imageArr 文件数组
 *  @param success  成功的回调
 *  @param failure  失败的回调
 *  @param errorRes 错误的回调
 */
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show imageArr:(NSArray *)imageArr success:(SuccessBlock)success failure:(Failure)failure ErrorInfo:(Error)errorRes{
    
    //拼接网络地址
    NSString * absoluteUrl = [GlobalConfig getAbsoluteUrl:url];
    
    if (show) {
        
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    }
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
//    [mgr POST:absoluteUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [mgr POST:absoluteUrl parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageArr.count) {
            int i=0;
            
            for (UIImage *image in imageArr) {
                
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.2) name:@"img[]" fileName:[NSString stringWithFormat:@"img%d.jpg", i] mimeType:@"MultipartFile"];
                
                i++;
                
            }
            
            
        }
        
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable json) {
        
//        [SVProgressHUD dismiss];
        [SVProgressHUD ms_dismiss];

        
        if ([json[@"code"] isEqualToString:@"10001"]) {
            if (success) {
                
                success(json[@"data"]);
            }
        }
        else{
            
            if (failure) {
                
                failure(json[@"message"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (errorRes) {
//            [SVProgressHUD dismiss];
            [SVProgressHUD ms_dismiss];

            errorRes(error);
        }
        
    }];
    
}

- (BOOL)isNetWorkConnected {
    
    return [MSNetworkingTool isNetWorkConnected];
}


- (WY_UserModel *)user {
    if(!_user) {
         NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
        NSDate *data = [[userdef objectForKey:@"userJson"] dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
          _user = [WY_UserModel modelWithJSON:data];
        }
    }
    return _user;
}

-(void)setUser:(WY_UserModel *)user {
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:user.toJSONString forKey:@"userJson"];
    _user = user;
}

- (void)ecPostWithUrl:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes{
    
    //拼接网络地址
    
    NSString * absoluteUrl = [GlobalConfig getAbsoluteUrl:url];
    
    if (show) {
        
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    }
    
    [MSNetworkingTool postWithURL:absoluteUrl params:params success:^(id json) {
        if (show) {
            //            [SVProgressHUD dismiss];
            [SVProgressHUD ms_dismiss];
            
        }
        
        //        if ([json[@"code"] isEqualToString:@"200"])
        if ([[NSString stringWithFormat:@"%@",json[@"isSuccess"]] isEqualToString:@"1"]) {
            if (successResp) {
                
                successResp(json[@"data"]);
            }
        }
        else{
            if (failureResp) {
                
                failureResp(json[@"msg"]);
            }
        }
        
    } failure:^(NSError *error) {
        
        if (errorRes) {
            MSLog(@"%@",error);
            if (show) {
                //                [SVProgressHUD dismiss];
                [SVProgressHUD ms_dismiss];
                
            }
            errorRes(error);
        }
    }];
    
}

- (void)loginPostWithURL:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes {
    
    //拼接网络地址
    
    NSString * absoluteUrl = [GlobalConfig getAbsoluteUrl:url];
    
    if (show) {
        
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeClear];
    }
    
    [MSNetworkingTool postWithURL:absoluteUrl params:params success:^(id json) {
        if (show) {
            //            [SVProgressHUD dismiss];
            [SVProgressHUD ms_dismiss];
            
        }
        //        [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"EC_TOKEN"] forKey:@"token"];
        
        
        //        if ([json[@"code"] isEqualToString:@"200"])
        if ([[NSString stringWithFormat:@"%@",json[@"status"]] isEqualToString:@"200"]) {
            if (successResp) {
                
                successResp(json[@"data"]);
            }
        }
        else{
            if (failureResp) {
                
                failureResp(json[@"msg"]);
            }
        }
        
    } failure:^(NSError *error) {
        
        if (errorRes) {
            MSLog(@"%@",error);
            if (show) {
                //                [SVProgressHUD dismiss];
                [SVProgressHUD ms_dismiss];
                
            }
            errorRes(error);
        }
    }];
    
    
}

@end
