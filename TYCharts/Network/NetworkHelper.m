//
//  NetworkHelper.m
//  CCTrendChartsDemo
//
//  Created by Cocos on 2019/12/10.
//  Copyright © 2019 Cocos. All rights reserved.
//

#import "NetworkHelper.h"

@interface NetworkHelper ()

@end

@implementation NetworkHelper
- (instancetype)init {
    self = [super init];
    if (self) {
        [self _configAPINetwork];
    }
    return self;
}

+ (instancetype)share {
    static NetworkHelper *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[NetworkHelper alloc] init];
    });
    return obj;
}


- (void)_configAPINetwork {
    self.session    = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
    [[self.session dataTaskWithURL:[NSURL URLWithString:@"https://www.xueqiu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

    }] resume];
    
//        如果无法访问接口, 可以通过下面手动设置cookie, cookie的值可以用浏览器访问一下雪球官网得到~
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
        NSHTTPCookieDomain: @".xueqiu.com",
        NSHTTPCookiePath: @"/",
        NSHTTPCookieName: @"xq_a_token",
        NSHTTPCookieValue: @"e59e6701bcdd7a0eb7de4bf5160b59743fe29830",
        NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60]
    }]];

    [cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
        NSHTTPCookieDomain: @".xueqiu.com",
        NSHTTPCookiePath: @"/",
        NSHTTPCookieName: @"xqat",
        NSHTTPCookieValue: @"e59e6701bcdd7a0eb7de4bf5160b59743fe29830",
        NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60]
    }]];

    [cookieJar setCookie:[NSHTTPCookie cookieWithProperties:@{
        NSHTTPCookieDomain: @".xueqiu.com",
        NSHTTPCookiePath: @"/",
        NSHTTPCookieName: @"xq_r_token",
        NSHTTPCookieValue: @"e59e6701bcdd7a0eb7de4bf5160b59743fe29830",
        NSHTTPCookieExpires: [NSDate dateWithTimeIntervalSinceNow:60 * 60]
    }]];
    
}

    
@end
