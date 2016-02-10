//
//  TGApiClient.m
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

#import "TGApiClient.h"
#import "TGConstants.h"
#import "NSURL+TGUtilities.h"
#import "TGLogger.h"
#import "TGConfiguration.h"
#import "NSThread+TGEnsureMainThread.h"
#import "NSError+TGError.h"
#import "UIDevice+TGUtilities.h"
#import "Tapglue.h"
#import "NSDictionary+TGUtilities.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#ifdef TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

NSString *const TGApiEndpointEvents = @"events";
NSString *const TGApiEndpointUsers = @"users";
NSString *const TGApiEndpointCurrentUser = @"me";

static NSString *const TGApiClientAppAndDeviceInfoAppNameKey = @"appName";
static NSString *const TGApiClientAppAndDeviceInfoAppBunldeIdKey = @"appBundleId";
static NSString *const TGApiClientAppAndDeviceInfoAppVersionKey = @"appVersion";
static NSString *const TGApiClientAppAndDeviceInfoDeviceModel = @"deviceModel";
static NSString *const TGApiClientAppAndDeviceInfoDeviceID = @"deviceID";
static NSString *const TGApiClientAppAndDeviceInfoDeviceTimezone = @"deviceTimezone";
static NSString *const TGApiClientAppAndDeviceInfoOSVersion = @"deviceOsVersion";
static NSString *const TGApiClientAppAndDeviceInfoSDKVersion = @"sdkVersion";
static NSString *const TGApiClientAppAndDeviceInfoCarrier = @"carrier";

@interface TGApiClient ()
@property (nonatomic, readonly) NSURLSessionConfiguration *sessionConfig;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, assign) BOOL shouldToggleNetworkActivityIndicator;
@property (nonatomic, strong, readonly) NSURL *apiBaseUrl;
@property (nonatomic, strong, readonly) NSURL *apiUrlWithVersion;

- (NSURLSessionDataTask*)makeRequestWithHTTPMethod:(NSString*)method
                                        atEndPoint:(NSString*)endPoint
                                 withURLParameters:(NSDictionary*)urlParams
                                        andPayload:(NSDictionary*)bodyObject
                                andCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock;
@end

@implementation TGApiClient

- (instancetype)initWithAppToken:(NSString*)token andConfig:(TGConfiguration*)config {
    self = [super init];
    if (self) {
        _appToken = token;
        _shouldToggleNetworkActivityIndicator = config.showNetworkActivityIndicator;
        _apiBaseUrl = [NSURL URLWithString:config.apiBaseUrl];
        _apiUrlWithVersion = [self.apiBaseUrl URLByAppendingPathComponent:config.apiVersion];
    }
    return self;
}

- (void)pingAnalyticsEndpoint {
    NSURL *url = [self.apiBaseUrl URLByAppendingPathComponent:@"analytics"];

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    // Headers
    NSDictionary *appAndDeviceInfo = [self appAndDeviceInfo];
    [request addValue:appAndDeviceInfo[TGApiClientAppAndDeviceInfoAppNameKey] forHTTPHeaderField:@"X-Tapglue-App"];
    [request addValue:appAndDeviceInfo[TGApiClientAppAndDeviceInfoAppVersionKey] forHTTPHeaderField:@"X-Tapglue-AppVersion"];
    [request addValue:appAndDeviceInfo[TGApiClientAppAndDeviceInfoCarrier] forHTTPHeaderField:@"X-Tapglue-Carrier"];
    [request addValue:@"Apple" forHTTPHeaderField:@"X-Tapglue-Manufacturer"];
    [request addValue:appAndDeviceInfo[TGApiClientAppAndDeviceInfoDeviceModel] forHTTPHeaderField:@"X-Tapglue-Model"];
    [request addValue:appAndDeviceInfo[TGApiClientAppAndDeviceInfoDeviceID] forHTTPHeaderField:@"X-Tapglue-IDFV"];
    [request addValue:@"iOS" forHTTPHeaderField:@"X-Tapglue-OS"];
    [request addValue:appAndDeviceInfo[TGApiClientAppAndDeviceInfoOSVersion] forHTTPHeaderField:@"X-Tapglue-OSVersion"];
    [request addValue:appAndDeviceInfo[TGApiClientAppAndDeviceInfoSDKVersion] forHTTPHeaderField:@"X-Tapglue-SDKVersion"];
    [request addValue:appAndDeviceInfo[TGApiClientAppAndDeviceInfoDeviceTimezone] forHTTPHeaderField:@"X-Tapglue-Timezone"];

    // Start a new Task
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSInteger httpStatusCode = ((NSHTTPURLResponse*)response).statusCode;
            TGLog(@"backend request finished with HTTP %ld on %@", httpStatusCode, response.URL);
        }
        else {
            // Failure
            TGLog(@"URL Session Task Failed: %@", [error localizedDescription]);
        }
    }];
    [task resume];
}

