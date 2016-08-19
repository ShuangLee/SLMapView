//
//  ViewController.m
//  SLMapView
//
//  Created by 光头强 on 16/8/19.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "SLAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    // 允许跟踪用户位置
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    // 设置地图类型
    [self.mapView setMapType:MKMapTypeStandard];
    // 显示比例尺
    [self.mapView setShowsScale:YES];
    // 显示楼栋
    self.mapView.showsBuildings = YES;
    // 显示交通
    self.mapView.showsTraffic = YES;
    // 显示罗盘
    self.mapView.showsCompass = YES;
    // 平移
    self.mapView.scrollEnabled = YES;
    self.mapView.rotateEnabled = YES;
    
    //添加大头针
    /*
     - (void)addAnnotation:(id <MKAnnotation>)annotation;
     说明需要传入一个遵守了MKAnnotation协议的对象
     */
    SLAnnotation *annotation1 = [[SLAnnotation alloc] init];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(+30.06055580, +116.34273116);
    [annotation1 setCoordinate:coord];
    [annotation1 setTitle:@"我的地盘"];
    [annotation1 setIcon:@"userIcon"];
    [self.mapView addAnnotation:annotation1];
    
    SLAnnotation *annotation2 = [[SLAnnotation alloc] init];
    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(+50.06055580, +116.34273116);
    [annotation2 setCoordinate:coord2];
    [annotation2 setTitle:@"逗比地盘"];
    [annotation2 setIcon:@"head.jpg"];
    [self.mapView addAnnotation:annotation2];
    
    // 让地图移到对应位置
    [self.mapView setCenterCoordinate:annotation1.coordinate animated:YES];
    
    // 计算两个大头针之间的距离
    CLLocation *location1 = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
    CLLocation *location2 = [[CLLocation alloc]initWithLatitude:coord2.latitude longitude:coord2.longitude];
    
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    NSLog(@"两点间距离 %f", distance);
}

#pragma mark - <MKMapViewDelegate>
#pragma mark - mapView:didUpdateUserLocation:当用户位置发生变化时调用
// 每次用户位置变化都会被调用，意味着非常费电
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%@ %@", userLocation.location, userLocation.title);
    // 利用location中的经纬度设置地图的显示区域
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 100.0, 100.0);
    // 设置地图的显示区域，以用户所在位置为中心点，半径为100米
    [mapView setRegion:region animated:YES];
}

#pragma mark - mapView:viewForAnnotation: 当地图上有大头针时调用
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // 如果传入的annotation不是自定义大头针视图，直接返回nil，使用地图默认的方法绘制大头针
    // 如果是自定义视图，则设置大头针属性
    if (![annotation isKindOfClass:[SLAnnotation class]]) {
        return nil;
    }

    static NSString *annotationIdentifier = @"annotationIdentifier";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    // 如果没有找到可重用的大头针视图，实例化新的
    if (view == nil) {
        view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        // 提示：如果是自定义大头针视图，需要设置canShowCallout属性，才能够和视图进行交互
        view.canShowCallout = YES;
    }
    
    // 设置大头针视图属性
    // 1) 如果大头针视图是从缓冲池取出的，必须要重新设置位置
    [view setAnnotation:annotation];
    // 2) 设置大头针图像
    [view setImage:[UIImage imageNamed:((SLAnnotation *)annotation).icon]];
    
    return view;
}

#pragma mark - mapView:regionDidChangeAnimated: 当显示的区域发生变化时调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"当显示的区域发生变化时调用:%s",__FUNCTION__);
}

#pragma mark - mapViewWillStartLoadingMap: 当地图界面将要加载时调用
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
    NSLog(@"当地图界面将要加载时调用:%s",__FUNCTION__);
}

#pragma mark - mapViewWillStartLocatingUser:当准备进行一个位置定位时调用
- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    NSLog(@"当准备进行一个位置定位时调用:%s",__FUNCTION__);
}
@end
