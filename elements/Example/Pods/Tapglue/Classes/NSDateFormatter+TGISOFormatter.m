//
//  NSDateFormatter+TGISOFormatter.m
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

#import "NSDateFormatter+TGISOFormatter.h"

@interface __TGISOFormatter : NSDateFormatter
@end

@implementation NSDateFormatter (TGISOFormatter)

+ (NSDateFormatter*)tg_isoDateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *isoDateFormatter;
    dispatch_once(&onceToken, ^{
        isoDateFormatter = [[__TGISOFormatter alloc] init];
        isoDateFormatter.locale = [NSLocale currentLocale];
        isoDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        isoDateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    });
    return isoDateFormatter;
}

@end

@implementation __TGISOFormatter

- (NSDate*)dateFromString:(NSString *)string {

    // FIXME: when reading the current user from the user defaults a NSDate object come in for some reason
    if ([string isKindOfClass:[NSDate class]]) {
        return (NSDate*)string;
    }

    if ([string isKindOfClass:[NSString class]]) {
        NSString *newString = [[string substringToIndex:19] stringByAppendingString:@"Z"];
        return [super dateFromString:newString];
    }

    return nil;
}
@end
