//
//  LocationManager.m
//  GTQCitySelector
//
//  Created by 光头强 on 16/7/20.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "LocationManager.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

// 字符串定义
#define CitySuffix          @"市市辖区"

@interface LocationManager () <CLLocationManagerDelegate>
/** 定位管理者 */
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationManager
/**
 *  实例化对象
 */
+ (LocationManager *)shareManager {
    static LocationManager *shareManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManagerInstance = [[LocationManager alloc] init];
    });
    
    return shareManagerInstance;
}

/**
 *  开始定位
 */
- (void)location {
    if ([CLLocationManager locationServicesEnabled]) {
        //定位管理者初始化
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        //控制定位精度,越高耗电量越大
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //控制定位服务更新频率。单位是“米”
        _locationManager.distanceFilter = 100;
        
        // iOS8以上需要请求权限
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0) {
            [_locationManager requestAlwaysAuthorization];
        }
        
        [_locationManager startUpdatingLocation];//开启定位
    } else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertView show];
    }
}

/**
 *  反地理编码 获取当前所在的城市名
 */
- (void)reverseGeocodeLocation:(CLLocation *)location {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            for (CLPlacemark *mark in placemarks) {
                NSLog(@"name:%@,locality:%@",mark.name,mark.locality);
                NSString *city = [mark.locality stringByReplacingOccurrencesOfString:CitySuffix withString:@""];
                if (!city) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = mark.administrativeArea;
                }
                
                if ([_delegate respondsToSelector:@selector(didLocationCity:)]) {
                    [_delegate didLocationCity:city];
                }
                
                break;
            }
        } else if (error == nil && [placemarks count] == 0) {
            NSLog(@"当前位置定位失败");
//            NSError *error = [[NSError alloc] init];
//            if ([_delegate respondsToSelector:@selector(loationMangerFaildWithError:)]) {
//                [_delegate loationMangerFaildWithError:error];
//            }
        } else if (error != nil) {
            NSLog(@"An error occurred = %@",error);
            if ([_delegate respondsToSelector:@selector(loationMangerFaildWithError:)]) {
                [_delegate loationMangerFaildWithError:error];
            }
        }
    }];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
     //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    // 获取当前所在城市
    [self reverseGeocodeLocation:currentLocation];
    
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(loationMangerFaildWithError:)]) {
        [_delegate loationMangerFaildWithError:error];
    }
//    if (error.code == kCLErrorDenied) {
//        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
//    }
}
@end
