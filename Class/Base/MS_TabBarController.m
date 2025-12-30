//
//  MS_TabBarController.m
//  Air
//
//  Created by Mrxiaowu on 16/6/6.
//  Copyright © 2016年 Mrxiaowu. All rights reserved.
//

#import "MS_TabBarController.h"
#import "MS_NavigationController.h"
#import "WY_ZJHomeViewController.h" //专家首页
#import "WY_HomePageViewController.h"     //首页
 
#import "WY_TrainingViewController.h"   //培训
#import "WY_AssessmentViewController.h" //考核
#import "WY_MyViewController.h"//我的


#import "UIImage+ColorImage.h"
#import "MS_BasicDataController.h"
#import "MyTabBar.h"

@interface MS_TabBarController ()<UITabBarControllerDelegate,MyTabBarDelegate>

@property (nonatomic, strong) MS_BasicDataController * dataController;
@end

@implementation MS_TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

//    //关闭手势
//    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
//    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
//    [self.view addGestureRecognizer:pan];
    
    self.delegate = self;
    NSMutableArray * vcArray = [@[] mutableCopy];
 
    NSArray * titleArray ;
    
    NSArray * imageArray ;
    
    NSArray * selectedArray ;
    
    
    titleArray = @[@"首页",@"学习",@"培训",@"考评",@"我的"];
    imageArray = @[@"shouyeweixuan",@"xuexiweixuan",@"peixunweixuan",@"ceyanweixuan",@"wodeweixuan"];
    selectedArray = @[@"shouyexuan",@"xuexixuan",@"peixunxuan",@"ceyanxuan",@"wodexuan"];
        
    [vcArray addObject:NSStringFromClass([WY_ZJHomeViewController class])];
    [vcArray addObject:NSStringFromClass([WY_HomePageViewController class])];
      [vcArray addObject:NSStringFromClass([WY_TrainingViewController class])];
    [vcArray addObject:NSStringFromClass([WY_AssessmentViewController class])];
    [vcArray addObject:NSStringFromClass([WY_MyViewController class])];
 
    
    for (int i = 0; i < vcArray.count; i++) {
        
        NSString * vcStr = vcArray[i];
        
        UIViewController * vc = [[NSClassFromString(vcStr) alloc] init];
        
        [self addChildVc:vc title:titleArray[i] image:imageArray[i] selectedImage:selectedArray[i]];
        
    }
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MSColorA(153, 153, 153, 1), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MSTHEMEColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//    修改ios13下， tabbar字体颜色，进入下一页再返回后，颜色变回蓝色问题；
    self.tabBar.tintColor = MSTHEMEColor;
    UIView * leftline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    
    
    leftline.backgroundColor = MSColorA(238, 238, 238, 1);

    
    self.tabBar.shadowImage = [[UIImage alloc] init];
    
    self.tabBar.backgroundImage = [UIImage imageWithColor:MSColorA(251, 251, 251, 1)];
    [self.tabBar insertSubview:leftline atIndex:0];
//    [self.tabBar addSubview:rightLine];
    
    // 设置自定义的tabbar
//       [self setCustomtabbar];
}

- (void)setCustomtabbar{

       //创建自定义TabBar
    MyTabBar *myTabBar = [[MyTabBar alloc] init];
    myTabBar.myTabBarDelegate = self;
    //利用KVC替换默认的TabBar
    [self setValue:myTabBar forKey:@"tabBar"];
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
     
}



- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    MS_NavigationController *nav = [[MS_NavigationController alloc] initWithRootViewController:childVc];
 
    [self addChildViewController:nav];
    
    
    // 设置子控制器的文字
    childVc.title = title;
   
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}



#pragma mark - MyTabBarDelegate
-(void)addButtonClick:(MyTabBar *)tabBar
{
//    //测试中间“+”按钮是否可以点击并处理事件
//    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"test" message:@"Test" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"test" style:UIAlertActionStyleDefault handler:nil];
//    [controller addAction:action];
//    [self presentViewController:controller animated:YES completion:nil];
    NSNotificationCenter *notifyCenter = [NSNotificationCenter defaultCenter];
    [notifyCenter postNotificationName:@"GQDKACTIONNOTIFY" object:nil];
    
}

-(MS_BasicDataController *)dataController
{
    if(!_dataController)
    {
        _dataController=[MS_BasicDataController  new];
    }
    return _dataController;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{

    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);

}

- (BOOL)shouldAutorotate

{

    return NO;

}

- (NSUInteger)supportedInterfaceOrientations

{

    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)

}
@end
