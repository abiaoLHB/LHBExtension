//
//  NSString+QuotationSQL.h
//  LetsOrder
//
//  Created by xtan on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+(NSData *)dataWithBase64EncodedString:(NSString *)string;
-(id)initWithBase64EncodedString:(NSString *)string;
-(NSString *)base64Encoding;
-(NSString *)base64EncodingWithLineLength:(unsigned int) lineLength;

@end












