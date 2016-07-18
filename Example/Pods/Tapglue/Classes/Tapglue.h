//
//  Tapglue.h
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

#import <Foundation/Foundation.h>
#import "TGConstants.h"
#import "TGUser+Networking.h"
#import "TGEvent+Networking.h"
#import "TGEventObject.h"
#import "TGComment.h"
#import "TGConnection.h"
#import "TGConfiguration.h"
#import "TGQuery.h"
#import "TGSessionTokenNotifier.h"

/*!
 @abstract `Tapglue` The primary interface for integrating Tapglue with your app.
 @discussion `Tapglue` contains the main definitions to work with the Tapglue API including User Management, Connections (Friends and Follower Model), Events and Feeds.

 User Management contains creating, retrieving, updating and deleting users, as well as login and logout and user search functionality.

 Connections Methods provides ways to create follower or friends and retrieve lists of follows, followers or friends.

 Events can be created, updated and deleted for the currentUser. Users can retrieve events of other users or their own feeds.
 */
@interface Tapglue : NSObject

/*!
 @abstractGet the current version number of the iOS SDK
 */
+ (NSString *)version;

/*!
 @abstract Flush timer's interval in seconds.
 @discussion The Flush timer determines how many seconds will pass until the events in the queue will be sent.

 @warning Setting a flush interval of 0 will turn off the flush timer.
 */
@property (atomic) NSUInteger flushInterval;

/*!
 @abstract Initializes the `Tapglue` SDK with token.
 @discussion Provide a valid appToken to initialize the `Tapglue` SDK.

 @warning Make sure to use different tokens for test- and production environments.

 @param appToken The token of your app provided from the dashboard.
 */
+ (void)setUpWithAppToken:(NSString*)appToken;

/*!
 @abstract Initializes the `Tapglue` SDK with token and configuration.
 @discussion Provide a valid appToken and configuration to initialize the `Tapglue` SDK.

 @warning Make sure to use different tokens for test- and production environments.

 @param appToken The token of your app provided from the dashboard.
 @param config The configuration object to setup Tapglue.
 */
+ (void)setUpWithAppToken:(NSString *)token andConfig:(TGConfiguration*)config;

/*!
 @abstract Tapglue Singleton
 @discussion Obtain singleton tapglue object.
 */
+ (Tapglue *)sharedInstance;

#pragma mark - User Management -

#pragma mark - Current User

/*!
 @abstract Create and login user with username and password.
 @discussion This will create and login a tapglue user by providing a username and a password and create a currentUser.

 @param username The username of the user has to be unique and alphanumerical.
 @param password The password of the user will be hashed with PBKDF2 by default.
 */
+ (void)createAndLoginUserWithUsername:(NSString*)username
                           andPassword:(NSString*)password
                   withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Create and login user with email and password.
 @discussion This will create and login a tapglue user by providing an email and a password and create a currentUser.

 @param email The email of the user has to be unique and a valid email adress.
 @param password The password of the user will be hashed with PBKDF2 by default.
 */
+ (void)createAndLoginUserWithEmail:(NSString*)email
                        andPassword:(NSString*)password
                withCompletionBlock:(TGSucessCompletionBlock)completionBlock;;

/*!
 @abstract Create and login user with a TGUser object.
 @discussion This will create and login a tapglue user by providing a TGUser object and create a currentUser.

 @warning The user object needs to contain at least a username or email and password.

 @param user A TGUser object with attributes describing the user.
 */
+ (void)createAndLoginUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Login a user with username or email and password.
 @discussion This will login a user by providing a username or email adress and a password and create a currentUser.

 @param usernameOrEmail The username or email of the user.
 @param password The password of the user will be hashed with PBKDF2 by default.
 */
+ (void)loginWithUsernameOrEmail:(NSString*)usernameOrEmail
                     andPassword:(NSString*)password
             withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Login a user with username or email an unhashed password.
 @discussion This will login a user by providing a username or email adress and a password and create a currentUser.
 
 @param usernameOrEmail The username or email of the user.
 @param password The password of the user will be plain text without any hashing.
 */
