//
//  TGPostsManager.m
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

#import "TGPostsManager.h"
#import "TGApiClient+TGObject.h"
#import "TGPost.h"
#import "TGModelObject+Private.h"
#import "Tapglue+Private.h"
#import "NSError+TGError.h"
#import "TGObjectCache.h"
#import "TGApiRoutesBuilder.h"
#import "TGReaction+Private.h"
#import "TGComment.h"
#import "TGLike.h"

@implementation TGPostsManager

#pragma mark - Post -

#pragma mark CRUD

- (void)createPost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client POST:[TGApiRoutesBuilder routeForAllPosts] withURLParameters:nil andPayload:post.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        
        [post loadDataFromDictionary:jsonResponse];
        [[TGPost cache] addObject:post];
        
        if (!error) {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
    
}

- (void)updatePost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client updateObject:post
                      atRoute:[TGApiRoutesBuilder routeForPostWithId:post.objectId]
          withCompletionBlock:completionBlock];
}

- (void)deletePostWithId:(NSString*)objectId withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client DELETE:[TGApiRoutesBuilder routeForPostWithId:objectId] withCompletionBlock:completionBlock];
}

- (void)retrievePostWithId:(NSString*)objectId withCompletionBlock:(TGGetPostCompletionBlock)completionBlock {
    [self.client GET:[TGApiRoutesBuilder routeForPostWithId:objectId] withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (jsonResponse && !error) {
            TGPost *post = [[TGPost alloc] initWithDictionary:jsonResponse];
            if (completionBlock) {
                completionBlock(post, nil);
            }
        }
        else if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}


#pragma mark Lists

- (void)retrieveAllPostsWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    // route: /posts
    [self retrievePostsAtRoute:[TGApiRoutesBuilder routeForAllPosts] withCompletionBlock:completionBlock];
}

- (void)retrievePostsFeedForCurrentUserWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    // route: /me/feed/posts
    [self retrievePostsAtRoute:[TGApiRoutesBuilder routeForPostsFeed] withCompletionBlock:completionBlock];
}

- (void)retrievePostsForCurrentUserWithCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    // route: /me/posts
    [self retrievePostsAtRoute:[TGApiRoutesBuilder routeForPostsOfUserWithId:nil] withCompletionBlock:completionBlock];
}

- (void)retrievePostsForUserWithId:(NSString*)userId withCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    // route: /users/{userID}/posts
    [self retrievePostsAtRoute:[TGApiRoutesBuilder routeForPostsOfUserWithId:userId] withCompletionBlock:completionBlock];
}

- (void)retrievePostsAtRoute:(NSString*)route withCompletionBlock:(TGGetPostListCompletionBlock)completionBlock {
    [self.client GET:route withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (!error) {
            NSArray *userDictionaries = [[jsonResponse objectForKey:@"users"] allValues];
            [TGUser createAndCacheObjectsFromDictionaries:userDictionaries];
            
            NSArray *posts = [self postsFromJsonResponse:jsonResponse];
            
            if (completionBlock) {
                completionBlock(posts, nil);
            }
        }
        else if(completionBlock) {
            completionBlock(nil, error);
        }
    }];
}


#pragma mark - Comments -

- (TGComment*)createCommentWithContent:(NSDictionary*)commentContent
                               forPost:(TGPost*)post
                   withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    
    TGComment *comment = [[TGComment alloc] init];
    comment.contents = commentContent;
    comment.post = post;
    comment.user = [TGUser currentUser];
    
    [self.client createObject:comment
                      atRoute:[TGApiRoutesBuilder routeForCommentsOnPostWithId:post.objectId]
          withCompletionBlock:completionBlock];
    
    return comment;
}

- (void)updateComment:(TGComment*)comment withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client updateObject:comment
                      atRoute:[TGApiRoutesBuilder routeForComment:comment]
          withCompletionBlock:completionBlock];
}

- (void)deleteComment:(TGComment*)comment withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client DELETE:[TGApiRoutesBuilder routeForComment:comment] withCompletionBlock:completionBlock];
}

- (void)retrieveCommentsForPostWithId:(NSString*)postId
                  withCompletionBlock:(void (^)(NSArray *comments, NSError *error))completionBlock {
    [self.client GET:[TGApiRoutesBuilder routeForCommentsOnPostWithId:postId] withURLParameters:nil andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        
        if (!error) {
            NSArray *userDictionaries = [[jsonResponse objectForKey:@"users"] allValues];
            [TGUser createAndCacheObjectsFromDictionaries:userDictionaries];
            
            NSArray *commentDictionaries = [jsonResponse objectForKey:@"comments"];
            NSMutableArray *comments = [NSMutableArray arrayWithCapacity:commentDictionaries.count];
            for (NSDictionary *data in commentDictionaries) {
                [comments addObject:[[TGComment alloc] initWithDictionary:data]];
            }
            
            if (completionBlock) {
                completionBlock(comments, nil);
            }
        }
        else if(completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

#pragma mark - Likes -

- (TGLike*)createLikeForPost:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    TGLike *like = [[TGLike alloc] init];
    like.post = post;
    like.user = [TGUser currentUser];
    
    [self.client POST:[TGApiRoutesBuilder routeForLikesOnPostWithId:post.objectId] withURLParameters:nil andPayload:nil andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [like loadDataFromDictionary:jsonResponse]; // update the data
        if (!error) {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
    
    return like;
}

- (void)createLikeForPostWithId:(NSString*)postId withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    
    [self.client POST:[TGApiRoutesBuilder routeForLikesOnPostWithId:postId] withURLParameters:nil andPayload:nil andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (!error) {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

- (void)deleteLike:(TGPost*)post withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client DELETE:[TGApiRoutesBuilder routeForLikesOnPostWithId:post.objectId] withCompletionBlock:completionBlock];
}

- (void)deleteLikeForPostWithId:(NSString*)postId withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client DELETE:[TGApiRoutesBuilder routeForLikesOnPostWithId:postId] withCompletionBlock:completionBlock];
}

- (void)retrieveLikesForPostWithId:(NSString*)postId
               withCompletionBlock:(void (^)(NSArray *Likes, NSError *error))completionBlock {
    [self.client GET:[TGApiRoutesBuilder routeForLikesOnPostWithId:postId] withURLParameters:nil andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        
        if (!error) {
            NSArray *userDictionaries = [[jsonResponse objectForKey:@"users"] allValues];
            [TGUser createAndCacheObjectsFromDictionaries:userDictionaries];
            
            NSArray *likeDictionaries = [jsonResponse objectForKey:@"likes"];
            NSMutableArray *likes = [NSMutableArray arrayWithCapacity:likeDictionaries.count];
            for (NSDictionary *data in likeDictionaries) {
                [likes addObject:[[TGLike alloc] initWithDictionary:data]];
            }
            
            if (completionBlock) {
                completionBlock(likes, nil);
            }
        }
        else if(completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

#pragma mark - Helper

- (NSArray*)postsFromJsonResponse:(NSDictionary*)jsonResponse {
    NSArray *postDictionaries = [jsonResponse objectForKey:@"posts"];
    NSMutableArray *posts = [NSMutableArray arrayWithCapacity:postDictionaries.count];
    for (NSDictionary *postData in postDictionaries) {
        TGPost *newPost = [TGPost createOrLoadWithDictionary:postData];
        [posts addObject:newPost];
    }
    return posts;
}
@end