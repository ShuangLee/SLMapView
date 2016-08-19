//
//  SLAnnotation.h
//  SLMapView
//
//  Created by 光头强 on 16/8/19.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SLAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

// 大头针图标
@property (nonatomic, strong) NSString *icon;
@end
