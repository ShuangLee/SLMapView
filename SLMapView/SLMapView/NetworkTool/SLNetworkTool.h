//
//  LsNetworkTool.h
//  MiaoBo
//
//  Created by 光头强 on 16/8/9.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, SLNetworkState) {
    SLNetworkStateNone, //没有网络
    SLNetworkState2G,   //2G
    SLNetworkState3G,   //3G
    SLNetworkState4G,   //4G
    SLNetworkStateWIFI  //wifi
};

@interface SLNetworkTool : AFHTTPSessionManager
+ (instancetype)shareNetworkTool;
/**
 *  获取当前网络类型
 */
+ (SLNetworkState)networkState;
@end
