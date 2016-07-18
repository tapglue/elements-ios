//
//  TGPostsManager.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 08/12/15.
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

#import "TGBaseManager.h"
#import "TGConstants.h"

@class TGUser, TGPost, TGComment, TGLike;

@interface TGPostsManager : TGBaseManager

#pragma mark - Posts -

#pragma mark CRUD

/*!
 @abstract Create a post.
 @discussion This will create an post for a the current user.
 
 @param post The TGPost object that contains the post information.
 */
- (void)createPost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Update a post.
 @discussion This will update a post.
 
 @param event The TGPost object that contains the post information.
 */
- (void)updatePost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Delete a post.
 @discussion This will delete a post for a given id.
 
 @param postId the objectId of the post to be deleted.
 */
- (void)deletePostWithId:(NSString*)objectId withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve a post.
 @discussion This will retrieve a post for a given id.
 
 @param objectId The id of the post that should be fetched.
 */
- (void)retrievePostWithId:(NSString*)objectId withCompletionBlock:(TGGetPostCompletionBlock)completionBlock;


#pragma mark Lists

/*!
 @abstract Retrieve all posts.
 */
- (void)retrieveAllPostsWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the feed of posts for the current user.
 */
- (void)retrievePostsFeedForCurrentUserWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the own of posts made by the current user.
 */
- (void)retrievePostsForCurrentUserWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the posts made by the given user.
 @param userId The user's id to retrieve it's posts for.
 */
- (void)retrievePostsForUserWithId:(NSString*)userId withCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;


#pragma mark - Comments -

- (TGComment*)createCommentWithContent:(NSDictionary*)commentContent
                               forPost:(TGPost*)post
                   withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

- (void)updateComment:(TGComment*)comment withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

- (void)deleteComment:(TGComment*)comment withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

- (void)retrieveCommentsForPostWithId:(NSString*)postId
                  withCompletionBlock:(void (^)(NSArray *comments, NSError *error))completionBlock;

#pragma mark - Likes

- (TGLike*)createLikeForPost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

- (void)createLikeForPostWithId:(NSString*)postId withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

- (void)deleteLike:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

- (void)deleteLikeForPostWithId:(NSString*)postId withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

- (void)retrieveLikesForPostWithId:(NSString*)postId
               withCompletionBlock:(void (^)(NSArray *likes, NSError *error))completionBlock;

@end
