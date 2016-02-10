//
//  TGModelObject+Private.h
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

#import "TGModelObject.h"
#import "TGObject+Private.h"

/*!
 @abstract JSON Key for the metadata object.
 @constant TGModelObjectMetadataJsonKey The JSON Key for the metadata object.
 */
extern NSString *const TGModelObjectMetadataJsonKey;

/*!
 @abstract JSON Key for createdAt.
 @constant TGModelObjectCreatedAtJsonKey The JSON Key for the createdAt object.
 */
extern NSString *const TGModelObjectCreatedAtJsonKey;

/*!
 @abstract JSON Key for updatedAt.
 @constant TGModelObjectUpdatedAtJsonKey The JSON Key for the updatedAt object.
 */
extern NSString *const TGModelObjectUpdatedAtJsonKey;

@class TGObjectCache;

/*!
 @abstract The Model Object.
 @discussion The Model Object contains commonly used fields of the objects.
 */
@interface TGModelObject (Private)

/*!
 @abstract The object cache.
 @discussion The object cache will contain items have been cached in previous sessions.

 @return The object cache will be returned.
 */
+ (TGObjectCache*)cache;

/*!
 @abstract Create user or load into cache.
 @discussion This will retrieve a cached user. If the user is not cached yet, it will be created and added to the cache.

 @param userData The JSONDictionary from the Tapglue API.

 @return This will return a user.
 */
+ (instancetype)createOrLoadWithDictionary:(NSDictionary*)userData;

/*!
 @abstract Retrieve a user from cache.

 @param objectId The id of the user.

 @return Returns a user or nil if non-existing.
 */
+ (instancetype)objectWithId:(NSString*)objectId;

/*!
 @abstract Batch create users from dictionary.

 @return This will return a list of users.
 */
+ (NSArray*)createAndCacheObjectsFromDictionaries:(NSArray*)dictionaries;

@end
