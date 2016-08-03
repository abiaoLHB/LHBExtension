//
//  Utilities.m
//  WYFinance
//
//  Created by jhdu on 3/28/16.
//  Copyright © 2016 zhsoftbank. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

#include <sys/sysctl.h>
#import "sys/utsname.h"

// About Custom UDID for IOS5
#include <stdio.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
#include <ifaddrs.h>
#import <CommonCrypto/CommonDigest.h>
//#import <AdSupport/ASIdentifierManager.h>



#define kDevKey @"12345" //Custom KEY
#define MAXDATECOUNT 99999999
#define UTIL_UIDKEY @"MTF_UID_KEY"

+(UIColor*)colorFromHexString:(NSString*)colorStr{
    UIColor* result;
    if ([colorStr length] != 6) {//rrggbb
        return nil;
    }
    unsigned int r,g,b;
    [[NSScanner scannerWithString:[colorStr substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[colorStr substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[colorStr substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    result = [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1.];
    return result;
}

+(id)loadNibClass:(NSString *)name{
    NSArray *objSet = [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
    
    id targetClass = NSClassFromString(name);
    id result = nil;
    for (id object in objSet) {
        if ([object isKindOfClass:targetClass]){
            result = object;
            break;
        }
    }
    return result;
}
+(id)loadNib:(NSString *)nibName forClass:(NSString *)name{
    NSArray *objSet = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    
    id targetClass = NSClassFromString(name);
    id result = nil;
    for (id object in objSet) {
        if ([object isKindOfClass:targetClass]){
            result = object;
            break;
        }
    }
    return result;
}

+(NSString *)getAppUserDocumentPath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    //    NSHomeDirectory();
    return documentsDir;
}
+(NSString *)getAppTempPath{
    
    //set appDir/tmp as the temporary target
    NSString *dPath = [self getAppUserDocumentPath];
    NSMutableArray *dPAr = [NSMutableArray arrayWithArray:[dPath pathComponents]];
    [dPAr removeLastObject];
    [dPAr addObject:@"tmp"];
    NSString *aPath = [NSString pathWithComponents:dPAr];
    return aPath;
}

+(void)copyFileFromBoundleToAppDocDirIfNeeded:(NSString *)filename{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *localPath = [self locateFilePath:filename];
    BOOL success = [fileManager fileExistsAtPath:localPath];
    if(!success) {
        NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
        success = [fileManager copyItemAtPath:defaultPath toPath:localPath error:&error];
        if (!success){
            NSAssert1(0, @"Failed to create file with message '%@'.", [error localizedDescription]);
        }
    }
}
+(BOOL)existFileInAppUserSubPath:(NSString *)subName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appDocPath = [self getAppUserDocumentPath];
    return [fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@", appDocPath, subName]];
}
+(BOOL)writeData:(NSData *)data toFile:(NSString *)filename{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager createFileAtPath:filename contents:data attributes:nil];
}
+(NSString *)locateFilePath:(NSString *)filename{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:filename];
}

+(NSArray *)randomlyGroupFrom:(NSArray *)sourceSet withMaxGroupSize:(NSInteger)groupSize{
    
    //{1, 2, 3, 4, 5, ...} ---> {1, 2}, {3}, {4, 5}, ...
    //protection
    if (!sourceSet) {
        return nil;
    }
    //sourceSet should be nsNumber array;
    if ([sourceSet count] && ![[sourceSet objectAtIndex:0] isKindOfClass:[NSNumber class]]){
        return nil;
    }
    //processing
    int count = [sourceSet count];
    int counted = 0;
    NSMutableArray *result = [NSMutableArray array];
    
    while (count - counted >= groupSize) {
        int group_s = rand()%groupSize + 1;
        NSMutableArray *gp_set = [NSMutableArray array];
        for (int i = 0; i < group_s; i ++) {
            [gp_set addObject:[sourceSet objectAtIndex:counted]];
            counted ++;
        }
        [result addObject:gp_set];
    }
    if (counted < count){
        NSMutableArray *last_gp_set = [NSMutableArray array];
        for (int i = 0; i < count - counted; i ++) {
            [last_gp_set addObject:[sourceSet objectAtIndex:counted]];
            counted ++;
        }
        [result addObject:last_gp_set];
    }
    return result;
}
+(NSArray *)groupFrom:(NSArray *)sourceSet withGroupSize:(NSInteger)groupSize{
    
    //{1, 2, 3, 4, 5, ...} ---> {1, 2}, {3}, {4, 5}, ...
    //protection
    if (!sourceSet) {
        return nil;
    }
    //sourceSet should be nsNumber array;
    if ([sourceSet count] && ![[sourceSet objectAtIndex:0] isKindOfClass:[NSNumber class]]){
        return nil;
    }
    //processing
    int count = [sourceSet count];
    int counted = 0;
    NSMutableArray *result = [NSMutableArray array];
    
    while (count - counted >= groupSize) {
        
        NSMutableArray *gp_set = [NSMutableArray array];
        for (int i = 0; i < groupSize; i ++) {
            [gp_set addObject:[sourceSet objectAtIndex:counted]];
            counted ++;
        }
        [result addObject:gp_set];
    }
    if (counted < count){
        NSMutableArray *last_gp_set = [NSMutableArray array];
        for (int i = 0; i < count - counted; i ++) {
            [last_gp_set addObject:[sourceSet objectAtIndex:counted]];
            counted ++;
        }
        [result addObject:last_gp_set];
    }
    return result;
}

+(NSString *)simpleDigitTransToLetter:(NSString *)sourceStr{
    
    NSString * result = nil;
    
    if ([sourceStr length]) {
        result = [sourceStr stringByReplacingOccurrencesOfString:@"0" withString:@"o"];
        result = [result stringByReplacingOccurrencesOfString:@"1" withString:@"i"];
        result = [result stringByReplacingOccurrencesOfString:@"2" withString:@"z"];
        result = [result stringByReplacingOccurrencesOfString:@"3" withString:@"E"];
        result = [result stringByReplacingOccurrencesOfString:@"4" withString:@"h"];
        result = [result stringByReplacingOccurrencesOfString:@"5" withString:@"s"];
        result = [result stringByReplacingOccurrencesOfString:@"6" withString:@"g"];
        result = [result stringByReplacingOccurrencesOfString:@"7" withString:@"L"];
        result = [result stringByReplacingOccurrencesOfString:@"8" withString:@"B"];
        result = [result stringByReplacingOccurrencesOfString:@"9" withString:@"b"];
    }
    
    return result;
}
+(NSString *)simpleLetterToDigit:(NSString *)sourceStr{
    
    NSString * result = nil;
    
    if ([sourceStr length]) {
        result = [sourceStr stringByReplacingOccurrencesOfString:@"o" withString:@"0"];
        result = [result stringByReplacingOccurrencesOfString:@"i" withString:@"1"];
        result = [result stringByReplacingOccurrencesOfString:@"z" withString:@"2"];
        result = [result stringByReplacingOccurrencesOfString:@"E" withString:@"3"];
        result = [result stringByReplacingOccurrencesOfString:@"h" withString:@"4"];
        result = [result stringByReplacingOccurrencesOfString:@"s" withString:@"5"];
        result = [result stringByReplacingOccurrencesOfString:@"g" withString:@"6"];
        result = [result stringByReplacingOccurrencesOfString:@"L" withString:@"7"];
        result = [result stringByReplacingOccurrencesOfString:@"B" withString:@"8"];
        result = [result stringByReplacingOccurrencesOfString:@"b" withString:@"9"];
    }
    
    return result;
}


+(NSString *)uniqueID{
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0) {
        return [Utilities uniqueIDFromISA];
    }
    else {
        return [Utilities uniqueIDFromMACAddr];
    }
}
+(NSString *)uniqueIDFromISA{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *resultStr = [defaults objectForKey:UTIL_UIDKEY];
    if (!resultStr) {
        
        NSString *devKey = kDevKey;
        //    NSString *MACAddr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSString *MACAddr = [[NSUUID UUID] UUIDString];
        
        const char  *cstart = [[NSString stringWithFormat:@"%C%C%@%@%C%C",
                                [MACAddr characterAtIndex:6],
                                [MACAddr characterAtIndex:7],
                                devKey,
                                MACAddr,
                                [MACAddr characterAtIndex:3],
                                [MACAddr characterAtIndex:4]] UTF8String];
        
        unsigned char result[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(cstart,strlen(cstart),result);
        
        NSMutableString *hash = [NSMutableString string];
        
        int i;
        for (i=0; i < 20; i++) {
            [hash appendFormat:@"%02x",result[i]];
        }
        
        resultStr = [hash lowercaseString];
        [defaults setObject:resultStr forKey:UTIL_UIDKEY];
    }
    return resultStr;
}
+(NSString *)uniqueIDFromMACAddr{
    
    NSString *devKey = kDevKey;
    NSString *MACAddr = [Utilities MACAddr];
    
    const char  *cstart = [[NSString stringWithFormat:@"%C%C%@%@%C%C",
                            [MACAddr characterAtIndex:6],
                            [MACAddr characterAtIndex:7],
                            devKey,
                            MACAddr,
                            [MACAddr characterAtIndex:3],
                            [MACAddr characterAtIndex:4]] UTF8String];
    
    
    
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cstart,strlen(cstart),result);
    
    NSMutableString *hash = [NSMutableString string];
    
    int i;
    for (i=0; i < 20; i++) {
        [hash appendFormat:@"%02x",result[i]];
    }
    
    return [hash lowercaseString];
}
+(NSString *)MACAddr{
    struct ifaddrs *interfaces;
    const struct ifaddrs *tmpaddr;
    
    if (getifaddrs(&interfaces)==0)
    {
        tmpaddr = interfaces;
        
        while (tmpaddr != NULL)
        {
            if (strcmp(tmpaddr->ifa_name,"en0")==0)
            {
                struct sockaddr_dl *dl_addr = ((struct sockaddr_dl *)tmpaddr->ifa_addr);
                uint8_t *base = (uint8_t *)&dl_addr->sdl_data[dl_addr->sdl_nlen];
                
                NSMutableString *s = [NSMutableString string];
                int l = dl_addr->sdl_alen;
                int i;
                
                for (i=0; i < l; i++)
                {
                    [s appendFormat:(i!=0)?@":%02x":@"%02x",base[i]];
                }
                
                return s;
            }
            
            tmpaddr = tmpaddr->ifa_next;
        }
        
        freeifaddrs(interfaces);
    }
    return @"00:00:00:00:00:00";
}

+(UIImage *)scaleImage:(UIImage *)img toSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+(UIImage *)scaleImage:(UIImage *)img toRatio:(float)ratio{
    
    float w = img.size.width * ratio;
    float h = img.size.height * ratio;
    CGSize size = CGSizeMake(w, h);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+(UIImage *)aspectScaleImage:(UIImage *)img toWidth:(float)width{
    
    float ratio = width / img.size.width;
    float h = img.size.height * ratio;
    CGSize size = CGSizeMake(width, h);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+(UIImage *)aspectScaleImage:(UIImage *)img toHeight:(float)height{
    
    float ratio = height / img.size.height;
    float w = img.size.width * ratio;
    CGSize size = CGSizeMake(w, height);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(NSString *)md5:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(void)lineStyledButton:(UIButton *)btn lineWidth:(CGFloat)width{
    
    UIColor *tColor = btn.currentTitleColor;
    [btn.layer setBorderWidth:width];
    [btn.layer setBorderColor:[tColor CGColor]];
}
+(void)lineStyledOffForButton:(UIButton *)btn{
    
    [btn.layer setBorderColor:[[UIColor clearColor] CGColor]];
}
+(void)horizontalLineFromView:(UIView *)view lineWidth:(CGFloat)width{
    
    view.frame = CGRectMake(view.frame.origin.x,
                            view.frame.origin.y,
                            view.frame.size.width,
                            width);
}
+(void)verticalLineFromView:(UIView *)view lineWidth:(CGFloat)width{
    
    view.frame = CGRectMake(view.frame.origin.x,
                            view.frame.origin.y,
                            width,
                            view.frame.size.width);
}
+(void)colorfulStyledSwitch:(UISwitch *)switchControl lineWidth:(CGFloat)width{
    
    switchControl.layer.borderColor = [switchControl.onTintColor CGColor];
    switchControl.layer.borderWidth = width;
    switchControl.layer.cornerRadius = 15;
}

+(int)daysBetweenFirstDate:(NSDate *)date1 secondDate:(NSDate *)date2{
    
    NSTimeInterval interval = [date2 timeIntervalSinceDate:date1];
    return (int)(interval / 86400);
}

+(NSString *)standardTimeStringFrom:(NSInteger )newString{
    NSString *str, *str1, *str2, *str3;
    int hours = newString / 3600;
    int minutes = (newString % 3600) / 60;
    int seconds = newString - 3600 * hours - 60 *minutes;
    if (seconds < 10) {
        str1 = [NSString stringWithFormat:@"0%d",seconds];
    }
    else{
        str1 = [NSString stringWithFormat:@"%d",seconds];
    }
    if (minutes < 10) {
        str2 = [NSString stringWithFormat:@"0%d",minutes];
    }
    else{
        str2 = [NSString stringWithFormat:@"%d",minutes];
    }
    
    if (hours < 10) {
        str3 = [NSString stringWithFormat:@"0%d",hours];
    }
    else{
        str3 = [NSString stringWithFormat:@"%d",hours];
    }
    str = [NSString stringWithFormat:@"%@:%@:%@",str3,str2,str1];
    return str;
}
+(NSString *)nowString{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    return str;
}
+(NSString *)nowStringChs{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年 MM月 dd日 HH:mm:ss"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    return str;
}
+(NSString *)nowStringWithinDay{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    return str;
}
+(NSString *)nowStringOfDay{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    return str;
}
+(NSString *)timedUniqueName{
    
    NSString *result = nil;
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"SSS"];
    NSString *milSecStr = [formatter stringFromDate:[NSDate date]];
    result = [NSString stringWithFormat:@"%@-%@", nowStr, [self md5:milSecStr]];
    
    return result;
}

+(UIImage *)getImageFromFile:(NSString *)filename{
    
    UIImage *result = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filename]) {
        result = [UIImage imageWithContentsOfFile:filename];
    }
    return result;
}

+(NSAttributedString *)highlightString:(NSString *)str forKey:(NSArray *)keyStrs withColor:(UIColor *)color{
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:str];
    for (NSString *s in keyStrs) {
        NSRange range = [str rangeOfString:s options:NSCaseInsensitiveSearch];
        [result setAttributes:[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName] range:range];
    }
    return result;
}
+(CGSize)sizeForString:(NSString *)text inFont:(UIFont *)font inWidth:(CGFloat)width{
    
    //    CGSize sizeToFit = [text sizeWithFont:font
    //                        constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
    //                            lineBreakMode:NSLineBreakByWordWrapping];
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                          context:nil];
    return rectToFit.size;
}
+(CGSize)sizeForAttributedString:(NSAttributedString *)text inWidth:(CGFloat)width{
    
    CGRect rectToFit = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                          context:nil];
    return rectToFit.size;
}
+(NSString *)numericStringFrom:(NSString*)number{
    
    NSString *num = @"";
    NSCharacterSet *sting = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < number.length; i ++) {
        
        NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:sting];
        if (range.length) {
            
            num = [num stringByAppendingString:string];
        }
    }
    return num;
}
+(NSString *)numberStringFrom:(NSString*)number{
    
    NSString *num = @"";
    NSCharacterSet *sting = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    for (int i = 0; i < number.length; i ++) {
        
        NSString *string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:sting];
        if (range.length) {
            
            num = [num stringByAppendingString:string];
        }
    }
    return num;
}
+(NSString *)tenthousandsOfStringFromNumber:(NSNumber *)value{
    
    
    if (value.longLongValue / 10000 == 0) {
        
        return @"小于1万";
    }
    else{
        NSString *tenthousandStr = [self thousandsOfStringFromNumber:[NSNumber numberWithDouble:value.doubleValue / 10000]];
        return [NSString stringWithFormat:@"%@ 万", [tenthousandStr substringToIndex:tenthousandStr.length - 3]];
    }
}
+(NSString *)integerThousandsOfStringFromNumber:(NSNumber *)value{
    
    NSString *integerStr = [self thousandsOfStringFromNumber:value];
    return [integerStr substringToIndex:integerStr.length - 3];
}
+(NSString *)thousandsOfStringFromNumber:(NSNumber *)value{
    
    double orignialVal = [value doubleValue];
    NSString *originalStr = [NSString stringWithFormat:@"%.2f", orignialVal];
    NSString *floatPartStr = [originalStr substringWithRange:NSMakeRange(originalStr.length - 3, 3)];
    
    NSString *result = floatPartStr;
    NSString *integerPartStr = [originalStr substringToIndex:originalStr.length - 3];
    
    int lastPiece = integerPartStr.length % 3;
    NSInteger slice = integerPartStr.length / 3 + (lastPiece == 0 ? 0 : 1);
    
    for (int i = 1; i <= slice; i ++) {
        
        NSInteger rangeLoc = integerPartStr.length - i * 3;
        NSString *sliceDigStr = nil;
        if (rangeLoc < 0) {
            
            if (integerPartStr.length >= 3) {
                
                sliceDigStr = [integerPartStr substringWithRange:NSMakeRange(0, 3)];
            }
            else{
                
                sliceDigStr = integerPartStr;
            }
            
        }
        else{
            
            sliceDigStr = [integerPartStr substringWithRange:NSMakeRange(integerPartStr.length - i * 3, 3)];
        }
        if (i == 1) {
            result = [NSString stringWithFormat:@"%@%@", sliceDigStr, result];
        }
        else if (i == slice && lastPiece != 0) {
            NSString *lastPieceDigStr = [integerPartStr substringWithRange:NSMakeRange(0, lastPiece)];
            result = [NSString stringWithFormat:@"%@,%@", lastPieceDigStr, result];
        }
        else {
            result = [NSString stringWithFormat:@"%@,%@", sliceDigStr, result];
        }
    }
    return result;
}
+(NSString *)tailZeroTrunkedStringFrom:(NSString*)number{
    
    NSRange rangOfDot = [number rangeOfString:@"."];
    if (rangOfDot.location != NSNotFound) {
        
        if (rangOfDot.location > 0 && rangOfDot.location < number.length) {
            
            for (int i = number.length - 1; i > rangOfDot.location; i --) {
                
                if (![[number substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"0"]) {
                    
                    return [number substringToIndex:i + 1];
                }
            }
            return [number substringToIndex:rangOfDot.location];
        }
    }
    return number;
}
+(unsigned long long)fileSizeForDir:(NSString*)path{
    
    long long size = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    for (NSString *subPath in array) {
        
        NSString *fullPath = [path stringByAppendingPathComponent:subPath];
        BOOL isDir;
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&isDir]) {
            if (isDir) {
                size += ([self fileSizeForDir:fullPath]);
            }
            else {
                NSDictionary *fileAttributeDic = [fileManager attributesOfItemAtPath:fullPath error:nil];
                size += (fileAttributeDic.fileSize);
            }
        }
    }
    return size;
}
+(long long)fileSizeAtPath:(NSString *)filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
+(BOOL)enouthSpace:(float)fileSize{
    
    float totalSpace = 0.0;
    float totalFreeSpace = 0.0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %f GB with %f GB Free memory available.", ((totalSpace/1024.0f)/1024.0f/1024.0f), ((totalFreeSpace/1024.0f)/1024.0f)/1024.0f);
    }
    else {
        NSLog(@"Error Obtaining System Memory"); //Info: Domain = %@, Code = %@", [error domain], [error code]);
    }
    
    if (fileSize < totalFreeSpace * 0.9) {
        return YES;
    }
    return NO;
}

