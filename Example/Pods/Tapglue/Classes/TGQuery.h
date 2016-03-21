//
//  TGQueryBuilder.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 07/12/15.
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

@interface TGQuery : NSObject

#pragma mark - ObjectID
/*!
 @abstract Adds an Tapglue objectId to the query.
 @discussion This will add an Tapglue objectId to the query.
 
 @param objectId The ID of an Tapglue object
 */
- (void)addObjectIdEquals:(NSString*)objectId;

/*!
 @abstract Adds multiple Tapglue objectIds to the query.
 @discussion This will add multiple Tapglue objectIds to the query.
 
 @param objectIds Array of Tapglue objectIds
 */
- (void)addObjectIdIn:(NSArray*)objectIds;

#pragma mark - Type
/*!
 @abstract Adds an event type to the query.
 @discussion This will add an event type to the query.
 
 @param type The event type
 */
- (void)addTypeEquals:(NSString*)type;

/*!
 @abstract Adds multiple event types to the query.
 @discussion This will multiple event types to the query.
 
 @param types Array of event type
 */
- (void)addTypeIn:(NSArray*)types;

#pragma mark - Object.ID
/*!
 @abstract Adds an event objectId to the query.
 @discussion This will add an event objectId to the query.
 
 @param objectId The ID of an Tapglue object
 */
- (void)addEventObjectWithIdEquals:(NSString*)objectId;

/*!
 @abstract Adds multiple event objectIds to the query.
 @discussion This will add multiple event objectIds to the query.
 
 @param objectIds Array of event objectIds
 */
- (void)addEventObjectWithIdIn:(NSArray*)objectIds;

@end