- (NSURLSessionDataTask*)GET:(NSString*)endPoint withCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock {
    return [self GET:endPoint withURLParameters:nil andCompletionBlock:completionBlock];
}

- (NSURLSessionDataTask*)GET:(NSString*)endPoint
           withURLParameters:(NSDictionary*)urlParams
          andCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock {

    return [self makeRequestWithHTTPMethod:@"GET"
                                atEndPoint:endPoint
                         withURLParameters:urlParams
                                andPayload:nil
                        andCompletionBlock:completionBlock];
}

- (NSURLSessionDataTask*)POST:(NSString*)endPoint
            withURLParameters:(NSDictionary*)urlParams
                   andPayload:(NSDictionary*)bodyObject
           andCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock {

    return [self makeRequestWithHTTPMethod:@"POST"
                                atEndPoint:endPoint
                         withURLParameters:urlParams
                                andPayload:bodyObject
                        andCompletionBlock:completionBlock];
}

- (NSURLSessionDataTask*)PUT:(NSString*)endPoint
           withURLParameters:(NSDictionary*)urlParams
                  andPayload:(NSDictionary*)bodyObject
          andCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock {

    return [self makeRequestWithHTTPMethod:@"PUT"
                                atEndPoint:endPoint
                         withURLParameters:urlParams
                                andPayload:bodyObject
                        andCompletionBlock:completionBlock];
}

- (NSURLSessionDataTask*)DELETE:(NSString*)endPoint withCompletionBlock:(void (^)(BOOL success, NSError *error))completionBlock {
    return [self DELETE:endPoint withURLParameters:nil andCompletionBlock:completionBlock];
}

- (NSURLSessionDataTask*)DELETE:(NSString*)endPoint
      withURLParameters:(NSDictionary*)urlParams
             andCompletionBlock:(void (^)(BOOL success, NSError *error))completionBlock {

    return [self makeRequestWithHTTPMethod:@"DELETE"
                                atEndPoint:endPoint
                         withURLParameters:urlParams
                                andPayload:nil
                        andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
                            if (completionBlock) {
                                BOOL success = jsonResponse == nil && error == nil;
                                completionBlock(success, error);
                            }
                        }];
}

