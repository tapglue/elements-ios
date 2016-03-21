//
//  TGConfiguration.h
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

/*!
 @abstract Container to setup the Tapglue SDK.
 @discussion TGConfiguration is a temporary container object to setup the tapglue stack. It will not be stored somewhere neither will be accessible after the the setup.
 */
@interface TGConfiguration : NSObject


/*!
 @abstract Base URL of the Tapglue API.
 @discussion This specifies the Base URL of the Tapglue API.
 */
@property (nonatomic, strong) NSString *apiBaseUrl;

/*!
 @abstract API Version of the Tapglue API.
 @discussion This specifies the API version that is being used in the SDK.
 */
@property (nonatomic, strong) NSString *apiVersion;

/*!
 @abstract Status of the Tapglue Logger.
 @discussion This specifies the status of weather the logger is enabled or not.
 */
@property (nonatomic, assign, getter=isLoggingEnabled) BOOL loggingEnabled;

/*!
 @abstract Flush timer's interval in seconds.
 @discussion Setting a flush interval of 0 will turn off the flush timer. Default: 10 seconds.
 */
@property (nonatomic, assign) NSUInteger flushInterval;

/*!
 @abstract Status of the network activity toggle.
 @discussion This specifies the status of the network activity toggle.

 @warning The network activity toggle is activated by default.
 */
@property (nonatomic, assign) BOOL showNetworkActivityIndicator;

/*!
 @abstract Status if basic analytics are enabled.
 @discussion The basic analytics are enabled by default.
 */
@property (nonatomic, assign, getter=isAnalyticsEnabled) BOOL analyticsEnabled;

- (instancetype) init __attribute__((unavailable("use [TGConfiguration defaultConfiguration]")));

/*!
 @abstract The default configuration.
 @discussion This contains the default configuration for initializing the Tapglue SDK.
 */
+ (instancetype) defaultConfiguration;

@end
