//
//  SLWeatherViewController.m
//  SLMapView
//
//  Created by 光头强 on 16/8/19.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLWeatherViewController.h"
#import <MapKit/MapKit.h>
#import "SLAnnotation.h"
#import "SLNetworkTool.h"
#import "SLWeather.h"
#import "SLXMLParser.h"

@interface SLWeatherViewController ()<MKMapViewDelegate> {
    // 操作队列
    NSOperationQueue    *_queue;
    // 地图视图
    MKMapView *_mapView;
    // 地理编码器
    CLGeocoder *_geoCoder;
}
@end

@implementation SLWeatherViewController
#pragma mark - 实例化视图
- (void)loadView
{
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    // 1. 如果需要旋转屏幕，同时自动调整视图大小
    [_mapView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    // 2. 添加到根视图
    [self.view addSubview:_mapView];
    // 3. 设置代理
    [_mapView setDelegate:self];
    
//    // 4. 其他设置
//    // 允许跟踪用户位置
//    [_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
//    // 设置地图类型
//    [_mapView setMapType:MKMapTypeStandard];
//    // 显示比例尺
//    [_mapView setShowsScale:YES];
//    // 显示楼栋
//    _mapView.showsBuildings = YES;
//    // 显示交通
//    _mapView.showsTraffic = YES;
//    // 显示罗盘
//    _mapView.showsCompass = YES;
//    // 平移
//    _mapView.scrollEnabled = YES;
//    _mapView.rotateEnabled = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _queue = [[NSOperationQueue alloc] init];
    _geoCoder = [[CLGeocoder alloc] init];
    
    // 在后台线程加载天气数据
    [self performSelectorInBackground:@selector(loadWeatherData) withObject:nil];
}

#pragma mark - 私有方法
#pragma mark 抓取城市数据，后台运行
- (void)loadWeatherData
{
    NSLog(@"%@", [NSThread currentThread]);
    
    [self loadWeatherDataWithCityName:@"北京"];
    [NSThread sleepForTimeInterval:1.0f];
    [self loadWeatherDataWithCityName:@"重庆"];
    [NSThread sleepForTimeInterval:1.0f];
    [self loadWeatherDataWithCityName:@"上海"];
    [NSThread sleepForTimeInterval:1.0f];
    [self loadWeatherDataWithCityName:@"深圳"];
}

/*
 在开发网络应用时，通常服务器考虑到负载的问题，会禁止同一个地址，连续多次提交请求
 大多数这种情况下，服务器只响应一次！
 解决办法：隔一秒抓一次！
 
 思路：
 1) 抓取城市天气信息的数据，不能够并发执行，需要依次执行
 2) 新开一个线程，在后台依次抓取城市的数据
 */

- (void)loadWeatherDataWithCityName:(NSString *)city {
    NSString *url = [[NSString stringWithFormat:@"http://wthrcdn.etouch.cn/WeatherApi?city=%@",city] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    SLNetworkTool *networkTool = [SLNetworkTool shareNetworkTool];
    networkTool.responseSerializer = [[AFHTTPResponseSerializer alloc] init];// 使用自己创建的对象取解析xml
    [networkTool POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        //1. 实例化天气XML解析器
        SLXMLParser *parser = [SLXMLParser sharedXMLParser];
        
        //2. 解析
        [parser parserData:responseObject completion:^(SLWeather *weather) {
            // 根据城市名称，使用地理编码器获取到对应的经纬度，然后设置大头针的位置
            [_geoCoder geocodeAddressString:weather.city completionHandler:^(NSArray *placemarks, NSError *error) {
                
                NSLog(@"%@, %@", weather.city, placemarks[0]);
                
                CLPlacemark *placemark = placemarks[0];
                
                // 大头针安插在此
                SLAnnotation *annonation = [[SLAnnotation alloc]init];
                
                // 指定大头针的经纬度位置
                annonation.coordinate = placemark.location.coordinate;
                
                annonation.title = [NSString stringWithFormat:@"%@ 温度：%@", weather.city, weather.wendu];
                annonation.subtitle = [NSString stringWithFormat:@"风力：%@ 风向：%@", weather.fengli, weather.fengxiang];
                annonation.icon = @"userIcon";
                
                //添加大头针
                /*
                 - (void)addAnnotation:(id <MKAnnotation>)annotation;
                 说明需要传入一个遵守了MKAnnotation协议的对象
                 */
                [_mapView addAnnotation:annonation];
            }];
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - <MKMapViewDelegate>
#pragma mark - 地图视图代理方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *ID = @"ID";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    
    if (view == nil) {
        view = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ID];
        view.canShowCallout = YES;
    }
    
    // 设置视图信息
    view.annotation = annotation;
    // 设置图像
    view.image = [UIImage imageNamed:((SLAnnotation *)annotation).icon];
    
    return view;
}


@end
