//
//  Utilities.h
//  WYFinance
//
//  Created by jhdu on 3/28/16.
//  Copyright © 2016 zhsoftbank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

typedef enum {
    
    NETWORK_TYPE_NONE = 0,
    NETWORK_TYPE_2G = 1,
    NETWORK_TYPE_3G = 2,
    NETWORK_TYPE_4G = 3,
    NETWORK_TYPE_LTE = 4,//
    NETWORK_TYPE_WIFI = 5,
} NETWORK_TYPE;


+(UIColor*)colorFromHexString:(NSString*)colorStr;
+(id)loadNibClass:(NSString *)name;
+(id)loadNib:(NSString *)nibName forClass:(NSString *)name;

+(NSString *)getAppUserDocumentPath;
+(NSString *)getAppTempPath;
+(void)copyFileFromBoundleToAppDocDirIfNeeded:(NSString *)filename;
+(BOOL)existFileInAppUserSubPath:(NSString *)subPath;
+(BOOL)writeData:(NSData *)data toFile:(NSString *)filename;
+(NSString *)locateFilePath:(NSString *)filename;

+(NSArray *)randomlyGroupFrom:(NSArray *)sourceSet withMaxGroupSize:(NSInteger)groupSize;
+(NSArray *)groupFrom:(NSArray *)sourceSet withGroupSize:(NSInteger)groupSize;


+(NSString *)simpleDigitTransToLetter:(NSString *)sourceStr;
+(NSString *)simpleLetterToDigit:(NSString *)sourceStr;

+(NSString *)uniqueID;
+(NSString *)uniqueIDFromISA;
+(NSString *)uniqueIDFromMACAddr;
+(NSString *)MACAddr;

+(UIImage *)scaleImage:(UIImage *)img toSize:(CGSize)size;
+(UIImage *)scaleImage:(UIImage *)img toRatio:(float)ratio;
+(UIImage *)aspectScaleImage:(UIImage *)img toWidth:(float)width;
+(UIImage *)aspectScaleImage:(UIImage *)img toHeight:(float)height;

+(NSString *)md5:(NSString *)str;

+(void)lineStyledButton:(UIButton *)btn lineWidth:(CGFloat)width;
+(void)lineStyledOffForButton:(UIButton *)btn;
+(void)horizontalLineFromView:(UIView *)view lineWidth:(CGFloat)width;
+(void)verticalLineFromView:(UIView *)view lineWidth:(CGFloat)width;
+(void)colorfulStyledSwitch:(UISwitch *)switchControl lineWidth:(CGFloat)width;

+(int)daysBetweenFirstDate:(NSDate *)date1 secondDate:(NSDate *)date2;

+(NSString *)standardTimeStringFrom:(NSInteger )newString;
+(NSString *)nowString;
+(NSString *)nowStringChs;
+(NSString *)nowStringWithinDay;
+(NSString *)nowStringOfDay;
+(NSString *)timedUniqueName;
//+(BOOL)writeImage:(UIImage *)image toPNGFile:(NSString *)filename;
+(UIImage *)getImageFromFile:(NSString *)filename;

+(NSAttributedString *)highlightString:(NSString *)str forKey:(NSArray *)keyStrs withColor:(UIColor *)color;
+(CGSize)sizeForString:(NSString *)text inFont:(UIFont *)font inWidth:(CGFloat)width;
+(CGSize)sizeForAttributedString:(NSAttributedString *)text inWidth:(CGFloat)width;
+(NSString *)numericStringFrom:(NSString*)number;
+(NSString *)numberStringFrom:(NSString*)number;
+(NSString *)tenthousandsOfStringFromNumber:(NSNumber *)value;
+(NSString *)thousandsOfStringFromNumber:(NSNumber *)value;
+(NSString *)integerThousandsOfStringFromNumber:(NSNumber *)value;
+(NSString *)tailZeroTrunkedStringFrom:(NSString*)number;

+(unsigned long long)fileSizeForDir:(NSString*)path;
+(long long)fileSizeAtPath:(NSString *)filePath;
+(BOOL)enouthSpace:(float)fileSize;

+(BOOL)identifyDigitsOnlyString:(NSString *)str;
+(BOOL)identifyChinaMobilePhoneNumber:(NSString *)str;
+(BOOL)identifyChinaMobilePhoneNumberStrict:(NSString *)str;
+(BOOL)identifyFloatNumberString:(NSString *)str;
+(BOOL)identifyIntegerNumberString:(NSString *)str;
+(BOOL)identifyChinaLandLineNumber:(NSString *)str;
+(BOOL)identifyTencentQQNumber:(NSString *)str;
+(BOOL)identifyEmailString:(NSString *)str;
+(BOOL)identifyChinaZipCodeNumber:(NSString *)str;
+(BOOL)identifyChinaIdentifyCardNumber:(NSString *)str;

+(NSString *)platformString;
+(NSString *)internalDeviceInfo;

+(BOOL)MakePhoneCallWithPhoneNumber:(NSString *)phone;
+(NETWORK_TYPE)networkTypeFromStatusBar;

+ (NSString *)base64forData:(NSData *)theData;
//15-18位身份证校验
+ (BOOL)checkUserIdCard:(NSString *)idCard;
//验证6位纯数字验证码
+ (BOOL)checkTestCode:(NSString *)number;
//6~18位，字母或者数字
+ (BOOL)chaekSixToTwentyWordOrNumPassword:(NSString *)passWord;
//验证数字
+ (BOOL)cheakOnlyNum:(NSString *)numStr;
/**
 *  字符串转带千位分隔符的整形数字
 */
+ (NSString *)separatedDigitStringWithStr:(NSString *)digitString;
/**
 *是否时纯数字或者带一个小数点的数字
 */
+ (BOOL)isAllNumOrOnePointNum:(NSString *)numberStr;

+(NSInteger)culculateTotalPages:(float )defaultPageCount count:(float )counts;

+(NSMutableString *)replaceMiddleIdCardStr:(NSString *)idCardStr;

+ (BOOL)cheakPhoneNumber:(NSString *)phone;

@end





