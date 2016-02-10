//
//  TGModelObject.h
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

#import <Foundation/Foundation.h>
#import "TGObject.h"

/*!
 @abstract `TGModelObject` Contains the shared properties for all objects.
 @discussion `TGModelObject` Contains the properties that are shared by all objects such as TGUser or TGEvent.
 */
@interface TGModelObject : TGObject

/*!
 @abstract CreateAt Date of an object.
 @discussion This contains the date of when an object was created.
 */
@property (nonatomic, strong, readonly) NSDate *createdAt;

/*!
 @abstract UpdatedAt Date of an object.
  @discussion This contains the date of when an object was updated.
 */
@property (nonatomic, strong, readonly) NSDate *updatedAt;

/*!
 @abstract Metadata assoiated with an event.
 @discussion This contains the custom metadata associated with an event.
 */
@property (nonatomic, strong) NSDictionary* metadata;

@end
