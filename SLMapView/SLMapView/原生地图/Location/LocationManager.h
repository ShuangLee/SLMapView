//
//  LocationManager.h
//  GTQCitySelector
//
//  Created by 光头强 on 16/7/20.
//  Copyright © 2016年 Ls. All rights reserved.
//  定位工具类

#import <Foundation/Foundation.h>

@protocol LocationManagerDelegate <NSObject>

/** 定位到城市 */
- (void)didLocationCity:(NSString *)cityName;

/** 定位到地址 */
//- (void)didLocationAddress:(NSString *)address;

/** 定位失败 */
- (void)loationMangerFaildWithError:(NSError *)error;

@end

@interface LocationManager : NSObject

/** 代理 */
@property (nonatomic, weak) id <LocationManagerDelegate> delegate;

/**
 *  开始定位
 */
- (void)location;

+ (LocationManager *)shareManager;
@end