+(BOOL)identifyDigitsOnlyString:(NSString *)str{
    
    NSString * regex = @"^[0-9]{1,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
+(BOOL)identifyChinaMobilePhoneNumber:(NSString *)str{
    
    NSString * regex = @"^[0-9]{7,15}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
+(BOOL)identifyChinaMobilePhoneNumberStrict:(NSString *)str{
    
    NSString * regex = @"^(\\+861|00861|861|1)[2,3,4,5,7,8,9]{1}[0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
+(BOOL)identifyFloatNumberString:(NSString *)str{
    
    NSString * rege = @"^[1-9]\\d*\\.\\d*|[1-9]\\d*|0\\.\\d*[1-9]\\d*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rege];
    return [pred evaluateWithObject:str];
    
}
+(BOOL)identifyIntegerNumberString:(NSString *)str{
    
    NSString * regex = @"^[1-9]{1}\\d*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
+(BOOL)identifyChinaLandLineNumber:(NSString *)str{
    
    //    NSString * regex = @"^0[1-9]{1}[0-9]{9}$";
    NSString * regex = @"^(\\+860|00860|860|0)[1-9]{1}[0-9]{1,2}[1-9]{1}[0-9]{6,7}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
+(BOOL)identifyTencentQQNumber:(NSString *)str{
    
    NSString * regex = @"^[1-9]{1}[0-9]{4,9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
+(BOOL)identifyEmailString:(NSString *)str{
    
    NSString * regex = @"^[A-Za-z0-9_.-]{1,}@{1}[A-Za-z0-9_.-]{1,}.{1}[A-Za-z.]{1,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
+(BOOL)identifyChinaZipCodeNumber:(NSString *)str{
    
    NSString * regex = @"^[1-9]{1}[0-9]{5}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}
+(BOOL)identifyChinaIdentifyCardNumber:(NSString *)str{
    
    NSString * regex = @"^[1-9]{1}[1-9*]{1}[0-9]{15}[0-9X]{1}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}

+(NSString *)platformString{
    
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    //    char *machine = malloc(size);
    char *machine = new char[size];
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    //    free(machine);
    delete [] machine;
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (CDMA)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (CDMA)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}
+(NSString *)internalDeviceInfo{
    
    //here use sys/utsname.h
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+(BOOL)MakePhoneCallWithPhoneNumber:(NSString *)phone{
    
    BOOL result = NO;
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *call = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
    if ([app canOpenURL:call]) {
        [app openURL:call];
        result = YES;
    }
    return result;
}

//Make sure that the Status bar is not hidden in your application. if it's not visible it will always return No wifi or cellular because your code reads the text in the Status bar thats all.
+(NETWORK_TYPE)networkTypeFromStatusBar{
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:NO];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            
            dataNetworkItemView = subview;
            
            break;
        }
    }
    
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = (NETWORK_TYPE)[num integerValue];
    
    NSString *resultStr = nil;
    switch (nettype) {
        case NETWORK_TYPE_NONE:
            resultStr = @"None";
            break;
        case NETWORK_TYPE_2G:
            resultStr = @"2G";
            break;
        case NETWORK_TYPE_3G:
            resultStr = @"3G";
            break;
        case NETWORK_TYPE_4G:
            resultStr = @"4G";
            break;
        case NETWORK_TYPE_LTE:
            resultStr = @"LTE";
            break;
        case NETWORK_TYPE_WIFI:
            resultStr = @"WiFi";
            break;
    }
    
    return nettype;
}

+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (BOOL)checkUserIdCard:(NSString *)idCard
{
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X|x)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:idCard];
    return isMatch;
}
//验证6位纯数字验证码
+ (BOOL)checkTestCode:(NSString *)number
{
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:number];
    return isMatch;
}
//6~18位，字母或者数字
+ (BOOL)chaekSixToTwentyWordOrNumPassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}
//只校验数字
+ (BOOL)cheakOnlyNum:(NSString *)numStr
{
    NSString *pattern = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:numStr];
    return isMatch;
}
/**
 *  字符串转带千位分隔符的整形数字
 */
+ (NSString *)separatedDigitStringWithStr:(NSString *)digitString
{
    if (digitString == nil) {
        return @"";
    }
    else if ([digitString isKindOfClass:[NSNull class]]) {
        return nil;
    }else{
        NSString *originalStr = @".";
        NSRange range = [digitString rangeOfString:originalStr];
        
        if(range.location != NSNotFound)
        {
            NSString *fontStr = [digitString substringToIndex:range.location];
            NSString *houStr = [digitString substringFromIndex:range.location];
            NSInteger numberInteger = fontStr.integerValue;
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *backStr = [numberFormatter stringFromNumber: [NSNumber numberWithInteger:numberInteger]];
            return  [NSString stringWithFormat:@"%@%@",backStr,houStr];
        }else{
            NSInteger numberInteger = digitString.integerValue;
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
            numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSString *backStr = [numberFormatter stringFromNumber: [NSNumber numberWithInteger:numberInteger]];
            return backStr;
        }
    }
}

/**
 *是否时纯数字或者带一个小数点的数字
 */
+ (BOOL)isAllNumOrOnePointNum:(NSString *)numberStr
{
    //防止粘贴非法字符
    NSRange range = [numberStr rangeOfString:@"."];
    if ( [Utilities cheakOnlyNum:numberStr]) {//纯数字
        return YES;
    }
    else if(range.location != NSNotFound) {//有小数点
        //防止粘贴非法字符
        //是否有多个小数点
        NSString *temp1Str = [numberStr substringToIndex:range.location];
        NSString *temp2Str = [numberStr substringFromIndex:range.location+1];//去掉小数点
        NSString *okStr = [NSString stringWithFormat:@"%@%@",temp1Str,temp2Str];
        NSRange rangTwo = [okStr rangeOfString:@"."];
        if (rangTwo.location != NSNotFound) {//依然有小数点
            return NO;
        }else{//只有一个小数点
            return YES;
        }
    }else{
        return NO;
    }
    return NO;
}
+ (NSMutableString *)replaceMiddleIdCardStr:(NSString *)idCardStr
{
    if (!idCardStr) {
        return nil;
    }
    NSMutableString *muStr = [NSMutableString stringWithString:idCardStr];
    if (idCardStr.length == 18) {
        [muStr replaceCharactersInRange:NSMakeRange(5, 9) withString:@"*********"];
    }else{
        [muStr replaceCharactersInRange:NSMakeRange(5, 6) withString:@"******"];
    }
    return muStr;
}
+(NSInteger)culculateTotalPages:(float)defaultPageCount count:(float )counts{
    
    float pages = (counts / defaultPageCount) ;
    return ceilf(pages);
}
//正则判断手机号码格式
+ (BOOL)cheakPhoneNumber:(NSString *)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

@end













