//
//  NSDictionary+TGUtilities.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 04/06/15.
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

#import "NSDictionary+TGUtilities.h"

@implementation NSDictionary (TGUtilities)

- (BOOL) tg_hasStringValueForKey:(NSString*)key {
    return  [self valueForKey:key] && [[self valueForKey:key] isKindOfClass:[NSString class]];
}

- (BOOL) tg_hasNumberValueForKey:(NSString*)key {
    return  [self valueForKey:key] && [[self valueForKey:key] isKindOfClass:[NSNumber class]];
}

- (NSString*)tg_stringValueForKey:(NSString*)key {
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    }
    return nil;
}

@end

@implementation NSMutableDictionary (TGUtilities)

- (void)tg_setValueIfNotNil:(id)value forKey:(NSString*)key {
    if (value) {
        [self setValue:value forKey:key];
    }
}

- (void)tg_setValueOrNull:(id)value forKey:(NSString*)key {
    [self setValue:(value ?: [NSNull null]) forKey:key];
}


@end
