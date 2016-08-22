//
//  LsNetworkTool.m
//  MiaoBo
//
//  Created by 光头强 on 16/8/9.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "SLNetworkTool.h"

@implementation SLNetworkTool
static SLNetworkTool *_manager;
+ (instancetype)shareNetworkTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [SLNetworkTool manager];
        // 设置超时时间
        _manager.requestSerializer.timeoutInterval = 10.0;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
    
    return _manager;
}

/**
 *  获取网络类型
 */
+ (SLNetworkState)networkState {
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    SLNetworkState state = SLNetworkStateNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    state = SLNetworkStateNone;
                    //无网模式
                    break;
                case 1:
                    state = SLNetworkState2G;
                    break;
                case 2:
                    state = SLNetworkState3G;
                    break;
                case 3:
                    state = SLNetworkState4G;
                    break;
                case 5:
                    state = SLNetworkStateWIFI;
                    break;
                default:
                    break;
            }
        }
    }

    return state;
}
@end
