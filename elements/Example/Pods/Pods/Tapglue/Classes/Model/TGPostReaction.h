//
//  TGPostReaction.h
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

#import "TGModelObject.h"

@class TGUser, TGPost;

/*!
 @abstract The absract base class for reactions that the user can take on posts.
 */
@interface TGPostReaction : TGModelObject

/*!
 @abstract User who performed the reaction on the post.
 @discussion The user will be a TGUser object that contains the user who performed reaction on the post.
 */
@property (nonatomic, readonly) TGUser *user;

/*!
 @abstract The post the on which the is reaction performed on.
 */
@property (nonatomic, readonly) TGPost *post;


@end
