//
//  TGModelObject.m
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

#import "TGModelObject+Private.h"
#import "NSDateFormatter+TGISOFormatter.h"
#import "TGObjectCache.h"

NSString *const TGModelObjectMetadataJsonKey = @"metadata";
NSString *const TGModelObjectCreatedAtJsonKey = @"created_at";
NSString *const TGModelObjectUpdatedAtJsonKey = @"updated_at";


@implementation TGModelObject

+ (TGObjectCache*)cache {
    return [TGObjectCache cacheForClass:self];
}

+ (instancetype)createOrLoadWithDictionary:(NSDictionary*)data {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

+ (instancetype)objectWithId:(NSString*)objectId {
    return [[self cache] objectWithObjectId:objectId];
}

+ (NSArray*)createAndCacheObjectsFromDictionaries:(NSArray*)dictionaries {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:dictionaries.count];
    for (NSDictionary *objectDict in dictionaries) {
        TGModelObject *object = [self createOrLoadWithDictionary:objectDict];
        [objects addObject:object];
    }
    return objects;
}

- (void)loadDataFromDictionary:(NSDictionary *)data withMapping:(NSDictionary *)mapping {
    [super loadDataFromDictionary:data withMapping:mapping];
    NSDateFormatter *formatter = [NSDateFormatter tg_isoDateFormatter];
    _createdAt = [formatter dateFromString:[data valueForKey:TGModelObjectCreatedAtJsonKey]];
    _updatedAt = [formatter dateFromString:[data valueForKey:TGModelObjectUpdatedAtJsonKey]];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _createdAt = [NSDate date];
    }
    return self;
}

@end
