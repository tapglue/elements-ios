//
//  TGApiRoutesBuilder.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 09/12/15.
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

@class TGPostComment, TGPostLike;

@interface TGApiRoutesBuilder : NSObject

#pragma mark - Events

/*!
 @param userId The userId for aonther user or `nil` for the current user.
 @return The route to the events of a particlar user.
 */
+ (NSString*)routeForEventsOfUserWithId:(NSString*)userId;


#pragma mark - Posts

/*!
 @return The route to all posts.
 */
+ (NSString*)routeForAllPosts;

/*!
 @return The route to a particular post.
 */
+ (NSString*)routeForPostWithId:(NSString*)postId;

/*!
 @param userId The userId for aonther user or `nil` for the current user.
 @return The route to the posts of a particlar user.
 */
+ (NSString*)routeForPostsOfUserWithId:(NSString*)userId;


#pragma mark - Feeds

/*!
 @return The route to the feed of posts for the current user.
 */
+ (NSString*)routeForPostsFeed;

/*!
 @return The route to the feed of events for the current user.
 */
+ (NSString*)routeForEventsFeed;

/*!
 @return The route to the mixed feed of posts & events for the current user.
 */
+ (NSString*)routeForNewsFeed;


#pragma mark - Post reactions

+ (NSString*)routeForCommentsOnPostWithId:(NSString*)postId;

+ (NSString*)routeForComment:(TGPostComment*)comment;
+ (NSString*)routeForCommentWithId:(NSString*)commentId onPostWithId:(NSString*)postId;

+ (NSString*)routeForLike:(TGPostLike*)like;
+ (NSString*)routeForLikesOnPostWithId:(NSString*)postId;

+ (NSString*)routeForLikeWithId:(NSString*)likeId onPostWithId:(NSString*)postId;

@end
