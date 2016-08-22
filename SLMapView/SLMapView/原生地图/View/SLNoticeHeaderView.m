//
//  GTQNoticeHeaderView.m
//  GTQCitySelector
//
//  Created by 光头强 on 16/7/21.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLNoticeHeaderView.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

@interface SLNoticeHeaderView ()<LocationManagerDelegate>
/** 定位管理类 */
@property (nonatomic, strong)  LocationManager *manager;
/** 定位的城市 */
@property (nonatomic, copy) NSString *locaCity;
@end

@implementation SLNoticeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *noticeLabel = [[UILabel alloc] init];
        noticeLabel.text = @"正在定位中...";
        noticeLabel.textColor = [UIColor darkGrayColor];
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:noticeLabel];
        _noticeLabel = noticeLabel;
        
        self.userInteractionEnabled = YES;
        _noticeLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getCurrentLocation:)];
        [_noticeLabel addGestureRecognizer:tap];
        
        /** 定位 */
        [self location];
    }
    
    return self;
}

- (void)layoutSubviews {
    _noticeLabel.frame = self.bounds;
}

- (void)getCurrentLocation:(UITapGestureRecognizer *)tap {
    /** 背景颜色变灰 */
    UIView *view = (UIView *) [tap.view superview];
    view.backgroundColor = RGBColor(220, 220, 220);
    [self performSelector:@selector(restore:) withObject:view afterDelay:0.3];
    
    if (_isLoaction== YES) {// 如果当前定位成功，则返回并赋值
        self.block(_locaCity);
    }
    else
    {
        [[LocationManager shareManager] location];
        _noticeLabel.text = @"正在定位中......";
        _noticeLabel.userInteractionEnabled = NO;
        //NSLog(@"重新定位");
    }
}

/**
 *  恢复背景颜色
 */
- (void)restore:(UIView *)view
{
    view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 定位
- (void)location
{
    [LocationManager shareManager].delegate = self;
    [[LocationManager shareManager] location];
}

#pragma mark - ALertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            return;
        }
            break;
        case 1:
        {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 定位成功
- (void)didLocationCity:(NSString *)city;

{
    _isLoaction = YES;
    
    _noticeLabel.userInteractionEnabled = YES;
    
    _locaCity = city;//保存定位城市
    
    _noticeLabel.text = [NSString stringWithFormat:@"当前位置:%@",city];
}

#pragma mark - 定位失败
- (void)loationMangerFaildWithError:(NSError *)error
{
    _isLoaction = NO;
    _noticeLabel.userInteractionEnabled = YES;
    NSLog(@"定位的代理方法%@",error);
    _noticeLabel.text = [NSString stringWithFormat:@"定位失败,点击重新获取!"];
    if ([error code] == kCLErrorLocationUnknown) {
        //[self SHOWPrompttext:@"获取位置信息失败,请稍后再试"];
    }
    else if ([error code] == 1)
    {
        if (iOS8) {
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"定位功能未开启" message:@"请在系统设置中开启定位服务" delegate:self cancelButtonTitle:nil otherButtonTitles:@"暂不",@"去设置", nil];
            [al show];
        }
        else{
            Alert(@"您未允许咖范@生活访问您的位置,请到设置中设置允许访问位置");
        }
    }
}
@end
