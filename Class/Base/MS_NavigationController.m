//
//  MS_NavigationController.m
//  
//
//  Created by yang  on 16/4/20.
//  Copyright © 2016年 木森科技. All rights reserved.
//

#import "MS_NavigationController.h"
#import "UIBarButtonItem+Extension.h"


@interface MS_NavigationController ()
{
   UIView *_navLine;
    UIImageView *navBarHairlineImageView;

}
//@property (nonatomic,strong) UIView * bgView;
@end

@implementation MS_NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    //    self.navigationBar.barTintColor = MSColorA(72, 31, 19,0.9);
    
    //    self.navigationBar.barTintColor = MSHexColor(@"ea1b2b");
    
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//关闭系统自带边缘侧滑
    
    // 重新设置侧滑手势的代理
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakSelf;
    }
    
        self.navigationBar.barTintColor = MSTHEMEColor;
    UIImage *navImg =[UIImage imageNamed:@"navbg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
     
    [self.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance setBackgroundColor:MSTHEMEColor];
        // 隐藏分割线 设置一个透明或者纯色的图片 设置nil 或者 [UIImage new]无效
        [appearance setBackgroundImage:navImg];
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
        appearance.titleTextAttributes = attrs;
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = appearance;
         }
    
    [[UINavigationBar appearance] setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    /** 显示隐藏nav横线 */
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        self.navigationBar.translucent = NO;
    }
    return self;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
  if (self.viewControllers.count > 1) {
      self.topViewController.hidesBottomBarWhenPushed = NO;
  }
  NSArray<UIViewController *> *viewControllers = [super popToRootViewControllerAnimated:animated];
   return viewControllers;
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
  if (self.viewControllers.count > 1) {
      self.topViewController.hidesBottomBarWhenPushed = NO;
  }
  return [super popViewControllerAnimated:animated];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        /* 自动显示和隐藏tabbar */
        viewController.hidesBottomBarWhenPushed = YES;
        
        /* 设置导航栏上面的内容 */
        // 设置左边的返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"白返回" highImage:@"返回" ];
       
        
    }
    
    [super pushViewController:viewController animated:animated];
}


- (void)back
{
   
    [self popViewControllerAnimated:YES];
    [self.view endEditing:YES];
    
    
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
// 开始接收到手势的代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 判断是否是侧滑相关的手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        // 如果当前展示的控制器是根控制器就不让其响应
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    return YES;
}

// 接收到多个手势的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 判断是否是侧滑相关手势
    if (gestureRecognizer == self.interactivePopGestureRecognizer && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self.view];
        // 如果是侧滑相关的手势，并且手势的方向是侧滑的方向就让多个手势共存
        if (point.x > 0) {
            return YES;
        }
    }
    return NO;
}



@end
