//
//  TGObject+Private.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 04/06/15.
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

#import "TGObject.h"

/*!
 @abstract JSON Key for an objectId object.
 @constant TGModelObjectIdJsonKey The JSON Key for an objectId.
 */
extern NSString *const TGModelObjectIdJsonKey;


@protocol TGObjectJsonMapping <NSObject>
@optional
- (NSDictionary*)jsonMappingForWriting;
@end


/*!
 @abstract The defaul TGObject.
 @discussion TGObject contains the objectId associated with each object.
 */
@interface TGObject (Private) <TGObjectJsonMapping>

/*!
 @abstract The unique objectId.
 @discussion The default objectId for every object. Usually it gets set by the backend. However, there are cases it might have be set internally SDK.
 */
@property (nonatomic, strong, readwrite) NSString *objectId;

/*!
 @abstract The mapped jsonDictionary.
 @discussion The jsonDictionary will contain the data in JSON format.
 */
@property (nonatomic, readonly) NSDictionary *jsonDictionary;

- (instancetype)initWithDictionary:(NSDictionary*)data;

- (NSMutableDictionary*)dictionaryWithMapping:(NSDictionary*)mapping;

- (void)loadDataFromDictionary:(NSDictionary*)data;

- (void)loadDataFromDictionary:(NSDictionary*)data withMapping:(NSDictionary*)mapping;

- (NSDictionary*)jsonMapping;

@end
