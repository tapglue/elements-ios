//
//  TGObjectCache.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 03/06/15.
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

#import "TGObjectCache.h"
#import "TGModelObject.h"

@interface TGObjectCache ()
@property (nonatomic) NSMutableDictionary *cachedObjects;
@end

@implementation TGObjectCache

static NSMutableDictionary *_objectCaches = nil;

+ (instancetype)cacheForClass:(Class)modelClass {
    NSAssert([modelClass isSubclassOfClass:[TGModelObject class]], @"modelClass must be a subclass of %@", NSStringFromClass([TGModelObject class]));
    if (!_objectCaches) {
        _objectCaches = [NSMutableDictionary dictionary];
    }

    NSString *keyForClass = NSStringFromClass(modelClass);
    TGObjectCache* cache = [_objectCaches objectForKey:keyForClass];
    if (!cache) {
        cache = [[TGObjectCache alloc] init];
        [_objectCaches setObject:cache forKey:keyForClass];
    }
    return cache;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cachedObjects = [NSMutableDictionary new];
    }
    return self;
}

- (id)objectWithObjectId:(NSString *)objectId {
    return [self.cachedObjects objectForKey:objectId];
}

- (BOOL)hasObjectWithObjectId:(NSString *)objectId {
    return [[self.cachedObjects allKeys] containsObject:objectId];
}

- (TGModelObject*)findFirstMatchingPredicate:(NSPredicate*)predicate {
    return [self.cachedObjects.allValues filteredArrayUsingPredicate:predicate].firstObject;
}

- (void)addObject:(TGModelObject *)object {
    if (![self hasObjectWithObjectId:object.objectId]) {
        [self replaceObject:object];
    }
}

- (void)replaceObject:(TGModelObject *)object{
    [self.cachedObjects setObject:object forKey:object.objectId];
}

- (void)clearCache {
    [self.cachedObjects removeAllObjects];
}

+ (void)clearAllCaches {
    for (TGObjectCache *cache in [_objectCaches allValues]) {
        [cache clearCache];
    }
}

@end
