//
//  UIColor+LHBColorExtension.h
//  RideGirl
//
//  Created by LHB on 16/7/29.
//  Copyright © 2016年 LHBCopyright. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LHBColorExtension)
/**
 *  十六进制颜色转换成RGB颜色
 */
+ (UIColor *)lhb_colorWithHexString: (NSString *)color;

@end
