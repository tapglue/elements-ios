//
//  TGPost.m
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


#import "TGPost.h"
#import "TGUser+Private.h"
#import "TGModelObject+Private.h"
#import "TGObjectCache.h"
#import "NSDictionary+TGUtilities.h"
#import "TGAttachment.h"

static NSString *const TGPostTagsJsonKey = @"tags";
static NSString *const TGPostVisibilityJsonKey = @"visibility";
static NSString *const TGPostAttachmentsJsonKey = @"attachments";
static NSString *const TGPostUserIdJsonKey = @"user_id";
static NSString *const TGPostIsLikedKey = @"is_liked";

@interface TGPost ()
@property (nonatomic, strong) NSMutableArray *mutableAttachemnts;
@end

@implementation TGPost

+ (instancetype)createOrLoadWithDictionary:(NSDictionary*)data {
    TGObjectCache *cache = [self cache];
    TGPost *post = [cache objectWithObjectId:[data tg_stringValueForKey:TGModelObjectIdJsonKey]];
    if (!post) {
        post = [[TGPost alloc] initWithDictionary:data];
        if (post) { // post will be nil if the data is invalid
            [cache addObject:post];
        }
    }
    else {
        [post loadDataFromDictionary:data]; // update the existing with potentially new data
    }
    
    return post;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        // Set default visibility to connections
        self.visibility = TGVisibilityConnection;
    }
    return self;
}

- (NSArray*)attachments {
    return [NSArray arrayWithArray:self.mutableAttachemnts];
}

- (NSMutableArray*)mutableAttachemnts {
    if (!_mutableAttachemnts) {
        _mutableAttachemnts = [[NSMutableArray alloc] init];
    }
    return _mutableAttachemnts;
}

- (void)addAttachment:(TGAttachment *)attachment {
    [self.mutableAttachemnts addObject:attachment];
}


#pragma mark - JSON Parsing

- (void)loadDataFromDictionary:(NSDictionary *)data withMapping:(NSDictionary *)mapping {
    [super loadDataFromDictionary:data withMapping:mapping];
    _user = [TGUser objectWithId:[data tg_stringValueForKey:TGPostUserIdJsonKey]];
    [self loadAttachmentsFromDictionary:data];
}

- (void)loadAttachmentsFromDictionary:(NSDictionary*)data {
    _mutableAttachemnts = nil; // clear any exsting stuff
    for (NSDictionary *attachmentDict in [data valueForKey:TGPostAttachmentsJsonKey]) {
        [self addAttachment:[[TGAttachment alloc] initWithDictionary:attachmentDict]];
    }
}

- (NSDictionary*)jsonMapping {
    static NSDictionary *mapping;
    if (!mapping) {
        mapping = [self jsonMappingForReading];
    }
    return mapping;
}

- (NSDictionary*)jsonMappingForWriting {
    // left side: json attribute name , right side: model property name
    return @{
             TGPostTagsJsonKey : @"tags",
             TGPostVisibilityJsonKey : @"visibility",
             TGPostAttachmentsJsonKey : @"attachments"
             };
}

- (NSDictionary*)jsonMappingForReading {
    NSMutableDictionary *mapping = [self jsonMappingForWriting].mutableCopy;
    [mapping addEntriesFromDictionary:@{
                                        TGPostIsLikedKey : @"isLiked",
                                        @"counts.comments" : @"commentsCount",
                                        @"counts.likes" : @"likesCount",
                                        @"counts.shares" : @"sharesCount"
                                        }];
    return mapping;
}

- (NSDictionary*)jsonDictionary {
    // id on posts must be a string while all other objects use numbers
    NSMutableDictionary *jsonDictionary = [super jsonDictionary].mutableCopy;
    jsonDictionary[TGModelObjectIdJsonKey] = [jsonDictionary[TGModelObjectIdJsonKey] stringValue];
    return jsonDictionary;
}

- (void)setAttachments:(NSArray*)attachments {
    self.mutableAttachemnts = attachments.mutableCopy;
}


@end
