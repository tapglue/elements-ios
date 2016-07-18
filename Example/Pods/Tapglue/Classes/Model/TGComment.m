//
//  TGComment.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 09/12/15.
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

#import "TGComment.h"
#import "TGObject+Private.h"

@interface TGComment ()
@property (nonatomic, strong) NSMutableDictionary *mutableContents;
@end

@implementation TGComment

- (void)loadDataFromDictionary:(NSDictionary *)data withMapping:(NSDictionary *)mapping {
    [super loadDataFromDictionary:data withMapping:mapping];
    [self loadContentsFromDictionary:data];
}

- (void)loadContentsFromDictionary:(NSDictionary *)data {
    if([data objectForKey:@"contents"] == nil) {
        return;
    }
    _mutableContents = [NSMutableDictionary new];
    [data[@"contents"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *languageTag = key;
        NSString *content = obj;
        [_mutableContents setObject:content forKey:languageTag];
    }];
    _contents = _mutableContents;
}
- (NSDictionary*)jsonMapping {
    // left side: json attribute name , right side: model property name
    return @{
             @"contents" : @"contents",
             @"external_id" : @"externalId"
             };
}

- (NSDictionary*)jsonMappingForWriting {
    NSMutableDictionary *mapping = [super jsonMappingForWriting].mutableCopy;
    [mapping addEntriesFromDictionary: [self jsonMapping]];
    return mapping;
}

@end
