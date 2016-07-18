//
//  TGAttachments.m
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


#import "TGModelObject.h"

@interface TGAttachment : TGModelObject

/*!
 @abstract Creates an attachment of type text with a name.
 @discussion This will create an attachment of type text with a name.
 */
+ (instancetype) attachmentWithText:(NSDictionary *)text andName:(NSString*)name;

/*!
 @abstract Creates an attachment of type URL with a name.
 @discussion This will create an attachment of URL with a name.
 */
+ (instancetype) attachmentWithURL:(NSDictionary *)urlStrings andName:(NSString*)name;

/*!
 @abstract The type of an attachment.
 @discussion This property contains the type of an attachment.
 */
@property (nonatomic, strong, readonly) NSString *type;

/*!
 @abstract The name of an attachment.
 @discussion This property contains the name of an attachment.
 */
@property (nonatomic, strong) NSString *name;

/*!
 @abstract The contents of an attachment.
 @discussion This property contains the BCP 47 content of the attachment.
 */
@property (nonatomic, strong) NSDictionary *contents;

@end
