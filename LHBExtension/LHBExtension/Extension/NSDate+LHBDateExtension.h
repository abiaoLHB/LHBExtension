//
//  NSDate+LHBDateExtension.h
//  RideGirl
//
//  Created by LHB on 16/6/13.
//  Copyright © 2016年 LHB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LHBDateExtension)

- (NSDateComponents *)daltaFrom:(NSDate *)fromDate;

- (BOOL)isThisYear;

- (BOOL)isToday;

- (BOOL)isYesterday;

@end
