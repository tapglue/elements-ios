//
//  TGObjectCache.h
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

#import <Foundation/Foundation.h>

@class TGModelObject;

/*!
 @abstract The cache of objects.
 @discussion `TGObjectCache` contains previously cached objects.
 */
@interface TGObjectCache : NSObject

+ (instancetype)cacheForClass:(Class)modelClass;

/*!
 @abstract Returns an object for an id.

 @param objectId The id of the object.

 @return Returns object with the id.
 */
- (id)objectWithObjectId:(NSString *)objectId;

/*!
 @abstract Checks if object is cached.
 @discussion This will check if an object is already available in the cache.

 @param objectId The id of the object that is being checked.

 @return Returns true if the object is cached, false otherwise.
 */
- (BOOL)hasObjectWithObjectId:(NSString *)objectId;

/*!
 @abstract Finds the first matching predicate.
 @discussion This will find and return the first matching predicate.

 @param predicate The predicate that is being searched.

 @return A TGModelObject for a given predicate will be returned.
 */
- (TGModelObject*)findFirstMatchingPredicate:(NSPredicate*)predicate;


/*!
 @abstract Adds an object to the cache.
 @discussion This will add an object and cache it.

 @param object The object that you want to cache.
 */
- (void)addObject:(TGModelObject *)object;

/*!
 @abstract Replaces an object in the cache.
 @discussion This will replace an object in the cache.

 @param object The object that you want to replace.
 */
- (void)replaceObject:(TGModelObject *)object;

/*!
 @abstract Clear the cache.
 @discussion This will clear the cache.
 */
- (void)clearCache;

/*!
 @abstract Clear alles caches.
 @discussion This will clear all available caches.
 */
+ (void)clearAllCaches;

@end
