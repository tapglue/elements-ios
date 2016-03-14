//
//  TGApiRoutesHelper.h
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

#import "TGApiRoutesBuilder.h"
#import "TGPost.h"
#import "TGComment.h"
#import "TGLike.h"

static NSString * const TGApiRouteUsers = @"users";
static NSString * const TGApiRouteCurrentUser = @"me";
static NSString * const TGApiRouteFeed = @"feed";
static NSString * const TGApiRoutePosts = @"posts";
static NSString * const TGApiRouteEvents = @"events";
static NSString * const TGApiRouteExternals = @"externals";
static NSString * const TGApiRouteComments = @"comments";
static NSString * const TGApiRouteLikes = @"likes";
static NSString * const TGApiRouteRecommendations = @"recommendations";

@implementation TGApiRoutesBuilder

#pragma mark - Events

+ (NSString*)routeForEventsOfUserWithId:(NSString*)userId {
    return [[self baseRouteForUserWithId:userId] stringByAppendingPathComponent:TGApiRouteEvents];
}

#pragma mark - Posts

+ (NSString*)routeForAllPosts {
    return TGApiRoutePosts;
}

+ (NSString*)routeForPostWithId:(NSString*)postId {
    NSParameterAssert(postId);
    return [TGApiRoutePosts stringByAppendingPathComponent:postId];
}

+ (NSString*)routeForPostsOfUserWithId:(NSString*)userId {
    return [[self baseRouteForUserWithId:userId] stringByAppendingPathComponent:TGApiRoutePosts];
}

#pragma mark - Feeds

+ (NSString*)routeForPostsFeed {
    return [[self baseRouteForFeeds] stringByAppendingPathComponent:TGApiRoutePosts];
}

+ (NSString*)routeForEventsFeed {
    return [[self baseRouteForFeeds] stringByAppendingPathComponent:TGApiRouteEvents];
}

+ (NSString*)routeForNewsFeed {
    return [self baseRouteForFeeds];
}

+ (NSString*)baseRouteForFeeds {
    return [TGApiRouteCurrentUser stringByAppendingPathComponent:TGApiRouteFeed];
}

#pragma mark - Post reactions

+ (NSString*)routeForCommentsOnPostWithId:(NSString*)postId {
    return [[self routeForPostWithId:postId] stringByAppendingPathComponent:TGApiRouteComments];
}

+ (NSString*)routeForComment:(TGComment *)comment {
    return [self routeForCommentWithId:comment.objectId onPostWithId:comment.post.objectId];
}

+ (NSString*)routeForCommentWithId:(NSString*)commentId onPostWithId:(NSString*)postId {
    NSParameterAssert(commentId);
    return [[self routeForCommentsOnPostWithId:postId] stringByAppendingPathComponent:commentId];
}

+ (NSString*)routeForLike:(TGLike *)like {
    return [self routeForLikeWithId:like.objectId onPostWithId:like.post.objectId];
}

+ (NSString*)routeForLikesOnPostWithId:(NSString*)postId {
    return [[self routeForPostWithId:postId] stringByAppendingPathComponent:TGApiRouteLikes];
}

+ (NSString*)routeForLikeWithId:(NSString*)likeId onPostWithId:(NSString*)postId {
    NSParameterAssert(likeId);
    return [[self routeForLikesOnPostWithId:postId] stringByAppendingPathComponent:likeId];
}

#pragma mark - Comments -

+ (NSString*)routeForCommentOnObjectId:(NSString *)objectId {
    return [[TGApiRouteExternals stringByAppendingPathComponent:objectId] stringByAppendingPathComponent:TGApiRouteComments];
}

+ (NSString*)routeForCommentWithId:(NSString*)commentId onObjectWithId:(NSString*)objectId {
    return [[[TGApiRouteExternals stringByAppendingPathComponent:objectId] stringByAppendingPathComponent:TGApiRouteComments] stringByAppendingPathComponent:commentId];
}
#pragma mark - Likes -

+ (NSString*)routeForLikeOnObjectId:(NSString *)objectId {
    return [[TGApiRouteExternals stringByAppendingPathComponent:objectId] stringByAppendingPathComponent:TGApiRouteLikes];
}

#pragma mark - User recommendations

+ (NSString*)routeForUserRecommendationsOfType:(NSString*)type andPeriod:(NSString*)period {
    //TODO: Rewrite to Switch-Case
    if (type == TGUserRecommendationsTypeActive) {
        return [[[TGApiRouteRecommendations stringByAppendingPathComponent:TGApiRouteUsers] stringByAppendingPathComponent:type] stringByAppendingPathComponent:period];
    } else {
        // Default behaviour is to retrieve the most active users
        return [[[TGApiRouteRecommendations stringByAppendingPathComponent:TGApiRouteUsers] stringByAppendingPathComponent:type] stringByAppendingPathComponent:period];
    }
}

#pragma mark - Helper

/*!
 @param userId The userId for aonther user or `nil` for the current user.
 */
+ (NSString*)baseRouteForUserWithId:(NSString*)userId {
    if (userId) {
        return [TGApiRouteUsers stringByAppendingPathComponent:userId];
    }
    else {
        return TGApiRouteCurrentUser;
    }
}


@end