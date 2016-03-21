//
//  NSDictionary+TGUtilities.h
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

#import <Foundation/Foundation.h>

@interface NSDictionary (TGUtilities)

/*!
 @abstract Check if the dictionary has a string value for a given key.

 @param key The key that should be checked.

 @return The result will be true if there is a value and the value is kind of `NSString` or false otherwise.
 */
- (BOOL) tg_hasStringValueForKey:(NSString*)key;


/*!
 @abstract Check if the dictionary has a number value for a given key.
 
 @param key The key that should be checked.
 
 @return The result will be true if there is a value and the value is kind of `NSNumber` or false otherwise.
 */
- (BOOL) tg_hasNumberValueForKey:(NSString*)key;


- (NSString*)tg_stringValueForKey:(NSString*)key;

    
@end

@interface NSMutableDictionary (TGUtilities)

/*!
 @abstract Set the value for a specific key.

 @param value The value that should be set.
 @param key The key the value should be set for.
 */
- (void)tg_setValueIfNotNil:(id)value forKey:(NSString*)key;
- (void)tg_setValueOrNull:(id)value forKey:(NSString*)key;

@end
