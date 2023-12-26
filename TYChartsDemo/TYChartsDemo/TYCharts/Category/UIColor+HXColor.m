//
//  UIColor+HXColor.m
//  TYLineChartView
//
//  Created by ty on 2022/10/21.
//

#import "UIColor+HXColor.h"

@implementation UIColor (HXColor)

#pragma mark - 颜色值十六进制 转换  #ffffff -> uicolor

+ (UIColor *)ty_colorWithHexString:(NSString *)hexString {
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self ty_colorComponentFrom:colorString start:0 length:1];
            green = [self ty_colorComponentFrom:colorString start:1 length:1];
            blue  = [self ty_colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self ty_colorComponentFrom:colorString start:0 length:1];
            red   = [self ty_colorComponentFrom:colorString start:1 length:1];
            green = [self ty_colorComponentFrom:colorString start:2 length:1];
            blue  = [self ty_colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self ty_colorComponentFrom:colorString start:0 length:2];
            green = [self ty_colorComponentFrom:colorString start:2 length:2];
            blue  = [self ty_colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self ty_colorComponentFrom:colorString start:0 length:2];
            red   = [self ty_colorComponentFrom:colorString start:2 length:2];
            green = [self ty_colorComponentFrom:colorString start:4 length:2];
            blue  = [self ty_colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            NSLog(@"色值有问题,被改为默认白色了,具体代码全局搜索这条log输出文字");
            return [UIColor whiteColor];
            //[NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (UIColor *)ty_colorWithHexString:(NSString *)hexString withAlpha:(float)alp {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = alp;
            red   = [self ty_colorComponentFrom:colorString start:0 length:1];
            green = [self ty_colorComponentFrom:colorString start:1 length:1];
            blue  = [self ty_colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self ty_colorComponentFrom:colorString start:0 length:1];
            red   = [self ty_colorComponentFrom:colorString start:1 length:1];
            green = [self ty_colorComponentFrom:colorString start:2 length:1];
            blue  = [self ty_colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = alp;
            red   = [self ty_colorComponentFrom:colorString start:0 length:2];
            green = [self ty_colorComponentFrom:colorString start:2 length:2];
            blue  = [self ty_colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self ty_colorComponentFrom:colorString start:0 length:2];
            red   = [self ty_colorComponentFrom:colorString start:2 length:2];
            green = [self ty_colorComponentFrom:colorString start:4 length:2];
            blue  = [self ty_colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            NSLog(@"色值有问题,被改为默认白色了,具体代码全局搜索这条log输出文字");
            return [UIColor whiteColor];
            //[NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)ty_colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

@end
