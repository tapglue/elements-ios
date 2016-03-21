//
//  TGApiClient.h
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

extern NSString *const TGApiEndpointEvents;
extern NSString *const TGApiEndpointUsers;
extern NSString *const TGApiEndpointCurrentUser;

/*!
 @abstract Completion block for a network requets.
 */
typedef void (^TGNetworkCompletionBlock)(NSDictionary *jsonResponse, NSError *error);

@class TGConfiguration;

/*!
 @abstract The main API client.
 @discussion This client will do all the networm communication with Taplue.
 */
@interface TGApiClient : NSObject

/*!
 @abstract The application token.
 @discussion You have to enter your appToken that you retrieve after creating an app in the dashboard.
 */
@property (nonatomic, readonly) NSString *appToken;

/*!
 @abstract The session token.
 @discussion The session will be retrieved after performing a user login.
 */
@property (nonatomic, strong) NSString *sessionToken;

/*!
 @abstract Initialize the Tapglue SDK.
 @discussion This will initialize the Tapglue SDK with a token and configuration.

 @param token The token contains the application token from the dashboard.
 @param config The config hold the configuration of the SDK.
 */
- (instancetype)initWithAppToken:(NSString*)token andConfig:(TGConfiguration*)config;

/*!
 @abstract Ping the analytics endpoint.
 @discussion This will ping the Tapglue analytics endpoint once every session to create basic metrics for the dashboard.
 */
- (void)pingAnalyticsEndpoint;

/*!
 @abstract A GET request.
 @discussion This will create a GET request to a given endpoint.

 @param endpoint The endpoint to which the request goes.

 @return A NSURLSessionDataTask will be returned.
 */
- (NSURLSessionDataTask*)GET:(NSString*)endPoint
          withCompletionBlock:(TGNetworkCompletionBlock)completionBlock;

/*!
 @abstract A GET request with parameters.
 @discussion This will create a GET request with addition URL parameters to a given endpoint.

 @param endpoint The endpoint to which the request goes.
 @param urlParams Additional URL parameters of the request.

 @return A NSURLSessionDataTask will be returned.
 */
- (NSURLSessionDataTask*)GET:(NSString*)endPoint
           withURLParameters:(NSDictionary*)urlParams
          andCompletionBlock:(TGNetworkCompletionBlock)completionBlock;

/*!
 @abstract A POST request with parameters and a body.
 @discussion This will create a POST request with addition URL parameters and a body to a given endpoint.

 @param endpoint The endpoint to which the request goes.
 @param urlParams Additional URL parameters of the request.
 @param bodyObject The payload of the request.

 @return A NSURLSessionDataTask will be returned.
 */
- (NSURLSessionDataTask*)POST:(NSString*)endPoint
            withURLParameters:(NSDictionary*)urlParams
                   andPayload:(NSDictionary*)bodyObject
           andCompletionBlock:(TGNetworkCompletionBlock)completionBlock;

/*!
 @abstract A PUT request with parameters and a body.
 @discussion This will create a PUT request with addition URL parameters and a body to a given endpoint.

 @param endpoint The endpoint to which the request goes.
 @param urlParams Additional URL parameters of the request.
 @param bodyObject The payload of the request.

 @return A NSURLSessionDataTask will be returned.
 */
- (NSURLSessionDataTask*)PUT:(NSString*)endPoint
           withURLParameters:(NSDictionary*)urlParams
                  andPayload:(NSDictionary*)bodyObject
          andCompletionBlock:(TGNetworkCompletionBlock)completionBlock;

/*!
 @abstract A DELETE request.
 @discussion This will create a DELETE request to a given endpoint.

 @param endpoint The endpoint to which the request goes.

 @return A NSURLSessionDataTask will be returned.
 */
- (NSURLSessionDataTask*)DELETE:(NSString*)endPoint
             withCompletionBlock:(void (^)(BOOL success, NSError *error))completionBlock;

/*!
 @abstract A DELETE request with parameters.
 @discussion This will create a DELETE request with addition URL parameters to a given endpoint.

 @param endpoint The endpoint to which the request goes.
 @param urlParams Additional URL parameters of the request.

 @return A NSURLSessionDataTask will be returned.
 */
- (NSURLSessionDataTask*)DELETE:(NSString*)endPoint
              withURLParameters:(NSDictionary*)urlParams
             andCompletionBlock:(void (^)(BOOL success, NSError *error))completionBlock;

/*!
 @abstract A Generic HTTP Method.
 @discussion This is a generic method to create a HTTP Call.
 
 @param method The HTTP Method.
 @param endpoint The endpoint to which the request goes.
 @param urlParams Additional URL parameters of the request.
 @param bodyObject The payload of the request.
 
 @return A NSURLSessionDataTask will be returned.
 */
- (NSURLSessionDataTask*)makeRequestWithHTTPMethod:(NSString*)method
                                        atEndPoint:(NSString*)endPoint
                                 withURLParameters:(NSDictionary*)urlParams
                                        andPayload:(NSDictionary*)bodyObject
                                andCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock;

@end
