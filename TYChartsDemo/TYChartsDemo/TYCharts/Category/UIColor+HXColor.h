//
//  UIColor+HXColor.h
//  TYLineChartView
//
//  Created by ty on 2022/10/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HXColor)

+ (UIColor *)ty_colorWithHexString:(NSString *)hexString;
+ (UIColor *)ty_colorWithHexString:(NSString *)hexString withAlpha:(float)alp;

@end

NS_ASSUME_NONNULL_END
