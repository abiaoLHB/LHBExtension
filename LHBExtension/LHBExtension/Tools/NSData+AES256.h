//
//  NSData+AES256.h
//  WYEasyLoan
//
//  Created by TAD on 4/11/16.
//  Copyright © 2016 zhsoftbank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;


@end







