//
//  LsNavigationController.m
//  MiaoBo
//
//  Created by 光头强 on 16/8/9.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLNavigationController.h"

@interface SLNavigationController ()

@end

@implementation SLNavigationController
//类第一次调用的时候被调用，且只调用一次
+ (void)initialize {
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName: [UIColor redColor]};
    [bar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//重写push方法，给子控制器自定义返回按钮并隐藏底部bar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 自定义返回按钮
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        // 如果自定义返回按钮后, 滑动返回可能失效, 需要添加下面的代码
        __weak typeof(viewController)Weakself = viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    // 判断两种情况: push 和 present
    // 如果导航栏存在一个正在present或已经present的View,且子控制器只有当前这一个，则此时手势代表返回,否则为push
    if ((self.presentedViewController || self.presentationController) && self.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self popViewControllerAnimated:YES];
    }
}
@end
