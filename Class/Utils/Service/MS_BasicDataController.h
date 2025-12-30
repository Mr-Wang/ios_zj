//
//  MS_BasicDataController.h
//  WanZhu
//
//  Created by 古玉彬 on 16/7/6.
//  Copyright © 2016年 ms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WY_UserModel.h"

//请求头
#define MS_RH \
success:(SuccessBlock)success failure:(Failure)failure error:(Error)errorCallback\


//返回体
#define MS_RF \
success:^(id successCallBack) { \
if (success) {\
    success(successCallBack);\
}\
} failure:^(NSString *failureCallBack) {\
    if (failure) {\
        failure(failureCallBack);\
    }\
} ErrorInfo:^(NSError *error) {\
    if (errorCallback) {\
        \
        errorCallback(error);\
    }\
}\

@interface MS_BasicDataController : NSObject


/**
 *  当前页
 */
@property (nonatomic, assign) NSInteger currentPage;

/**
 *  成功回调
 *
 *  @param resCallBack <#resCallBack description#>
 */
typedef void (^SuccessBlock)(id  successCallBack);

/**
 *  失败回调
 *
 *  @param resCallBack <#resCallBack description#>
 */
typedef void (^Failure)(NSString * failureCallBack);


/**
 *  带code值的回调
 *
 *  @param failureCallBack <#failureCallBack description#>
 */
typedef void (^FailureContainCode)(NSString * failureCallBack,NSString * code);

/**
 *  系统错误回调
 *
 *  @param error <#error description#>
 */
typedef void (^Error)(NSError * error);


/**
 *  当前用户
 */
@property (nonatomic, strong) WY_UserModel* user;

/// 单例
+(instancetype) sharedInstance;


/**
 *  网络请求 - addWY
 *
 *  @param url         url description
 *  @param params      params description
 *  @param jsonData        jsonData
 *  @param show        show description
 *  @param successResp 成功回调
 *  @param failureResp 失败回调
 *  @param error       系统异常回调
 */
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params jsonData:(NSData *)jsonData showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes;




/**
 *  带code值的网络请求
 *
 *  @param url         url description
 *  @param params      params description
 *  @param show        show description
 *  @param successResp successResp description
 *  @param failureResp failureResp description  
 */
- (void)postWithReturnCode:(NSString *)url params:(NSDictionary *)params jsonData:(NSData *)jsonData showProgressView:(BOOL)show success:(void (^)(id res, NSString *code))successResp failure:(void (^)(NSError *error))failureResp;
- (void)getWithReturnCode:(NSString *)url params:(NSDictionary *)params jsonData:(NSData *)jsonData showProgressView:(BOOL)show success:(void (^)(id res, NSString *code))successResp failure:(void (^)(NSError *error))failureResp;



/**
 *  网络请求
 *
 *  @param url         <#url description#>
 *  @param params      <#params description#>
 *  @param show        <#show description#>
 *  @param successResp 成功回调
 *  @param failureResp 失败回调
 *  @param error       系统异常回调
 */
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes;

 
/**
 *  带返回数据模型/数组的请求
 *
 *  @param model       数据模型
 *  @param isArr       是否返回是数组格式
 *  @param url         <#url description#>
 *  @param params      <#params description#>
 *  @param show        <#show description#>
 *  @param successResp <#successResp description#>
 *  @param failureResp <#failureResp description#>
 *  @param errorRes    <#errorRes description#>
 */
- (void)postWithReturnModel:(Class) model isReturnArr:(BOOL) isArr url:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes;
 
/**
 *  上传多个文件
 *
 *  @param url     请求地址
 *  @param params  参数<字典类型>
 *  @param imageArr 图片数组
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show imageArr:(NSArray *)imageArr success:(SuccessBlock)success failure:(Failure)failure ErrorInfo:(Error)errorRes;


/**
 *   网络是否连接
 */
- (BOOL)isNetWorkConnected;

/**
 EI的请求

 @param url <#url description#>
 @param params <#params description#>
 @param show <#show description#>
 @param successResp <#successResp description#>
 @param failureResp <#failureResp description#>
 @param errorRes <#errorRes description#>
 */
- (void)ecPostWithUrl:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes;

/**
 修改的登录请求

 @param url <#url description#>
 @param params <#params description#>
 @param show <#show description#>
 @param successResp <#successResp description#>
 @param failureResp <#failureResp description#>
 @param errorRes <#errorRes description#>
 */
- (void)loginPostWithURL:(NSString *)url params:(NSDictionary *)params showProgressView:(BOOL)show success:(SuccessBlock)successResp failure:(Failure)failureResp ErrorInfo:(Error)errorRes;
@end
