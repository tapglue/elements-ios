//
//  TGConnection.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 07.12.2015.
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
#import "TGUser.h"

/*!
 @typedef Determines the connection state.
 @constant TGConnectionStatePending defines the state for a pending connection.
 @constant TGConnectionStateConfirmed defines the state for a confirmed connection.
 @constant TGConnectionStateRejected defines the state for a rejected connection.
 */
typedef NS_ENUM(NSUInteger, TGConnectionState) {
    TGConnectionStatePending = 0,
    TGConnectionStateConfirmed,
    TGConnectionStateRejected
};

@interface TGConnection : NSObject

/*!
 @abstract The user where the connection is triggered from.
 @discussion This property contains the user where the connection is being triggered from.
 */
@property (nonatomic, strong, readonly) TGUser *fromUser;

/*!
 @abstract The user where the connection is going to.
 @discussion This property contains the user where the connection is going to.
 */
@property (nonatomic, strong, readonly) TGUser *toUser;

/*!
 @abstract The date where the connection was created.
 @discussion This property contains the date the connection was created.
 */
@property (nonatomic, strong, readonly) NSDate *createdAt;

/*!
 @abstract The state of the connection.
 @discussion This property contains the user where the connection is being triggered from.
 */
@property (nonatomic, readonly) TGConnectionState state;

@end
