//
//  TGLogger.h
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 09/06/15.
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

//#define TGLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
//#define TGLog(...)  [TGLogger logFormat:  ( NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define TGLog(...)  [TGLogger log:__VA_ARGS__];

/*!
 @abstract The Tapglue Logger.
 @discussion This is the custom logger for the Tapglue SDK.
 */
@interface TGLogger : NSObject

/*!
 @abstract Active the Tapglue logger.
 @discussion This is active the tapglue logger if it is configured.

 @param loggingEnabled Parameter is logging is enabled or not.
 */
+ (void)setLoggingEnabled:(BOOL)loggingEnabled;

/*!
 @abstract Specifies log format and parameters.
 @discussion This configure what parameters should be logged in what format.

 @param format The log format.
 @param parameters Parameters to be logged.
 */
+ (void)logFormat:(NSString *)format withParameters:(va_list)parameters;

/*!
 @abstract Logger for a string.
 */
+ (void)log:(NSString *)format, ...;

@end
