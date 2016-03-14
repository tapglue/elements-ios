//
//  TGEventManager.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 04/06/15.
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
#import "TGBaseManager.h"
#import "Tapglue.h"

@class TGUser, TGEvent, TGApiClient;

/*!
 @abstract The event manager handles all user interactions.
 @discussion This will handle all event interactions in the app.
 */
@interface TGEventManager : TGBaseManager

/*!
 @abstract The api endpoint for all events.
 */
extern NSString *const TGEventManagerAPIEndpointEvents;

/*!
 @abstract The cached event feed.
 @discussion This will contain all events of the cached feed.
 */
@property (nonatomic, strong, readonly) NSArray *cachedFeed;

/*!
 @abstract The cached feed for unread events.
 @discussion This will contain all unread events of the feed.
 */
@property (nonatomic, strong, readonly) NSArray *cachedUnreadFeed;

/*!
 @abstract The count of unread events.
 @discussion This will contain the unread count of the feed.
 */
@property (nonatomic, assign, readonly) NSInteger unreadCount;

/*!
 @abstract Archive the queue.
 @discussion This will archive the current queue.
 */
- (void)archive;

/*!
 @abstract Unarchive the queue.
 @discussion This will unarchive the current queue.
 */
- (void)unarchive;

/*!
 @abstract Flush the queue.
 @discussion This will try to perform the requests and flush the queue.
 */
- (void)flush;

/*!
 @abstract Add event to queue.
 @discussion This will add an event to the queue.
 */
- (void)addEvent:(TGEvent*)event;

/*!
 @abstract Delete event to queue.
 @discussion This will delete an event from the queue.
 */
- (void)deleteEvent:(TGEvent*)event;

#pragma mark - direct API calls

/*!
 @abstract Reset the internal cachend.
 @discussion Reset the cached feed, the unread count as well as resetting and archiving the queues.
 */
- (void)resetCaches;

/*!
 @abstract Create an event.
 @discussion This will create an event for a user.

 @param event The TGEvent object that contains the event information.
 */
- (void)createEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Update an event.
 @discussion This will update an event for a user.

 @param event The TGEvent object that contains the event information.
 */
- (void)updateEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Delete an event.
 @discussion This will delete an event for a given id.

 @param event The TGEvent object that contains the event information.
 */
- (void)deleteEventWithId:(NSString*)eventId withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve an event.
 @discussion This will retrieve an event for a given event and user id.

 @param eventId The event id of the event that should be fetched.
 @param userId The user id of user who performed the event.
 */
- (void)retrieveEventWithId:(NSString*)eventId
              forUserWithID:(NSString*)userId
                   withCompletionBlock:(TGGetEventCompletionBlock)completionBlock;

/*!
 @abstract Retrieve an event for currentUser.
 @discussion This will retrieve an event for a given eventId.

 @param eventId The event id of the event that should be fetched.
 */
- (void)retrieveEventForCurrentUserWithEventId:(NSString*)eventId withCompletionBlock:(TGGetEventCompletionBlock)completionBlock;

/*!
 @abstract Retrieve all events for currentUser.
 @discussion This will retrieve the events for the currentUser.
 */
- (void)retrieveEventsForCurrentUserWithCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock;

/*!
 @abstract Retrieve all events for any user.
 @discussion This will retrieve the events for any user.

 @param user The user object for which the events should be retrieved.
 */
- (void)retrieveEventsForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock;

/*!
 @abstract Retrieve the events feed of the currentUser.
 @discussion This will retrieve events feed of the currentUser.
 */
- (void)retrieveEventsFeedForCurrentUserOnlyUnread:(BOOL)onlyUnread
                         withCompletionBlock:(TGFeedCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the news feed of the currentUser.
 @discussion This will retrieve news feed of the currentUser.
 */
- (void)retrieveNewsFeedForCurrentUserOnlyUnread:(BOOL)onlyUnread
                               withCompletionBlock:(TGGetNewsFeedCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the unread count for the feed of the currentUser.
 @discussion This will retrieve the unread count for the feed of the currentUser.
 */
- (void)retrieveFeedUnreadCountForCurrentWithCompletionBlock:(void (^)(NSInteger, NSError *))completionBlock;

#pragma mark - Comments -

/*!
 @abstract Creates a comment on a custom object.
 @discussion This will create a comment on a custom object.
 */
- (TGComment*)createComment:(NSString*)comment forObjectWithId:objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Updates a comment on an objectId.
 @discussion This will update a comment on an objectId.
 
 @param comment The comment object that is being updated.
 */
- (void)updateComment:(TGComment*)comment forObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Deletes a comment on a custom object.
 @discussion This will delete a comment on a custom object.
 */
- (void)deleteComment:(TGComment*)comment forObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve all comment on an objectId.
 @discussion This will retrieve all comments on an objectId.
 */
- (void)retrieveCommentsForObjectWithId:objectId withCompletionBlock:(void (^)(NSArray *comments, NSError *error))completionBlock;

#pragma mark - Likes -

/*!
 @abstract Create a like event on a custom object.
 @discussion This will create a like event on a custom object.
 */
- (void)createLikeForObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Delete a like event on a custom object.
 @discussion This will delete a like event on a custom object.
 */
- (void)deleteLikeForObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieves like events on a custom object.
 @discussion This will retrieve like events on a custom object.
 */
- (void)retrieveLikesForObjectWithId:(NSString*)objectId andCompletionBlock:(void (^)(NSArray *Likes, NSError *error))completionBlock;

@end
