//
//  UIView+LHBFrameExtension.m
//  RideGirl
//
//  Created by LHB on 16/6/1.
//  Copyright © 2016年 LHB. All rights reserved.
//

#import "UIView+LHBFrameExtension.h"

@implementation UIView (LHBFrameExtension)

- (void)setLhb_size:(CGSize)lhb_size
{
    CGRect frame = self.frame;
    frame.size = lhb_size;
    self.frame = frame;
}


- (void)setLhb_width:(CGFloat)lhb_width
{
    CGRect frame = self.frame;
    frame.size.width = lhb_width;
    self.frame = frame;
}

- (void)setLhb_height:(CGFloat)lhb_height
{
    CGRect frame = self.frame;
    frame.size.height = lhb_height;
    self.frame = frame;
}


- (void)setLhb_x:(CGFloat)lhb_x
{
    CGRect frame = self.frame;
    frame.origin.x = lhb_x;
    self.frame = frame;
}


- (void)setLhb_y:(CGFloat)lhb_y
{
    CGRect frame = self.frame;
    frame.origin.y = lhb_y;
    self.frame = frame;
}


- (void)setLhb_centerX:(CGFloat)lhb_centerX
{
    CGPoint center = self.center;
    center.x = lhb_centerX;
    self.center = center;
}


- (void)setLhb_centerY:(CGFloat)lhb_centerY
{
    CGPoint center = self.center;
    center.y = lhb_centerY;
    self.center = center;
}


- (CGSize)lhb_size
{
    return self.frame.size;
}

- (CGFloat)lhb_width
{
    return self.frame.size.width;
}

- (CGFloat)lhb_height
{
    return self.frame.size.height;
}

- (CGFloat)lhb_x
{
    return self.frame.origin.x;
}

- (CGFloat)lhb_y
{
    return self.frame.origin.y;
}
- (CGFloat)lhb_centerX
{
    return self.center.x;
}

- (CGFloat)lhb_centerY
{
    return self.center.y;
}



- (BOOL)lhb_isShowingOnKeyWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    //转换坐标系。将subView.frame  从 subView.superview的坐标系转换成window的坐标系，并返回一个新的frame
    CGRect newFrame = [keyWindow convertRect:self.frame fromView:self.superview];//nil默认就是window（屏幕坐标系）
    //引申出另一个写法
    // CGRect newFrame = [[UIApplication sharedApplication].keyWindow convertRect:-- toView:--];
    
    CGRect windowRect = keyWindow.bounds;
    
    //判断两个CGRect是否交叉
    BOOL isIntersects = CGRectIntersectsRect(newFrame, windowRect);
    
    return (!self.hidden) && (self.alpha > 0.01) && (self.window == keyWindow) && isIntersects;
}


+ (instancetype)lhb_viewFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
@end
