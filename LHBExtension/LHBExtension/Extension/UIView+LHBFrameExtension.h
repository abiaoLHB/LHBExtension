//
//  UIView+LHBFrameExtension.h
//  RideGirl
//
//  Created by LHB on 16/6/1.
//  Copyright © 2016年 LHB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LHBFrameExtension)

@property (nonatomic,assign) CGSize lhb_size;

@property (nonatomic,assign) CGFloat lhb_width;

@property (nonatomic,assign) CGFloat lhb_height;

@property (nonatomic,assign) CGFloat lhb_x;

@property (nonatomic,assign) CGFloat lhb_y;

@property (nonatomic,assign) CGFloat lhb_centerX;

@property (nonatomic,assign) CGFloat lhb_centerY;

/**
 *  判断一个控件是否真正显示在主窗口
 */
- (BOOL)lhb_isShowingOnKeyWindow;


/**
 *  从xib中加载一个控件，xib和类名名字一致
 */
+ (instancetype)lhb_viewFromXib;

@end
