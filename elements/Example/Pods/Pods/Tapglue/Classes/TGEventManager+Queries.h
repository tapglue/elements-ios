//
//  TGEventManager+Queries.h
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

#import "TGEventManager.h"

@interface TGEventManager (Queries)

/*!
 @abstract Retrieve all events that match a query.
 @discussion This will retrieve all events matching the query object.
 
 @param query Object that describes the query.
 */
- (void)retrieveEventsWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve current user events that match a query.
 @discussion This will retrieve current user events matching the query object.
 
 @param query Object that describes the query.
 */
- (void)retrieveEventsForCurrentUserWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve feed events that match a query.
 @discussion This will retrieve feed events matching the query object.
 
 @param query Object that describes the query.
 */
- (void)retrieveEventsFeedForCurrentUserWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve news feed that match a query.
 @discussion This will retrieve news feed matching the query object.
 
 @param query Object that describes the query.
 */
- (void)retrieveNewsFeedForCurrentUserWithQuery:(TGQuery*)query andCompletionBlock:(TGGetNewsFeedCompletionBlock)completionBlock;

/*!
 @abstract Compose a query for an eventType and an objectId.
 @discussion This compose a query for an eventType and an objectId.
 
 @param eventType Type of the event.
 @param objectId Id of the object.
 */
- (TGQuery*)composeQueryForEventType:(NSString*)eventType andObjectWithId:(NSString*)objectId;

/*!
 @abstract Compose a query for a set of event types.
 @discussion This compose a query for a set of event types.
 
 @param types A set of event types.
 */
- (TGQuery*)composeQueryForEventTypes:(NSArray*)types;
    
@end
