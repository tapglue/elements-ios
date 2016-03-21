//
//  NSString+TGUtilities.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 02/06/15.
//  Copyright (c) 2015 Tapglue (https://www.tapglue.com/). All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "NSString+TGUtilities.h"
#import <CommonCrypto/CommonKeyDerivation.h>

@implementation NSString (TGUtilities)

- (NSString*)tg_stringHashedViaPBKDF2 {

    // based on http://stackoverflow.com/a/18589289/1879171

    // Salt data getting from salt string.
    NSData *saltData = [@"Salt String" dataUsingEncoding:NSUTF8StringEncoding];

    // Data of String to generate Hash key(hexa decimal string).
    NSData *inputData = [self dataUsingEncoding:NSUTF8StringEncoding];

    // Hash key (hexa decimal) string data length.
    NSMutableData *hashKeyData = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];

    // Key Derivation using PBKDF2 algorithm.
    CCKeyDerivationPBKDF(kCCPBKDF2, inputData.bytes, inputData.length, saltData.bytes, saltData.length, kCCPRFHmacAlgSHA1, 1000, hashKeyData.mutableBytes, hashKeyData.length);

    // Hexa decimal or hash key string from hash key data.
    NSString *hexDecimalString = hashKeyData.description;

    hexDecimalString = [hexDecimalString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" <>"]];
    hexDecimalString = [hexDecimalString stringByReplacingOccurrencesOfString:@" " withString:@""];

    return hexDecimalString;
}

@end
