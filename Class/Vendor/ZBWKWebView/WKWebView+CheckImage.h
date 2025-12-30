//
//  WKWebView+CheckImage.h
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/6.
//  Copyright © 2020 王杨. All rights reserved.
//

#import <WebKit/WebKit.h> 
NS_ASSUME_NONNULL_BEGIN

typedef void(^webviewCheckImageByUrlBlock)(NSString* imgUrl) ;

@interface WKWebView (CheckImage)
@property (nonatomic,copy) webviewCheckImageByUrlBlock block; 
-(void) addTapImageGesture;
- (void)webviewCheckImageByUrl:(NSString *)imgUrl;
@end

NS_ASSUME_NONNULL_END