- (NSURLSessionDataTask*)makeRequestWithHTTPMethod:(NSString*)method
                                        atEndPoint:(NSString*)endPoint
                                 withURLParameters:(NSDictionary*)urlParams
                                        andPayload:(NSDictionary*)bodyObject
                                andCompletionBlock:(void (^)(NSDictionary *jsonResponse, NSError *error))completionBlock {

    // Checks
    if ([method isEqualToString:@"GET"]) {
        NSAssert(!bodyObject, @"GET request should not have any payload");
    }

    NSURL *url = [self.apiUrlWithVersion URLByAppendingPathComponent:endPoint];

    if (urlParams) {
        url = [url tg_URLByAppendingQueryParameters:urlParams];
    }

    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = method;

    // JSON Body & Header
    if (bodyObject) {
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:bodyObject options:kNilOptions error:NULL]; // ToDo: error handling for json parsing
    }

    [self setNetworkActivityIndicatorVisible:YES];

    // Start a new Task
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            [self setNetworkActivityIndicatorVisible:NO];

            NSInteger httpStatusCode = ((NSHTTPURLResponse*)response).statusCode;
            if (httpStatusCode < 400) {
                TGLog(@"backend request finished with HTTP %ld on %@", httpStatusCode, response.URL);
            }
            else {
                NSString *responsePayload = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                TGLog(@"backend request finished with HTTP %ld on %@ \n\t\n%@\n", httpStatusCode, response.URL, responsePayload);
            }

            NSError *error;
            NSError *jsonError;
            NSDictionary *jsonObject;
            if (data.length > 0) {
                jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            }

            if (jsonError) {
                TGLog(@"Error: Failed to parse json: \n%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                error = jsonError;
            }

            if (httpStatusCode >= 400) {
                if (jsonObject && !jsonError) {
                    if ([jsonObject isKindOfClass:[NSArray class]]) {
                        jsonObject = ((NSArray*)jsonObject).firstObject;
                    }
                    error = [self errorFromJsonResponse:jsonObject withHTTPStatus:httpStatusCode];
                } else if (jsonError) {
                    error = [NSError tg_errorWithCode:kTGErrorUnknownError
                                             userInfo:@{ NSUnderlyingErrorKey : jsonError,
                                                         NSLocalizedDescriptionKey : @"backend request finished with error response without valid json payload",
                                                         TGErrorHTTPStatusCodeKey : [NSNumber numberWithInteger:httpStatusCode] }];
                }
            }

            if (completionBlock) {
                completionBlock(jsonObject, error);
            }

        }
        else {
            // Failure
            NSLog(@"URL Session Task Failed: %@", [error localizedDescription]);
            if (completionBlock) {
                completionBlock(nil, error);
            }

        }

    }];
    [task resume];

    return task;
}

- (NSError*)errorFromJsonResponse:(NSDictionary*)jsonResponse withHTTPStatus:(NSInteger)httpStatusCode  {
    NSError *error;
    NSDictionary *errorDictionary = @{ TGErrorHTTPStatusCodeKey : [NSNumber numberWithInteger:httpStatusCode] };

    NSArray *jsonErrors = [jsonResponse objectForKey:@"errors"];
    
    if (jsonErrors.count == 0 || ![jsonErrors isKindOfClass:[NSArray class]]) {
        error = [NSError tg_errorWithCode:kTGErrorUnknownError userInfo:errorDictionary];
    } else if (jsonErrors.count == 1) {
        error = [NSError tg_errorFromJsonDicitonary:jsonErrors.firstObject withUserInfo:errorDictionary];
    } else {
        NSMutableArray *underlyingErrors = [NSMutableArray array];
        for (NSDictionary *errorDict in jsonErrors) {
            [underlyingErrors addObject:[NSError tg_errorFromJsonDicitonary:errorDict]];
        }
        NSMutableDictionary *errorUserInfo = [NSMutableDictionary dictionaryWithDictionary:errorDictionary];
        [errorUserInfo setObject:underlyingErrors forKey:TGErrorUnderlyingErrorsKey];
        [errorUserInfo setObject:@"Multiple errors occured. See userInfos[TGErrorUnderlyingErrorsKey]" forKey:NSLocalizedDescriptionKey];
        error = [NSError tg_errorWithCode:kTGErrorMultipleErrors userInfo:errorUserInfo];
    }
    
    return error;
}

