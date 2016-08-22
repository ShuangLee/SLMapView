//
//  SLXMLParser.h
//  SLMapView
//
//  Created by 光头强 on 16/8/22.
//  Copyright © 2016年 Ls. All rights reserved.
//  xml解析器

#import <Foundation/Foundation.h>
@class SLWeather;

typedef void (^SLXMLParserCompletion)(SLWeather *weather);

@interface SLXMLParser : NSObject

+ (instancetype)sharedXMLParser;

#pragma mark 解析器解析数据
- (void)parserData:(NSData *)data completion:(SLXMLParserCompletion)completion;
@end
