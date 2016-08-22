//
//  SLXMLParser.m
//  SLMapView
//
//  Created by 光头强 on 16/8/22.
//  Copyright © 2016年 Ls. All rights reserved.
//  xml解析器

#import "SLXMLParser.h"
#import "SLWeather.h"

@interface SLXMLParser ()<NSXMLParserDelegate>
{
    // 解析中间节点
    NSString         *_elementString;
    
    // 记录数据模型
    SLWeather               *_weather;
    
    // 块代码
    SLXMLParserCompletion  _paserCompletion;
}
@end

@implementation SLXMLParser
#pragma mark - 单例方法
static SLXMLParser *xmlParser = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmlParser = [super allocWithZone:zone];
    });
    
    return xmlParser;
}

+ (instancetype)sharedXMLParser {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmlParser = [[SLXMLParser alloc] init];
    });
    
    return xmlParser;
}

#pragma mark - 成员方法
#pragma mark 解析器解析数据
- (void)parserData:(NSData *)data completion:(SLXMLParserCompletion)completion {
    _paserCompletion = completion;//记录块代码 block
    
    // 1. 实例化XML解析器
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    // 2. 设置代理
    [parser setDelegate:self];
    // 3. 解析器开始解析
    [parser parse];
}

#pragma mark - XML解析代理方法
#pragma mark 1. 开始解析文档
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"开始解析文档");
}

#pragma mark 2. 开始解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if (_weather == nil) {
        _weather = [[SLWeather alloc] init];
    }
    
    _elementString = elementName;
}

#pragma mark 3. 发现节点内容（一个节点可能会解析多次）
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"节点字符串:%@",string);
    NSLog(@"节点:%@",_elementString);
    if ([_elementString isEqualToString:@"city"]) {
        [_weather setCity:string];
    }else if ([_elementString isEqualToString:@"wendu"]){
        [_weather setWendu:string];
    }else if ([_elementString isEqualToString:@"fengli"]){
        [_weather setFengli:string];
    }else if ([_elementString isEqualToString:@"fengxiang"]){
        [_weather setFengxiang:string];
    }
}

#pragma mark 4. 结束解析节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
     NSLog(@"结束解析节点");
    _elementString = nil;
}

#pragma mark 5. 结束解析文档
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"结束解析文档");
    // 通过块代码回调，通知调用方解析结果
    _paserCompletion(_weather);
}

#pragma mark 6. 解析出错
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"解析出错 %@", parseError.localizedDescription);
    
    _elementString = nil;
}

@end