+ (void)loginWithUsernameOrEmail:(NSString*)usernameOrEmail
                     andUnhashedPassword:(NSString*)password
             withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the currentUser.
 @discussion This will retrieve the details for the currentUser and overwrite currentUser.
 */
+ (void)retrieveCurrentUserWithCompletionBlock:(TGGetUserCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the currentUser.
 @discussion This will retrieve the details for the currentUser and overwrite currentUser.
 */
+ (void)logoutWithCompletionBlock:(TGSucessCompletionBlock)completionBlock;

#pragma mark - session token notifier

+ (void)setSessionTokenNotifier:(id<TGSessionTokenNotifier>)notifier;

#pragma mark   Other Users

/*!
 @abstract Retrieve user details of any user.
 @discussion This will retrieve the details for any user with the provided userId.

 @param userId The userId of the user for which the details should be fetched.
 */
+ (void)retrieveUserWithId:(NSString*)userId withCompletionBlock:(TGGetUserCompletionBlock)completionBlock;

#pragma mark Search

/*!
 @abstract Search other users.
 @discussion This will retrieve the details of the users for a given search term.

 @param term The term for which users should be searched.
 */
+ (void)searchUsersWithTerm:(NSString*)term andCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;

/*!
 @abstract Search multiple users with emails.
 @discussion This will retrieve the details of the users for a set of email adresses.
 
 @param emails The emails of the users that are being searched.
 */
+ (void)searchUsersWithEmails:(NSArray*)emails andCompletionBlock:(TGGetUserListCompletionBlock)completionBlock;

/*!
 @abstract Search multiple users with socialIds.
 @discussion This will retrieve the details of the users for a set of socialIds.
 
 @param socialPlatform The name of the social platform.
 @param socialUserIds The socialIds of the users that are being searched.
 */
+ (void)searchUsersOnSocialPlatform:(NSString*)socialPlatform
                 withSocialUsersIds:(NSArray*)socialUserIds
                 andCompletionBlock:(TGGetUserListCompletionBlock)completionBlock;

#pragma mark - Connections

/*!
 @abstract Follow a user.
 @discussion This will create a follow connection to another user.

 @param user The user object which the currentUser wants to follow.
 */
+ (void)followUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Follow a user.
 @discussion This will create a follow connection to another user.
 
 @param user The user object which the currentUser wants to follow.
 @param createEvent Whether an event to appear for the associated user's feed should be created for the new collection.
 @param state Specifies the connection state of the follow (pending, confirmed, rejected).
 */
+ (void)followUser:(TGUser*)user withState:(TGConnectionState)state withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Unfollow a user.
 @discussion This will remove a previously created follow connection to another user.

 @param user The user object which the currentUser wants to unfollow.
 */
+ (void)unfollowUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Become friend with a user.
 @discussion This will create a friend connection to another user.

 @param user The user object which the currentUser wants to become friend with.
 */
+ (void)friendUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock;


/*!
 @abstract Become friend with a user.
 @discussion This will create a friend connection to another user.
 
 @param user The user object which the currentUser wants to become friend with.
 @param createEvent Whether an event to appear for the associated user's feed should be created for the new collection.
 @param state Specifies the connection state of the friend (pending, confirmed, rejected).
 */
+ (void)friendUser:(TGUser*)user withState:(TGConnectionState)state withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Unfriend a user.
 @discussion This will remove the previously created friend connection to another user.

 @param user The user object which the currentUser wants to unfriend.
 */
+ (void)unfriendUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve list of users that are followed.
 @discussion This will retrieve a list of users that the currentUser is following.
 */
+ (void)retrieveFollowsForCurrentUserWithCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;

/*!
 @abstract Retrieve list of followers for currentUser.
 @discussion This will retrieve a list of users that are following the currentUser.
 */
+ (void)retrieveFollowersForCurrentUserWithCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;

/*!
 @abstract Retrieve list of friends.
 @discussion This will retrieve a list of users that are friends with the currentUser.
 */
+ (void)retrieveFriendsForCurrentUserWithCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;
// TODO: cache for current user connections


/*!
 @abstract Retrieve list of pending connections.
 @discussion This will retrieve a list of users that have a pending connection with the currentUser.
 */
+ (void)retrievePendingConncetionsForCurrentUserWithCompletionBlock:(void (^)(NSArray *incoming, NSArray *outgoing, NSError *error))completionBlock;

/*!
 @abstract Retrieve list of rejected connections.
 @discussion This will retrieve a list of users that have a rejected connection with the currentUser.
 */
+ (void)retrieveRejectedConncetionsForCurrentUserWithCompletionBlock:(void (^)(NSArray *incoming, NSArray *outgoing, NSError *error))completionBlock;

/*!
 @abstract Retrieve list of confirmed connections.
 @discussion This will retrieve a list of users that have a confirmed connection with the currentUser.
 */
+ (void)retrieveConfirmedConncetionsForCurrentUserWithCompletionBlock:(void (^)(NSArray *incoming, NSArray *outgoing, NSError *error))completionBlock;

#pragma mark -

/*!
 @abstract Retrieve list of users that are followed by any user.
 @discussion This will retrieve a list of users that any user is following.
 */
+ (void)retrieveFollowsForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;

/*!
 @abstract Retrieve list of followers for any user.
 @discussion This will retrieve a list of users that are following any user.
 */
+ (void)retrieveFollowersForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;

/*!
 @abstract Retrieve list of friends for any user.
 @discussion This will retrieve a list of users that are friends with any user.
 */
+ (void)retrieveFriendsForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;

/*!
 @abstract Create multiple follow connections from another source.
 @discussion This will create multiple follow connections from a given source such as Twitter.

 @param toSocialUsersIds List of socialIds the user follows.
 @param socialIdKey The socialId of the user who is creating the connections.
 */
+ (void)followUsersWithSocialsIds:(NSArray*)toSocialUsersIds
        onPlatformWithSocialIdKey:(NSString*)socialIdKey
              withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Create multiple friend connections from another source.
 @discussion This will create multiple friend connections from a given source such as Facebook.

 @param toSocialUsersIds List of socialIds the user is friend with.
 @param socialIdKey The socialId of the user who is creating the connections.
 */
+ (void)friendUsersWithSocialsIds:(NSArray*)toSocialUsersIds
                  onPlatformWithSocialIdKey:(NSString*)socialIdKey
                        withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

#pragma mark - Events

/*!
 @abstract Create an event with a type on an object.
 @discussion This will create an event with a given type on a certain object.

 @param type Type of the event that was performed (i.e. like).
 @param object An object the event was performed on.

 @return The event object that was created.
 */
+ (TGEvent*)createEventWithType:(NSString*)type onObject:(TGEventObject*)object;

/*!
 @abstract Create an event with a type on an objectId.
 @discussion This will create an event with a given type on a certain objectId.

 @param type Type of the event that was performed (i.e. like).
 @param objectId An objectId the event was performed on.

 @return The event object that was created.
 */
+ (TGEvent*)createEventWithType:(NSString*)type onObjectWithId:(NSString*)objectId;

/*!
 @abstract Create an event with an event object.
 @discussion This will create an event with a given event object.

 @param event The event object that contains the parameter.
 */
+ (void)createEvent:(TGEvent*)event;

/*!
 @abstract Delete a previously created event.
 @discussion This will delete an event that was previously created.

 @param event The event object that should be deleted.
 */
+ (void)deleteEvent:(TGEvent*)event;

/*!
 @abstract Delete an event with type and objectId.
 @discussion This will delete an event with a provided type and objectId.

 @param type The type of the event.
 @param objectId The objectId of the event.
 */
+ (void)deleteEventWithType:(NSString*)type onObjectWithId:(NSString*)objectId; // #1

/*!
 @abstract Delete an event with type and object.
 @discussion This will delete an event with a provided type and object.

 @param type The type of the event.
 @param object The object asociated with the event.
 */
+ (void)deleteEventWithType:(NSString*)type onObject:(TGEventObject*)object;  // overloading  #1


/*!
 @abstract Retrieve a single event for a user.
 @discussion This will retrieve a single event of an user.

 @param userId The id of the user who performed the event.
 @param eventId The id of the event.
 */
+ (void)retrieveEventForUserWithId:(NSString*)userId
                        andEventId:(NSString*)eventId
               withCompletionBlock:(TGGetEventCompletionBlock)completionBlock;

/*!
 @abstract Retrieve a single event for currentUser.
 @discussion This will retrieve a single event of currentUser.

 @param eventId The id of the event.
 */
+ (void)retrieveEventForCurrentUserWithId:(NSString*)eventId withCompletionBlock:(TGGetEventCompletionBlock)completionBlock;

/*!
 @abstract Retrieve all available events of any user.
 @discussion This will retrieve a all available events of any user.
 */
+ (void)retrieveEventsForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock;

/*!
 @abstract Retrieve all events of currentUser.
 @discussion This will retrieve a all events of the currentUser.
 */
+ (void)retrieveEventsForCurrentUserWithCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock;

#pragma mark - User Recommendations

/*!
 @abstract Retrieve user recommendations.
 @discussion This will retrieve recommended users for the current user.
 
 @param type The type of the user recommendation (latest, trending, active, random).
 @param period The period the user recommendations are fetched for.
 */
+ (void)retrieveUserRecommendationsOfType:(NSString*)type forPeriod:(NSString*)period andCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;

/*!
 @abstract Retrieve user recommendations.
 @discussion This will retrieve recommended active users for the current user for a period day.
 */
+ (void)retrieveUserRecommendationsWithCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock;
 
#pragma mark - Feeds

/*!
 @abstract Retrieve events feed for the currentUser.
 @discussion This will retrieve the events feed for the currentUser.
 */
+ (void)retrieveEventsFeedForCurrentUserWithCompletionBlock:(TGFeedCompletionBlock)completionBlock;

/*!
 @abstract Retrieve news feed for the currentUser.
 @discussion This will retrieve the news feed for the currentUser.
 */
+ (void)retrieveNewsFeedForCurrentUserWithCompletionBlock:(TGGetNewsFeedCompletionBlock)completionBlock;

/*!
 @abstract Retrieve unread events of news feed for the currentUser.
 @discussion This will retrieve the unread events of the news feed for the currentUser.
 */
+ (void)retrieveUnreadNewsFeedForCurrentUserWithCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock;

/*!
 @abstract Retrieve unread events count of news feed for the currentUser.
 @discussion This will retrieve the unread events count of the news feed for the currentUser.
 */
+ (void)retrieveUnreadCountForCurrentWithCompletionBlock:(void (^)(NSInteger unreadCount, NSError *error))completionBlock;

+ (NSArray*)cachedEventsFeedForCurrentUser;
+ (NSArray*)cachedUnreadEventsFeedForCurrentUser;
+ (NSInteger)cachedUnreadEventsCountForCurrentUser;

#pragma mark - Queries -

#pragma mark All Events Queries

/*!
 @abstract Retrieve all events of a type.
 @discussion This will retrieve all events of a type.
 */
+ (void)retrieveEventsOfType:(NSString*)eventType withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve all events of an object with id.
 @discussion This will retrieve all events of an object with an id.
 */
+ (void)retrieveEventsForObjectId:(NSString*)objectId withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve all events of an object with id and type.
 @discussion This will retrieve all events of an object with an id and type.
 */
+ (void)retrieveEventsForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve events for a set of event types.
 @discussion This will all events for a set of event types.
 */
+ (void)retrieveEventsForEventTypes:(NSArray*)types withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve all events that match a query.
 @discussion This will retrieve all events matching the query object.
 */
+ (void)retrieveEventsWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

#pragma mark currentUser Events Queries

/*!
 @abstract Retrieve current user events of a type.
 @discussion This will retrieve current user events of a type.
 */
+ (void)retrieveEventsForCurrentUserOfType:(NSString*)eventType withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve current user of an object with id.
 @discussion This will retrieve current user events of an object with an id.
 */
+ (void)retrieveEventsForCurrentUserForObjectId:(NSString*)objectId withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve current user events of an object with id and type.
 @discussion This will retrieve current user events of an object with an id and type.
 */
+ (void)retrieveEventsForCurrentUserForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve currentUser events for a set of event types.
 @discussion This will retrieve currentUser events for a set of event types.
 */
+ (void)retrieveEventsForCurrentUserForEventTypes:(NSArray*)types withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve current user events that match a query.
 @discussion This will retrieve current user events matching the query object.
 */
+ (void)retrieveEventsForCurrentUserWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

#pragma mark Events Feed Queries

/*!
 @abstract Retrieve feed events of a type.
 @discussion This will retrieve feed events of a type.
 */
+ (void)retrieveEventsFeedForCurrentUserOfType:(NSString*)eventType withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve feed events of an object with id.
 @discussion This will retrieve feed events of an object with an id.
 */
+ (void)retrieveEventsFeedForCurrentUserForObjectId:(NSString*)objectId withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve feed events of an object with id and type.
 @discussion This will retrieve feed events of an object with an id and type.
 */
+ (void)retrieveEventsFeedForCurrentUserForObjectWithId:(NSString*)objectId andEventType:(NSString*)eventType withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve events feed for a set of event types.
 @discussion This will retrieve a events feed for a set of event types.
 */
+ (void)retrieveEventsFeedForCurrentUserForEventTypes:(NSArray*)types withCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve feed events that match a query.
 @discussion This will retrieve feed events matching the query object.
 */
+ (void)retrieveEventsFeedForCurrentUserWithQuery:(TGQuery*)query andCompletionBlock:(TGGetEventListCompletionBlock)completionBlock;

#pragma mark News Feed Queries

/*!
 @abstract Retrieve news feed that match a query.
 @discussion This will retrieve a news feed  matching the query object.
 */
+ (void)retrieveNewsFeedForCurrentUserWithQuery:(TGQuery*)query andCompletionBlock:(TGGetNewsFeedCompletionBlock)completionBlock;

/*!
 @abstract Retrieve news feed for a set of event types.
 @discussion This will retrieve a news feed for a set of event types.
 */
+ (void)retrieveNewsFeedForCurrentUserForEventTypes:(NSArray*)types withCompletionBlock:(TGGetNewsFeedCompletionBlock)completionBlock;

#pragma mark Comments

/*!
 @abstract Creates a comment on a custom objectId.
 @discussion This will create a comment on an objectId.
 
 @param comment The content of the comment.
 @param post The Post object that is being commented.
 */
+ (TGComment*)createComment:(NSDictionary*)comment
                                   forObjectWithId:(NSString*)objectId
                       withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Updates a comment on an objectId.
 @discussion This will update a comment on a objectId.
 
 @param comment The comment object that is being updated.
 */
+ (void)updateComment:(TGComment*)comment forObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Deletes a comment for an objectId.
 @discussion This will delete a comment for an objectId.
 
 @param objectId The objectId for which a comment is being deleted.
 */
+ (void)deleteComment:(TGComment*)comment forObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve comments for an objectId.
 @discussion This will retrieve all comments for an objectId.
 
 @param objectId The objectId for which comments are retrieved.
 */
+ (void)retrieveCommentsForObjectWithId:(NSString*)objectId
                  withCompletionBlock:(void (^)(NSArray *comments, NSError *error))completionBlock;

#pragma mark Likes

/*!
 @abstract Create a like for an objectId.
 @discussion This will create a like for an objectId.
 
 @param objectId The objectId for which a like is being created.
 */
+ (void)createLikeForObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Deletes a like for an objectId.
 @discussion This will delete a like for an objectId.
 
 @param objectId The objectId for which a like is being deleted.
 */
+ (void)deleteLikeForObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve likes for an objectId.
 @discussion This will retrieve all likes for a objectId.
 
 @param objectI The objectId for which likes are retrieved.
 */
+ (void)retrieveLikesForObjectWithId:(NSString*)objectId
               withCompletionBlock:(void (^)(NSArray *likes, NSError *error))completionBlock;

#pragma mark - Raw Rest -

/*!
 @abstract Create a generic HTTP request.
 @discussion This will create a generic HTTP Request.
 */
+ (NSURLSessionDataTask*) makeRestRequestWithHTTPMethod:(NSString*)method
                                             atEndPoint:(NSString*)endPoint
                                      withURLParameters:(NSDictionary*)urlParams
                                             andPayload:(NSDictionary*)bodyObject
                                     andCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock;

@end

// must to be imported after the interface definition
#import "Tapglue+Posts.h"
