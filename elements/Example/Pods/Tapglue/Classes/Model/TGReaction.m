//
//  TGReaction.m
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

#import "TGReaction.h"
#import "TGUser+Private.h"
#import "TGPost.h"
#import "TGModelObject+Private.h"
#import "NSDictionary+TGUtilities.h"

static NSString *const TGReactionUserIdJsonKey = @"user_id";
static NSString *const TGReactionPostIdJsonKey = @"post_id";

@interface TGReaction ()
@property (nonatomic, strong) TGUser *user;
@property (nonatomic, strong) TGPost *post;
@end

@implementation TGReaction

#pragma mark - JSON Parsing

- (void)loadDataFromDictionary:(NSDictionary *)data withMapping:(NSDictionary *)mapping {
    [super loadDataFromDictionary:data withMapping:mapping];
    _user = [TGUser objectWithId:[data tg_stringValueForKey:TGReactionUserIdJsonKey]];
    _post = [TGPost objectWithId:[data tg_stringValueForKey:TGReactionPostIdJsonKey]];
}

- (NSDictionary*)jsonMapping {
    // left side: json attribute name , right side: model property name
    // post_id and user_id are handled separety 
    return @{};
}

- (NSDictionary*)jsonMappingForWriting {
    // left side: json attribute name , right side: model property name
    return @{ @"user_id" : @"user.objectId",
              @"post_id" : @"post.objectId" };
}

- (NSDictionary*)jsonDictionary {
    // id on posts must be a string while all other objects use numbers
    NSMutableDictionary *jsonDictionary = [super jsonDictionary].mutableCopy;
    jsonDictionary[TGModelObjectIdJsonKey] = [jsonDictionary[TGModelObjectIdJsonKey] stringValue];
    return jsonDictionary;
}

@end
