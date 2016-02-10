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

@implementation TGAttachment

+ (instancetype) attachmentWithText:(NSString*)text andName:(NSString*)name {
    return [[TGAttachment alloc] initWithType:@"text" content:text andName:name];
}

+ (instancetype) attachmentWithNSURL:(NSURL*)url andName:(NSString*)name {
    return [self attachmentWithURL:url.absoluteString andName:name];
}

+ (instancetype) attachmentWithURL:(NSString*)urlString andName:(NSString*)name {
    return [[TGAttachment alloc] initWithType:@"url" content:urlString andName:name];
}

- (instancetype) initWithType:(NSString*)type content:(NSString*)content andName:(NSString*)name {
    self = [super init];
    if (self) {
        _type = type;
        _content = content;
        _name = name;
    }
    return self;
}

#pragma mark - JSON Parsing

- (NSDictionary*)jsonMapping {
    return @{
             @"content" : @"content",
             @"type" : @"type",
             @"name" : @"name"
             };
}

@end
