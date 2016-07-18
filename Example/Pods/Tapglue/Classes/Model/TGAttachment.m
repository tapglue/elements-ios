//
//  TGAttachments.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 08/12/15.
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

#import "TGAttachment.h"
#import "TGModelObject+Private.h"

@interface TGAttachment ()
@property (nonatomic, strong) NSMutableDictionary *mutableContents;
@end

@implementation TGAttachment

+ (instancetype) attachmentWithText:(NSDictionary *)text andName:(NSString*)name {
    return [[TGAttachment alloc] initWithType:@"text" content:text andName:name];
}

+ (instancetype) attachmentWithURL:(NSDictionary *)urlStrings andName:(NSString*)name {
    return [[TGAttachment alloc] initWithType:@"url" content:urlStrings andName:name];
}

- (instancetype) initWithType:(NSString*)type content:(NSDictionary*)contents andName:(NSString*)name {
    self = [super init];
    if (self) {
        _contents = contents;
        _type = type;
        _name = name;
    }
    return self;
}

#pragma mark - JSON Parsing

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
    return @{
             @"contents": @"contents",
             @"type" : @"type",
             @"name" : @"name"
             };
}

@end
