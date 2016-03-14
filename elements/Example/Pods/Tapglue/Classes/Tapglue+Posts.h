//
//  Tapglue+Posts.h
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

#import "Tapglue.h"
#import "TGPost.h"
#import "TGPost+Reactions.h"
#import "TGAttachment.h"
#import "TGComment.h"
#import "TGLike.h"

@interface Tapglue (Posts)

#pragma mark - Posts -

#pragma mark CRUD

/*!
 @abstract Create a post.
 @discussion This will create an post for a the current user.
 
 @param post The TGPost object that contains the post information.
 */
+ (void)createPost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Create a post.
 @discussion This will create an post for a the current user.
 
 @param post The TGPost object that contains the post information.
 @param text The text that the post contains.
 @param name The name of the post.
 */
+ (void)createPostWithText:(NSString*)attachmentText named:(NSString*)attachmentName withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Update a post.
 @discussion This will update a post.
 
 @param event The TGPost object that contains the post information.
 */
+ (void)updatePost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Delete a post.
 @discussion This will delete a post for a given id.
 
 @param postId the objectId of the post to be deleted.
 */
+ (void)deletePostWithId:(NSString*)objectId withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve a post.
 @discussion This will retrieve a post for a given id.
 
 @param objectId The id of the post that should be fetched.
 */
+ (void)retrievePostWithId:(NSString*)objectId withCompletionBlock:(TGGetPostCompletionBlock)completionBlock;


#pragma mark Lists

/*!
 @abstract Retrieve all posts.
 */
+ (void)retrieveAllPostsWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the feed of posts for the current user.
 */
+ (void)retrievePostsFeedForCurrentUserWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the own of posts made by the current user.
 */
+ (void)retrievePostsForCurrentUserWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the posts made by the given user.
 @param user The user to retrieve it's posts for.
 */
+ (void)retrievePostsForUser:(TGUser*)user withCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;

/*!
 @abstract Retrieve the posts made by the given user.
 @param userId The user's id to retrieve it's posts for.
 */
+ (void)retrievePostsForUserWithId:(NSString*)userId withCompletionBlock:(TGGetPostListCompletionBlock)completionBlock;


#pragma mark - Comments -

/*!
 @abstract Creates a comment on a post.
 @discussion This will create a comment on a post.
 
 @param commentContent The content of the comment.
 @param post The Post object that is being commented.
 */
+ (TGComment*)createCommentWithContent:(NSString*)commentContent
                                   forPost:(TGPost*)post
                       withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Updates a comment on a post.
 @discussion This will update a comment on a post.
 
 @param comment The comment object that is being updated.
 */
+ (void)updateComment:(TGComment*)comment withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Deletes a comment on a post.
 @discussion This will delete a comment on a post.
 
 @param comment The comment object that is being deleted.
 */
+ (void)deleteComment:(TGComment*)comment withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Retrieve comments for a post.
 @discussion This will retrieve all comments for a post.
 
 @param post The post object for which comments are retrieved.
 */
+ (void)retrieveCommentsForPost:(TGPost*)post
            withCompletionBlock:(void (^)(NSArray *comments, NSError *error))completionBlock;

/*!
 @abstract Retrieve comments for a postId.
 @discussion This will retrieve all comments for a postId.
 
 @param postId The postId for which comments are retrieved.
 */
+ (void)retrieveCommentsForPostWithId:(NSString*)postId
                  withCompletionBlock:(void (^)(NSArray *comments, NSError *error))completionBlock;

#pragma mark - Likes -

/*!
 @abstract Create a like for a post.
 @discussion This will create a like for a post.
 
 @param post The post object for which a like is being created.
 */
+ (TGLike*)createLikeForPost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Delete a like for a post.
 @discussion This will delete a like for a post.
 
 @param post The post object that is being unliked.
 */
+ (void)deleteLike:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock;


/*!
 @abstract Retrieve likes for a post.
 @discussion This will retrieve all likes for a post.
 
 @param postId The post object for which likes are retrieved.
 */
+ (void)retrieveLikesForPost:(TGPost*)post
         withCompletionBlock:(void (^)(NSArray *likes, NSError *error))completionBlock;

/*!
 @abstract Retrieve likes for a postId.
 @discussion This will retrieve all likes for a postId.
 
 @param postId The postId for which likes are retrieved.
 */
+ (void)retrieveLikesForPostWithId:(NSString*)postId
               withCompletionBlock:(void (^)(NSArray *likes, NSError *error))completionBlock;


@end
