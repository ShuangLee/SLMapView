//
//  SLLineViewController.m
//  SLMapView
//
//  Created by 光头强 on 16/8/26.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLLineViewController.h"
#import <MapKit/MapKit.h>
#import "SLAnnotation.h"

@interface SLLineViewController ()<MKMapViewDelegate>
{
    MKMapView *_mapView;
}
@property (nonatomic, strong) CLGeocoder *geoCoder;
@end

@implementation SLLineViewController
- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [[CLGeocoder alloc] init];
    }
    
    return _geoCoder;
}

#pragma mark - 实例化视图
- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    // 实例化地图视图
    MKMapView *mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:mapView];
    
    [mapView setDelegate:self];
        
    _mapView = mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *address1 = @"北京";
    NSString *address2 = @"深圳";
    
    [self.geoCoder geocodeAddressString:address1 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            return;
        }
        
        CLPlacemark *fromPlacemark = [placemarks firstObject];
        [self.geoCoder geocodeAddressString:address2 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                return;
            }
            
            CLPlacemark *toPlacemark = [placemarks firstObject];
            
            // 添加遮盖划线
            [self addLineFrom:fromPlacemark to:toPlacemark];
     
#pragma mark - 导航
//            //使用MKMapItem导航
//            MKMapItem *fromMapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:fromPlacemark]];
//            MKMapItem *toMapItem = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:toPlacemark]];
//            NSMutableDictionary *options = [NSMutableDictionary dictionary];
//            options[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
//            options[MKLaunchOptionsShowsTrafficKey] = @(YES);
//            [MKMapItem openMapsWithItems:@[fromMapItem, toMapItem] launchOptions:options];
        }];
    }];
}

// 两点路径划线
- (void)addLineFrom:(CLPlacemark *)fromPlacemark to:(CLPlacemark *)toPlacemark {
    //添加2个大头针
    SLAnnotation *anno1 = [[SLAnnotation alloc] init];
    anno1.coordinate = fromPlacemark.location.coordinate;
    [_mapView addAnnotation:anno1];
    
    SLAnnotation *anno2 = [[SLAnnotation alloc] init];
    anno2.coordinate = toPlacemark.location.coordinate;
    [_mapView addAnnotation:anno2];
    
    // 设置方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 设置起点终点
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithPlacemark:fromPlacemark];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithPlacemark:toPlacemark];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    
    // 定义方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 计算路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"总共有%lu条线路",(unsigned long)response.routes.count);
        
        for (MKRoute *route in response.routes) {
            [_mapView addOverlay:route.polyline];
        }
    }];
}

#pragma mark - 代理
// 划线就是添加路径\添加遮盖
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}
@end
