//
//  Tapglue+Private.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 05/06/15.
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

#import "Tapglue.h"
#import "TGLogger.h"

extern NSString *const TaplueSDKID;

@class TGEventManager, TGUserManager, TGPostsManager;

@interface Tapglue (Private)

/*!
 @abstract Stores the information about the current User.
 @discussion This will store all information about currentUser in a NSUserDefaults.
 */
@property (nonatomic, readonly) NSUserDefaults *userDefaults;

/*!
 @abstract Manager for all event interactions.
 @discussion This is the handler to manage all event interactions in the app.
 */
@property (nonatomic, strong) TGEventManager *eventManager;

/*!
 @abstract Manager for all user interactions.
 @discussion This is the handler to manage all user interactions in the app.
 */
@property (nonatomic, strong) TGUserManager *userManager;

/*!
 @abstract Manager for all posts interactions.
 @discussion This is the handler to manage all posts and related interactions in the app.
 */
@property (nonatomic, strong) TGPostsManager *postsManager;


#pragma mark - User Management

/*!
 @abstract Update the currentUser.
 @discussion This will update the currentUser.

 @warning This method has been deprecated, please use [[TGUser currentUser] saveWithCompletionBlock:].
 */
+ (void)updateUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock __attribute((deprecated("use [[TGUser currentUser] saveWithCompletionBlock:] method")));

/*!
 @abstract Delete the currentUser.
 @discussion This will delete the currentUser.

 @warning This method has been deprecated, please use [[TGUser currentUser] deleteWithCompletionBlock:].
 */
+ (void)deleteCurrentUserWithCompletionBlock:(TGSucessCompletionBlock)completionBlock __attribute((deprecated("use [[TGUser currentUser] deleteWithCompletionBlock:] method")));

#pragma mark - Events

/*!
 @abstract Create an event with a type.
 @discussion This will create an event with a certain type.

 @param type The type of the event that was performed (i.e. like or comment).
 */
+ (void)createEventWithType:(NSString*)type withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Create an event with a type and objectId.
 @discussion This will create an event with a certain type and an objectId.

 @param type The type of the event that was performed (i.e. like or comment).
 @param objectId Id of the object that was associated with the event.
 */
+ (void)createEventWithTypeAndObjectId:(NSString*)type
                               andObjectId:(NSString*)objectId
            withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Create an event with a TGEvent.
 @discussion This will create an event with a TGEvent object.

 @param event The TGEvent object including the event attributes.
 */
+ (void)createEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Update an event with a TGEvent.
 @discussion This will update an event with a TGEvent object.

 @param event The TGEvent object including the updated event attributes.
 */
+ (void)updateEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock;
// TODO: consider deprecated: [TGEvent saveWithCompletion]

/*!
 @abstract Delete an event.
 @discussion This will delete an event with an eventId.

 @param eventId The id of the event that is supposed to be deleted.
 */
+ (void)deleteEventWithId:(NSString*)eventId withCompletionBlock:(TGSucessCompletionBlock)completionBlock;
// TODO: consider deprecated: [TGEvent deleteWithCompletion];


/*!
 @abstract Resets all internals of the Tapglue instance.
 @discussion It will clear all caches to remove all data that belong to the current logged-in user.
 */
- (void)reset;

@end
