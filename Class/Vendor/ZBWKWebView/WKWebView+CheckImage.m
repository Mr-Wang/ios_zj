//
//  WKWebView+CheckImage.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/2/6.
//  Copyright © 2020 王杨. All rights reserved.
//
#import "WKWebView+CheckImage.h"


@implementation WKWebView (CheckImage)
  

-(void) addTapImageGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = (id)self;
    [self addGestureRecognizer:tapGesture];
}
//这里增加手势的返回，不然会被WKWebView拦截
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void) tapGestureAction:(UITapGestureRecognizer *)recognizer
{
    int y = self.scrollView.contentOffset.y;
    if (y >0) {
        y = 0;
    }
    //首先要获取用户点击在WKWebView 的范围点
    CGPoint touchPoint = [recognizer locationInView:self];
    NSString *imgURLJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y + y];
    //跟着注入JS 获取 异步获取结果
    [self evaluateJavaScript:imgURLJS completionHandler:^(id result, NSError * _Nullable error) {
        if (error == nil)
        {
            NSString *url = result;
            if (url.length == 0)
            {
                return ;
            }
            else
            {
                //TO对图片的操作
                [self webviewCheckImageByUrl:url];
                
//                //如果是url 则转换成 UIImage
//                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//
//                NSLog(@"dddddd = %@", url);
//
//                UIImage *clickImg = [UIImage imageWithData:imgData];
//                if (clickImg)
//                {
//                    NSArray *imgArr = @[url];
//                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
//                    [tempArray addObject:clickImg];
//
//
//                }
                
            }
        }
    }];
}
- (void)webviewCheckImageByUrl:(NSString *)imgUrl{
    if (self.block){
        self.block(imgUrl);
    }
}
static const void *UtilityKey = &UtilityKey;

- (webviewCheckImageByUrlBlock)block {
    return objc_getAssociatedObject(self, UtilityKey);
}

- (void)setBlock:(webviewCheckImageByUrlBlock)block{
    objc_setAssociatedObject(self, UtilityKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
 
@end
