//
//  NSError+TGError.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 10/06/15.
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

extern NSString *const TGErrorUnderlyingErrorsKey;
extern NSString *const TGErrorHTTPStatusCodeKey;

@interface NSError (TGError)

+ (NSError*)tg_errorWithCode:(NSInteger)code userInfo:(NSDictionary *)dict;
+ (NSError*)tg_errorFromJsonDicitonary:(NSDictionary*)dictionary;
+ (NSError*)tg_errorFromJsonDicitonary:(NSDictionary*)dictionary withUserInfo:(NSDictionary*)userInfo;

@end
