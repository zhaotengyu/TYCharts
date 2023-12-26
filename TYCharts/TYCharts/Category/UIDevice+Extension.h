//
//  UIDevice+Extension.h
//  TYRefreshView
//
//  Created by ty on 2023/8/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Extension)

/// 顶部安全区高度
+ (CGFloat)ty_safeAreaTop;

/// 底部安全区高度
+ (CGFloat)ty_safeAreaBottom;

/// 顶部状态栏高度（包括安全区）
+ (CGFloat)ty_statusBarHeight;

/// 导航栏高度
+ (CGFloat)ty_navigationBarHeight;

/// 状态栏+导航栏的高度
+ (CGFloat)ty_statusBarAndNavigationBarHeight;

/// 底部导航栏高度
+ (CGFloat)ty_tabBarHeight;

@end

NS_ASSUME_NONNULL_END
