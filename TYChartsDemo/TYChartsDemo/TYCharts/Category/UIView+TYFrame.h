//
//  UIView+TYFrame.h
//  TYKLineChart
//
//  Created by ty on 2022/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TYFrame)

@property (nonatomic) CGFloat ty_x;
@property (nonatomic) CGFloat ty_y;
@property (nonatomic) CGFloat ty_width;
@property (nonatomic) CGFloat ty_height;

@property (nonatomic) CGFloat ty_top;
@property (nonatomic) CGFloat ty_bottom;
@property (nonatomic) CGFloat ty_left;
@property (nonatomic) CGFloat ty_right;

@property (nonatomic) CGFloat ty_centerX;
@property (nonatomic) CGFloat ty_centerY;

@property (nonatomic) CGPoint ty_origin;
@property (nonatomic) CGSize  ty_size;

@end

@interface CALayer (TYFrame)

@property (nonatomic) CGFloat ty_left;

@property (nonatomic) CGFloat ty_top;

@property (nonatomic) CGFloat ty_right;

@property (nonatomic) CGFloat ty_bottom;

@property (nonatomic) CGFloat ty_width;

@property (nonatomic) CGFloat ty_height;

@property (nonatomic) CGPoint ty_center;

@property (nonatomic) CGFloat ty_centerX;

@property (nonatomic) CGFloat ty_centerY;

@property (nonatomic) CGPoint ty_origin;

@property (nonatomic) CGSize ty_size;

@end

NS_ASSUME_NONNULL_END
