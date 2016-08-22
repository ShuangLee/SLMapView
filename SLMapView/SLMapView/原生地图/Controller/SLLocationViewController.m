//
//  SLLocationViewController.m
//  SLMapView
//
//  Created by 光头强 on 16/8/19.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLLocationViewController.h"
#import "SLNoticeHeaderView.h"

@interface SLLocationViewController ()
@property (nonatomic, strong) SLNoticeHeaderView *headView;
@end

@implementation SLLocationViewController
- (SLNoticeHeaderView *)headView {
    if (!_headView) {
        _headView = [[SLNoticeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        _headView.backgroundColor = [UIColor clearColor];
        _headView.block = ^(NSString *city) {
            NSLog(@"定位");
        };
    }
    
    return _headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.headView;
}

@end
