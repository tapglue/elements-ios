//
//  NSURL+TGUtilities.m
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

#import "NSURL+TGUtilities.h"

@implementation NSURL (TGUtilities)

- (NSURL*) tg_URLByAppendingQueryParameters:(NSDictionary*)queryParameters {
    NSString* URLString = [NSString stringWithFormat:@"%@?%@",
                           [self absoluteString],
                           [NSURL tg_stringFromQueryParameters:queryParameters]
                           ];
    return [NSURL URLWithString:URLString];
}

+ (NSString*) tg_stringFromQueryParameters:(NSDictionary*)queryParameters {
    NSMutableArray* parts = [NSMutableArray array];
    [queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [key stringByAddingPercentEncodingWithAllowedCharacters:set],
                          [value stringByAddingPercentEncodingWithAllowedCharacters:set]
                          ];
        [parts addObject:part];
    }];
    return [parts componentsJoinedByString: @"&"];
}

@end
