//
//  NSError+TGError.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 10/06/15.
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

#import "NSError+TGError.h"
#import "TGConstants.h"

NSString *const TGErrorUnderlyingErrorsKey = @"TGUnderlyingErrors";
NSString *const TGErrorHTTPStatusCodeKey = @"HTTP Status Code";

@implementation NSError (TGError)

+ (NSError*)tg_errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict {
    return [NSError errorWithDomain:TGErrorDomain code:code userInfo:dict];
}

+ (NSError*)tg_errorFromJsonDicitonary:(NSDictionary*)dictionary {
    return [self tg_errorFromJsonDicitonary:dictionary withUserInfo:nil];
}

+ (NSError*)tg_errorFromJsonDicitonary:(NSDictionary*)dictionary withUserInfo:(NSDictionary*)userInfo {
    NSMutableDictionary *errorDictionary = userInfo ? userInfo.mutableCopy : [NSMutableDictionary dictionary];

    if ([dictionary objectForKey:@"message"]) {
        [errorDictionary setObject:[dictionary objectForKey:@"message"] forKey: NSLocalizedDescriptionKey];
    }


    NSInteger errorCode = [[dictionary valueForKey:@"code"] integerValue];
    if (errorCode < 1) {
        errorCode = kTGErrorUnknownError;
    }
    return [self tg_errorWithCode:errorCode userInfo:errorDictionary];
}

@end
