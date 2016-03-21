//
//  TGUser.h
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
#import "TGModelObject.h"

/*!
 @abstract `TGUser` The primary model definition of the user object.
 @discussion `TGUser` contains the properties of a TGUser object. Any user send or retrieved from the Tapglue API will be mapped to a TGUser.
 */
@interface TGUser : TGModelObject

#pragma mark - User Model

/*!
 @abstract Unique user identifier from us.
 @discussion The userId will be a unique string.
 */
@property (nonatomic, strong, readonly) NSString *userId;

/*!
 @abstract Custom user identifier from you.
 @discussion The customId is a user identifier that you can send to map Tapglue users with your backend.
 */
@property (nonatomic, strong) NSString *customId;

/*!
 @abstract Username of the user.
 @discussion The username of the user has to be unique in your app.
 */
@property (nonatomic, strong) NSString *username;

/*!
 @abstract First name of the user.
 @discussion The first name of the user.
 */
@property (nonatomic, strong) NSString *firstName;

/*!
 @abstract Last name of the user.
 @discussion The last name of the user.
 */
@property (nonatomic, strong) NSString *lastName;

/*!
 @abstract Email of the user.
 @discussion The email adress of the user has to be unique in your app.
 */
@property (nonatomic, strong) NSString *email;

/*!
 @abstract URL of the user.
 @discussion The link of the users profile screen in your app.
 */
@property (nonatomic, strong) NSString *url;

/*!
 @abstract Images associated with the user.
 @discussion
 The dictionary holds instances of `TGImage` under `NSString` keys.
 
 Accessing `image` will always return at least and empty NSMutableDictionary which gets lazy initialized. So there is no need to handle `images` being nil befor adding values to it.
 */
@property (nonatomic, strong) NSMutableDictionary *images;

/*!
 @abstract Last login date of the user.
 @discussion The last login date of the user.
 */
@property (nonatomic, strong, readonly) NSDate *lastLogin;

/*!
 @abstract Activated status of the user.
 @discussion The acticated status of the user determines weather a user account if active or not.
 */
@property (nonatomic, readonly, getter=isActivated) BOOL activated;

/*!
 @abstract List of social Ids.
 @discussion The social Ids property contains a list of a users social ids.
 */
@property (nonatomic, strong, readonly) NSDictionary* socialIds;

/*!
 @abstract Social Id getter for a key.
 @discussion The socialIdForKey gets the social id of a user for a specific key.

 @param socialIdKey The key for which the social id should be retrieved.

 @return socialIdForKey The social id for the requested key.
 */
- (NSString*)socialIdForKey:(NSString*)socialIdKey;

/*!
 @abstract Social Id setter for a key.
 @discussion The socialIdForKey sets the social id of a user for a specific key.

 @param socialIdKey The key for which the social id should be set.
 */
- (void)setSocialId:(NSString*)socialId forKey:(NSString*)socialIdKey;

/*!
 @abstract User password setter.
 @discussion The setter to specify a user password.

 @param password The user password.
 */
- (void)setPassword:(NSString*)password;

/*!
 @abstract User password setter (unhashed).
 @discussion The setter to specify an unhashed user password.
 
 @param password The user password.
 */
- (void)setUnhashedPassword:(NSString*)password;

/*!
 @abstract Hashed password.
 @discussion The hashedPassword contains the password hashed with PBKDF2.
 */
@property (nonatomic, strong, readonly) NSString *hashedPassword;
+ (NSString*)hashPassword:(NSString*)password;

#pragma mark Connection stats

/*!
 @abstract The number of friends the user has.
 */
@property (nonatomic, assign) NSInteger friendsCount;

/*!
 @abstract The number of followers the user has.
 */
@property (nonatomic, assign) NSInteger followersCount;

/*!
 @abstract The number of users following the user.
 */
@property (nonatomic, assign) NSInteger followingCount;

/*!
 @abstract Indicate if the user is friend with the current user.
 */
@property (nonatomic, assign) BOOL isFriend;

/*!
 @abstract Indicate if the user is following the current user.
 */
@property (nonatomic, assign) BOOL isFollower;

/*!
 @abstract Indicate if the user is followed by the current user.
 */
@property (nonatomic, assign) BOOL isFollowed;


#pragma mark - Current User

/*!
 @abstract Check for currentUser.
 @discussion The isCurrentUser property checks if there is a current Tapglue User.
 */
@property (nonatomic, assign, readonly) BOOL isCurrentUser;


/*!
 @abstract Gets the currentUser.
 @discussion This will retrieve the currently logged in user or nil if not logged in.

 @returns Returns a `TGUser` that is the currently logged in user. If there is none, returns `nil`.
 */
+ (TGUser*)currentUser;

@end
