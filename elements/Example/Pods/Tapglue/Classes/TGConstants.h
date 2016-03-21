//
//  TGConstants.h
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

#pragma mark - Enums 

/*!
 @typedef Defines the visibibly of events and posts for other users.
 @constant TGVisibilityPrivate makes the event visible only for the currentUser.
 @constant TGVisibilityConnection makes the event visible for friends and followers.
 @constant TGVisibilityPublic makes the event visible for everyone.
 */

typedef NS_ENUM(NSInteger, TGVisibility) {
    TGVisibilityPrivate = 10,
    TGVisibilityConnection = 20,
    TGVisibilityPublic = 30
};

#pragma mark - Social Platform Keys

/*!
 @abstract Defines the Social Platform Key for Facebook.
 @constant TGPlatformKeyFacebook holds the key for the social platform Facebook.
 */
static NSString *const TGPlatformKeyFacebook = @"facebook";

/*!
 @abstract Defines the Social Platform Key for Twitter.
 @constant TGPlatformKeyFacebook holds the key for the social platform Twitter.
 */
static NSString *const TGPlatformKeyTwitter = @"twitter";

/*!
 @abstract Defines the Social Platform Key for Google.
 @constant TGPlatformKeyFacebook holds the key for the social platform Google.
 */
static NSString *const TGPlatformKeyGoogle = @"google";

/*!
 @abstract Defines the Social Platform Key for a custom platform.
 @constant TGPlatformKeyFacebook holds the key for a custom platform.
 */
static NSString *const TGPlatformKeyCustom = @"custom";

#pragma mark - Recommendation Types

/*!
 @abstract Defines the Type of the Active User Recommendation.
 @constant TGUserRecommendationsTypeActive holds the key for recommending active users.
 */
static NSString *const TGUserRecommendationsTypeActive = @"active";

#pragma mark - Recommendation periods

/*!
 @abstract Defines the Period of the User Recommendation for a day.
 @constant TGUserRecommendationsPeriodDay holds the key for user recommendations for a day.
 */
static NSString *const TGUserRecommendationsPeriodDay = @"day";

/*!
 @abstract Defines the Period of the User Recommendation for a week.
 @constant TGUserRecommendationsPeriodWeek holds the key for user recommendations for a week.
 */
static NSString *const TGUserRecommendationsPeriodWeek = @"week";

/*!
 @abstract Defines the Type of the Active User Recommendation.
 @constant TGUserRecommendationsPeriodMonth holds the key for user recommendations for a month.
 */
static NSString *const TGUserRecommendationsPeriodMonth = @"month";

#pragma mark - Errors

/*!
 @abstract Defines the Tapglue error domain.
 @constant TGErrorDomain holds the Tapglue error domain.
 */
static NSString *const TGErrorDomain = @"TapglueErrorDomain";

/*!
 @typedef Tapglue Errors
 @abstract `TGErrorCode` enum contains all custom error codes.
 @discussion `TGErrorCode` enum contains all custom error codes that are used as `code` for `NSError` for callbacks on all classes. These codes are used when `domain` of `NSError` that you receive is set to `TGErrorDomain`.
 */
