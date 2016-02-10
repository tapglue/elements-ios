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

#import "TGPost+Reactions.h"
#import "Tapglue+Private.h"
#import "TGPostsManager.h"

@implementation TGPost (Reactions)

#pragma mark - Comments

- (TGPostComment*)commentWithContent:(NSString*)commentContent withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    return [[Tapglue sharedInstance].postsManager createCommentWithContent:commentContent forPost:self withCompletionBlock:completionBlock];
}

#pragma mark - Likes

- (TGPostLike*)likeWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    return [[Tapglue sharedInstance].postsManager createLikeForPost:self withCompletionBlock:completionBlock];
}

- (void)unlikeWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [[Tapglue sharedInstance].postsManager deleteLike:self withCompletionBlock:completionBlock];
}

@end
