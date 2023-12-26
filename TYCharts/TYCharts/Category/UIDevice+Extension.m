//
//  UIDevice+Extension.m
//  TYRefreshView
//
//  Created by ty on 2023/8/31.
//

#import "UIDevice+Extension.h"

@implementation UIDevice (Extension)

/// 顶部安全区高度
+ (CGFloat)ty_safeAreaTop
{
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.top;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.top;
    }
    return 0;
}

/// 底部安全区高度
+ (CGFloat)ty_safeAreaBottom
{
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)ty_statusBarHeight
{
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIStatusBarManager *statusBarManager = windowScene.statusBarManager;
        return statusBarManager.statusBarFrame.size.height;
    } else {
        return [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

/// 导航栏高度
+ (CGFloat)ty_navigationBarHeight
{
    return 44.0f;
}

/// 状态栏+导航栏的高度
+ (CGFloat)ty_statusBarAndNavigationBarHeight
{
    return [UIDevice ty_statusBarHeight] + [UIDevice ty_navigationBarHeight];
}

/// 底部导航栏高度
+ (CGFloat)ty_tabBarHeight
{
    return 49.0f;
}

@end
