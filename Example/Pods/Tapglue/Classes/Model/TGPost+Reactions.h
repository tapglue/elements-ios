//
//  TGPost+Reactions.h
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

#import "TGPost.h"

@class TGComment, TGLike;

@interface TGPost (Reactions)

#pragma mark - Comments

/*!
 @abstract Create Comment with content on a post.
 @discussion This will create a comment with a certain content.
 
 @param commentContent This contains the comment.
 */
- (TGComment*)commentWithContent:(NSString*)commentContent withCompletionBlock:(TGSucessCompletionBlock)completionBlock;

#pragma mark - Likes

/*!
 @abstract Create a like on a post.
 @discussion Create a like on a post.
 */
- (TGLike*)likeWithCompletionBlock:(TGSucessCompletionBlock)completionBlock;

/*!
 @abstract Unlike a post.
 @discussion Unlike a post.
 */
- (void)unlikeWithCompletionBlock:(TGSucessCompletionBlock)completionBlock;

@end