typedef NS_ENUM(NSInteger, TGErrorCode) {

    // Client Errors

    /*!
     @abstract An unknown error happened.
     */
    kTGErrorUnknownError = 100,

    /*!
     @abstract An error if multiple errors occured during the request.
     */
    kTGErrorMultipleErrors = 101,

    /*!
     @abstract This error occuers when trying to save or delete resources without permission.
     @discussion E.g. when attempting to save or delelete other users or other users' events.
     */
    kTGErrorNoPermission = 102,

    /*!
     @abstract The current user has no social id set for the given plattform.
     */
    kTGErrorNoSocialIdForPlattform = 103,

    /*!
     @abstract Occures whenever any precodition are to fulfilled.
     */
    kTGErrorInconsistentData = 104,

    // Custom Server Errors

    // Application user errors

    /*!
     @abstract User has not been activated yet.
     */
    kTGErrorUserNotActivated          = 1000,
    /*!
     @abstract User wasn't found.
     */
    kTGErrorUserNotFound              = 1001,
    /*!
     @abstract Email address already exists.
     */
    kTGErrorUserEmailAlreadyExists    = 1002,
    /*!
     @abstract Email address is invalid.
     */
    kTGErrorUserEmailInvalid          = 1003,
    /*!
     @abstract Size of the first name is invalid.
     */
    kTGErrorUserFirstNameSize         = 1004,
    /*!
     @abstract UserId is invalid.
     */
    kTGErrorUserIDInvalid             = 1005,
    /*!
     @abstract Size of the last name is invalid.
     */
    kTGErrorUserLastNameSize          = 1006,
    /*!
     @abstract Username and Email are empty.
     */
    kTGErrorUsernameAndEmailAreEmpty  = 1007,
    /*!
     @abstract Username is already in use.
     */
    kTGErrorUserUsernameInUse         = 1008,
    /*!
     @abstract Search minimum 3 characters.
     */
    kTGErrorUserSearchTypeMin3Chars   = 1009,
    /*!
     @abstract User URL is invalid.
     */
    kTGErrorUserURLInvalid            = 1010,
    /*!
     @abstract That username already exists.
     */
    kTGErrorUserUsernameAlreadyExists = 1011,
    /*!
     @abstract Size of the username is invalid.
     */
    kTGErrorUserUsernameSize          = 1012,

    // Internal application user errors

    /*!
     @abstract Internal error while creating the user.
     */
    kTGErrorInternalApplicationUserCreation        = 1500,
    /*!
     @abstract Internal error while retrieving the user.
     */
    kTGErrorInternalApplicationUserRead            = 1502,
    /*!
     @abstract Internal error while creating the user session.
     */
    kTGErrorInternalApplicationUserSessionCreation = 1503,
    /*!
     @abstract Internal error while deleting the user session.
     */
    kTGErrorInternalApplicationUserSessionDelete   = 1504,
    /*!
     @abstract Internal error while updating the user.
     */
    kTGErrorInternalApplicationUserUpdate          = 1508,

    // Connection errors

    /*!
     @abstract Connection already exists.
     */
    kTGErrorConnectionAlreadyExists      = 2000,

    /*!
     @abstract Connection was not found.
     */
    kTGErrorConnectionNotFound           = 2001,

    /*!
     @abstract Type of connection is wrong.
     */
    kTGErrorConnectionTypeIsWrong        = 2002,
    /*!
     @abstract User is connecting to itself.
     */
    kTGErrorConnectionSelfConnectingUser = 2003,
    /*!
     @abstract User is not connected.
     */
    kTGErrorConnectionUsersNotConnected  = 2004,

    // Internal connection errors

    /*!
     @abstract Internal error while connecting the user.
     */
    kTGErrorInternalConnectingUsers    = 2500,
    /*!
     @abstract Internal error while creating a connection.
     */
    kTGErrorInternalConnectionCreation = 2501,
    /*!
     @abstract Internal error while retrieving a connection.
     */
    kTGErrorInternalConnectionRead     = 2502,
    /*!
     @abstract Internal error while updating a connection.
     */
    kTGErrorInternalConnectionUpdate   = 2503,

    // Event errors

    /*!
     @abstract EventId is invalid.
     */
    kTGErrorEventIDInvalid                  = 3002,
    /*!
     @abstract EventId is already set.
     */
    kTGErrorEventIDIsAlreadySet             = 3003,
    /*!
     @abstract Event visibility is invalid.
     */
    kTGErrorEventInvalidVisiblity           = 3004,
    /*!
     @abstract Event not found.
     */
    kTGErrorEventNotFound                   = 3007,
    /*!
     @abstract Size of event type is invalid.
     */
    kTGErrorEventTypeSize                   = 3008,

    // Internal event errors

    /*!
     @abstract Internal error while event creation.
     */
    kTGErrorInternalEventCreation = 3500,
    /*!
     @abstract Internal error while retrieving event.
     */
    kTGErrorInternalEventRead     = 3501,
    /*!
     @abstract Internal error while retrieving events list.
     */
    kTGErrorInternalEventsList    = 3502,
    /*!
     @abstract Internal error while updating event.
     */
    kTGErrorInternalEventUpdate   = 3503,
    /*!
     @abstract Internal error while retrieving followers list.
     */
    kTGErrorInternalFollowersList = 3504,
    /*!
     @abstract Internal error while retrieving following list.
     */
    kTGErrorInternalFollowingList = 3505,
    /*!
     @abstract Internal error while retrieving friends list.
     */
    kTGErrorInternalFriendsList   = 3506,

    // Authentication errors

    /*!
     @abstract General authentication error occured.
     */
    kTGErrorAuthGeneric                           = 4001,
    /*!
     @abstract Username and Email are invalid.
     */
    kTGErrorAuthGotBothUsernameAndEmail           = 4002,
    /*!
     @abstract No username or email provided.
     */
    kTGErrorAuthGotNoUsernameOrEmail              = 4003,
    /*!
     @abstract Invalid user credentials.
     */
    kTGErrorAuthInvalidApplicationUserCredentials = 4007,
    /*!
     @abstract Invalid email address.
     */
    kTGErrorAuthInvalidEmailAddress               = 4008,
    /*!
     @abstract This method is not supported.
     */
    kTGErrorAuthMethodNotSupported                = 4009,
    /*!
     @abstract The password was emtpy.
     */
    kTGErrorAuthPasswordEmpty                     = 4010,
    /*!
     @abstract The password is not correct.
     */
    kTGErrorAuthPasswordMismatch                  = 4011,
    /*!
     @abstract The session token is not correct.
     */
    kTGErrorAuthSessionTokenMismatch              = 4012,

    // Server errors

    /*!
     @abstract Image URL is invalid.
     */
    kTGErrorInvalidImageURL = 5000,
};

