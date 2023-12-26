//
//  UIView+TYFrame.m
//  TYKLineChart
//
//  Created by ty on 2022/10/14.
//

#import "UIView+TYFrame.h"

@implementation UIView (TYFrame)

- (CGFloat)ty_x {
    return self.frame.origin.x;
}

- (void)setTy_x:(CGFloat)ty_x {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ty_x;
    self.frame        = newFrame;
}

- (CGFloat)ty_y {
    return self.frame.origin.y;
}

- (void)setTy_y:(CGFloat)ty_y {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ty_y;
    self.frame        = newFrame;
}

- (CGFloat)ty_width {
    return CGRectGetWidth(self.bounds);
}

- (void)setTy_width:(CGFloat)ty_width {
    CGRect newFrame     = self.frame;
    newFrame.size.width = ty_width;
    self.frame          = newFrame;
}

- (CGFloat)ty_height {
    return CGRectGetHeight(self.bounds);
}

- (void)setTy_height:(CGFloat)ty_height {
    CGRect newFrame      = self.frame;
    newFrame.size.height = ty_height;
    self.frame           = newFrame;
}

- (CGFloat)ty_top {
    return self.frame.origin.y;
}

- (void)setTy_top:(CGFloat)ty_top {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ty_top;
    self.frame        = newFrame;
}

- (CGFloat)ty_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTy_bottom:(CGFloat)ty_bottom {
    CGRect newFrame   = self.frame;
    newFrame.origin.y = ty_bottom - self.frame.size.height;
    self.frame        = newFrame;
}

- (CGFloat)ty_left {
    return self.frame.origin.x;
}

- (void)setTy_left:(CGFloat)ty_left {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ty_left;
    self.frame        = newFrame;
}

- (CGFloat)ty_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTy_right:(CGFloat)ty_right {
    CGRect newFrame   = self.frame;
    newFrame.origin.x = ty_right - self.frame.size.width;
    self.frame        = newFrame;
}

- (CGFloat)ty_centerX {
    return self.center.x;
}

- (void)setTy_centerX:(CGFloat)ty_centerX {
    CGPoint newCenter = self.center;
    newCenter.x       = ty_centerX;
    self.center       = newCenter;
}

- (CGFloat)ty_centerY {
    return self.center.y;
}

- (void)setTy_centerY:(CGFloat)ty_centerY {
    CGPoint newCenter = self.center;
    newCenter.y       = ty_centerY;
    self.center       = newCenter;
}

- (CGPoint)ty_origin {
    return self.frame.origin;
}

- (void)setTy_origin:(CGPoint)ty_origin {
    CGRect newFrame = self.frame;
    newFrame.origin = ty_origin;
    self.frame      = newFrame;
}

- (CGSize)ty_size {
    return self.frame.size;
}

- (void)setTy_size:(CGSize)ty_size {
    CGRect newFrame = self.frame;
    newFrame.size   = ty_size;
    self.frame      = newFrame;
}

@end

@implementation CALayer (TYFrame)

- (CGFloat)ty_left {
    return self.frame.origin.x;
}

- (void)setTy_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)ty_top {
    return self.frame.origin.y;
}

- (void)setTy_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)ty_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setTy_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ty_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setTy_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setTy_center:(CGPoint)ty_center {
    CGRect frame = self.frame;
    frame.origin.x = ty_center.x - frame.size.width / 2;
    frame.origin.y = ty_center.y - frame.size.height / 2;
    self.frame = frame;
}

- (CGPoint)ty_center {
    return CGPointMake(self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
}

- (CGFloat)ty_centerX {
    return self.ty_center.x;
}

- (void)setTy_centerX:(CGFloat)centerX {
    self.ty_center = CGPointMake(centerX, self.ty_center.y);
}

- (CGFloat)ty_centerY {
    return self.ty_center.y;
}

- (void)setTy_centerY:(CGFloat)centerY {
    self.ty_center = CGPointMake(self.ty_center.x, centerY);
}

- (CGFloat)ty_width {
    return self.frame.size.width;
}

- (void)setTy_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)ty_height {
    return self.frame.size.height;
}

- (void)setTy_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)ty_origin {
    return self.frame.origin;
}

- (void)setTy_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)ty_size {
    return self.frame.size;
}


- (void)setTy_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
