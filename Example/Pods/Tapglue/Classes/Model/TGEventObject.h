//
//  TGEventObject.h
//  Tapglue iOS SDK
//
//  Created by Onur Akpolat on 03/06/15.
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

@class TGUser;

@interface TGEventObject : TGModelObject

/*!
 @abstract The objectId for any object.
 @discussion This property contains the unique id for each object. Unlike all other model objects this is not set by Tapglue.
 */
@property (nonatomic, strong) NSString *objectId;
/*!
 @abstract User who performed the event.
 @discussion The user will be a TGUser object that contains the user who performed the event.
 */
@property (nonatomic, strong) TGUser *user;
/*!
 @abstract Type of the object.
 @discussion The type of the object.
 */
@property (nonatomic, strong) NSString *type;

/*!
 @abstract URL of the object.
 @discussion The url or deeplink of the object.
 */
@property (nonatomic, strong) NSString *url;

/*!
 @abstract Getter for display name in a language.
 @discussion The getter for retrieving the display name for a specific language.

 @warning English is the fallback language in case the requested langauge is not available.

 @param The language for which the display name should be returned

 @return The display name for the requested language.
 */
- (NSString*)displayNameForLanguage:(NSString*)language;

/*!
 @abstract Getter for display name for device language.
 @discussion The getter for retrieving the display name for for the device language.

 @warning English is the fallback language in case the requested langauge is not available.

 @return The display name for the device language.
 */
- (NSString*)displayNameForDeviceLanguage;

/*!
 @abstract Display name setter for a language.
 @discussion The setter for for specifying the display name for a language.

 @param displayName The display name for that is being set.
 @param language The language for which the display name should be set.
 */
- (void)setDisplayName:(NSString*)displayName forLanguage:(NSString*)language;

@end