#pragma mark - Blocks

@class TGUser, TGEvent, TGPost;

/*!
 @abstract Completion block for succes.
 @discussion The TGSucessCompletionBlock will return a success flag and an error.
 */
typedef void (^TGSucessCompletionBlock)(BOOL success, NSError *error);

/*!
 @abstract Completion block for a user.
 @discussion The TGGetUserCompletionBlock will return a user or an error.
 */
typedef void (^TGGetUserCompletionBlock)(TGUser *user, NSError *error);

/*!
 @abstract Completion block for a user list.
 @discussion The TGGetUserListCompletionBlock will return a list of user or an error.
 */
typedef void (^TGGetUserListCompletionBlock)(NSArray *users, NSError *error);

/*!
 @abstract Completion block for an event.
 @discussion The TGGetEventCompletionBlock will return an event or an error.
 */
typedef void (^TGGetEventCompletionBlock)(TGEvent *event, NSError *error);

/*!
 @abstract Completion block for a network requets fetching a list of events.
 */
typedef void (^TGGetEventListCompletionBlock)(NSArray *events, NSError *error);

/*!
 @abstract Completion block for a feed.
 @discussion The TGFeedCompletionBlock will return the events, the unreadCount and an error.
 */
typedef void (^TGFeedCompletionBlock)(NSArray *events, NSInteger unreadCount, NSError *error);

/*!
 @abstract Completion block for a post.
 @discussion The TGGetPostCompletionBlock will return a user or an error.
 */
typedef void (^TGGetPostCompletionBlock)(TGPost *post, NSError *error);

/*!
 @abstract Completion block for a network requets fetching a list of posts.
 */
typedef void (^TGGetPostListCompletionBlock)(NSArray *posts, NSError *error);

/*!
 @abstract Completion block for a network requets fetching a list of posts and events.
 */
typedef void (^TGGetNewsFeedCompletionBlock)(NSArray *posts, NSArray *events, NSError *error);