- (NSURLSessionConfiguration*) sessionConfig {
    NSString *userPasswordString = [NSString stringWithFormat:@"%@:%@", self.appToken, self.sessionToken ?: @""];
    NSData * userPasswordData = [userPasswordString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64EncodedCredential = [userPasswordData base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic %@", base64EncodedCredential];

    NSDictionary *appAndDeviceInfo = [self appAndDeviceInfo];
    NSString *userAgentString = [NSString stringWithFormat:@"%@/%@; %@ (%@; iOS %@) Tapglue-SDK/%@",
                                 appAndDeviceInfo[TGApiClientAppAndDeviceInfoAppNameKey],
                                 appAndDeviceInfo[TGApiClientAppAndDeviceInfoAppBunldeIdKey],
                                 appAndDeviceInfo[TGApiClientAppAndDeviceInfoAppVersionKey],
                                 appAndDeviceInfo[TGApiClientAppAndDeviceInfoDeviceModel],
                                 appAndDeviceInfo[TGApiClientAppAndDeviceInfoOSVersion],
                                 appAndDeviceInfo[TGApiClientAppAndDeviceInfoSDKVersion]];

    // Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
    NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
    [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float q = 1.0f - (idx * 0.1f);
        [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
        *stop = q <= 0.5f;
    }];
    NSString *acceptLanguage = [acceptLanguagesComponents componentsJoinedByString:@", "];

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    config.HTTPAdditionalHeaders = @{@"Accept": @"application/json",
                                     @"Accept-Language": acceptLanguage,
                                     @"Authorization": authString,
                                     @"User-Agent": userAgentString,
                                     @"X-Tapglue-IDFV" : appAndDeviceInfo[TGApiClientAppAndDeviceInfoDeviceID]};

    config.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    config.URLCache =  [[NSURLCache alloc] initWithMemoryCapacity:40 * 1024 * 1024 // 40 MB
                                                     diskCapacity:80 * 1024 * 1024 // 80 MB
                                                         diskPath:@"tapglue.urlcache"];

    return config;
}

- (NSDictionary*)appAndDeviceInfo {
    NSBundle *mainBundle = [NSBundle mainBundle];

    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];

    [infoDict tg_setValueIfNotNil:([mainBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [mainBundle objectForInfoDictionaryKey:(__bridge NSString *)kCFBundleIdentifierKey]) forKey:TGApiClientAppAndDeviceInfoAppNameKey];
    [infoDict tg_setValueIfNotNil:([mainBundle objectForInfoDictionaryKey:@"CFBundleIdentifier"]) forKey:TGApiClientAppAndDeviceInfoAppBunldeIdKey];
    [infoDict tg_setValueIfNotNil:([NSString stringWithFormat:@"%@#%@", [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"], [mainBundle objectForInfoDictionaryKey:@"CFBundleVersion"]]) forKey:TGApiClientAppAndDeviceInfoAppVersionKey];
    [infoDict tg_setValueIfNotNil:([UIDevice currentDevice].identifierForVendor.UUIDString) forKey:TGApiClientAppAndDeviceInfoDeviceID];
    [infoDict tg_setValueIfNotNil:([[UIDevice currentDevice] tg_modelWithVersion]) forKey:TGApiClientAppAndDeviceInfoDeviceModel];
    [infoDict tg_setValueIfNotNil:([NSTimeZone localTimeZone].abbreviation) forKey:TGApiClientAppAndDeviceInfoDeviceTimezone];
    [infoDict tg_setValueIfNotNil:([[UIDevice currentDevice] systemVersion]) forKey:TGApiClientAppAndDeviceInfoOSVersion];
    [infoDict tg_setValueIfNotNil:([Tapglue version]) forKey:TGApiClientAppAndDeviceInfoSDKVersion];
    [infoDict tg_setValueIfNotNil:([[CTTelephonyNetworkInfo alloc] init].subscriberCellularProvider.carrierName) forKey:TGApiClientAppAndDeviceInfoCarrier];

    return infoDict;
}

- (void)setSessionToken:(NSString *)sessionToken {
    _sessionToken = sessionToken;
    self.session = nil; // release the old session so it will reload the config with the new session token on next use
}

- (NSURLSession*)session {
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[self sessionConfig] delegate:nil delegateQueue:nil];
    }
    return _session;
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)visible {
#ifdef TARGET_OS_IPHONE
    if (self.shouldToggleNetworkActivityIndicator) {
        [NSThread tg_runBlockOnMainThread:^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
        }];
    }
#endif
}

@end
