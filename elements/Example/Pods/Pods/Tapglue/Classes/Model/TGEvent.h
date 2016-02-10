//
//  TGEvent.h
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

#import "TGModelObject.h"
#import "TGConstants.h"
#import <Foundation/Foundation.h>

@class TGUser, TGEventObject;

@interface TGEvent : TGModelObject <NSCoding>

/*!
 @abstract Unique identifier of the event.
 @discussion The eventId will be a unique string.
 */
@property (nonatomic, strong, readonly) NSString *eventId;

/*!
 @abstract User who performed the event.
 @discussion The user will be a TGUser object that contains the user who performed the event.
 */
@property (nonatomic, strong) TGUser *user;

/*!
 @abstract Type of the event.
 @discussion The type of the event that was performed (i.e. like or comment).
 */
@property (nonatomic, strong) NSString *type;

/*!
 @abstract Priority of the event.
 @discussion The priority of the event for applying custom logic.
 */
@property (nonatomic, strong) NSString *priority;

/*!
 @abstract Language of the event.
 @discussion The language of the event that was performed (i.e. en or de).
 */
@property (nonatomic, strong) NSString *language;

/*!
 @abstract Location of the event.
 @discussion The location of where the event was performed.
 */
@property (nonatomic, strong) NSString *location;

/*!
 @abstract Latitude value of the event.
 @discussion The latidute value of where the event was performed.
 */
@property (nonatomic, assign) float latitude;

/*!
 @abstract Longitude value of the event.
 @discussion The longitude value of where the event was performed.
 */
@property (nonatomic, assign) float longitude;

/*!
 @abstract Visibility of the event.
 @discussion The visibility of the event determines if it should be public, private or only be seen by connections.
 */
@property (nonatomic, assign) TGVisibility visibility;

/*!
 @abstract Images associated with the event.
 @discussion 
    The dictionary holds instances of `TGImage` under `NSString` keys.
    
    Accessing `image` will always return at least and empty NSMutableDictionary which gets lazy initialized. So there is no need to handle `images` being nil befor adding values to it.
 */
@property (nonatomic, strong) NSMutableDictionary *images;

/*!
 @abstract Object of the event.
 @discussion The object on which an event was performed.
 */
@property (nonatomic, strong) TGEventObject *object;

/*!
 @abstract Target of the event.
 @discussion The target on which an event object was performed.
 */
@property (nonatomic, strong) TGEventObject *target;

/*!
 @abstract The ID of the Tapglue ID.
 @discussion The ID of the Tapglue ID.
 */
@property (nonatomic, strong) NSString *tgObjectId;


@end
