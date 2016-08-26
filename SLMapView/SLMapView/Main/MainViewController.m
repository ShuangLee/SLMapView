//
//  MainViewController.m
//  MiaoBo
//
//  Created by 光头强 on 16/8/9.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "MainViewController.h"
#import "SLNavigationController.h"
#import "AppleMapViewController.h"
#import "GaodeMapViewController.h"
#import "BaiduMapViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildViewControllers];
}

- (void)setupChildViewControllers {
    [self addChildViewController:[[AppleMapViewController alloc] init] imageName:@"map"];
    [self addChildViewController:[[GaodeMapViewController alloc] init] imageName:@"location"];
    [self addChildViewController:[[BaiduMapViewController alloc] init] imageName:@"weather"];
}

- (void)addChildViewController:(UIViewController *)childController imageName:(NSString *)imageName {
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",imageName]];
    //设置图片居中，这儿需要注意top和bottom必须绝对值一样大
    childController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    SLNavigationController *nav = [[SLNavigationController alloc] initWithRootViewController:childController];
    
//    //设置baidu的导航栏为透明的
//    if ([childController isKindOfClass:[BaiduMapViewController class]]) {
//        [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//        nav.navigationBar.shadowImage = [[UIImage alloc]init];
//        nav.navigationBar.translucent = YES;
//    }

    [self addChildViewController:nav];
}

@end
