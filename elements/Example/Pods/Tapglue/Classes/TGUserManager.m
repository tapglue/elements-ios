//
//  TGUserManager.m
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

#import "TGUserManager.h"
#import "TGApiClient.h"
#import "TGUser.h"
#import "TGModelObject+Private.h"
#import "Tapglue+Private.h"
#import "TGUser+Private.h"
#import "NSError+TGError.h"
#import "TGObjectCache.h"
#import "TGConnection+Private.h"
#import "TGAPIRoutesBuilder.h"

NSString *const TapglueUserDefaultsKeySessionToken = @"sessionToken";
NSString *const TGUserManagerAPIEndpointCurrentUser = @"me";
NSString *const TGUserManagerAPIEndpointUsers = @"users";

#define TGUserManagerAPIEndpointSearch [TGUserManagerAPIEndpointUsers stringByAppendingPathComponent:@"search"]

static NSString *const TGUserManagerAPIEndpointConnections = @"me/connections";

@implementation TGUserManager

#pragma mark - Current User

- (void)createAndLoginUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client POST:TGUserManagerAPIEndpointUsers withURLParameters:nil andPayload:user.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleLoginResponse:jsonResponse
                        withError:error
                      requestUser:user
               andCompletionBlock:completionBlock];
    }];
}

- (void)updateUser:(TGUser*)user withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client PUT:TGUserManagerAPIEndpointCurrentUser withURLParameters:nil andPayload:user.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {

        if (jsonResponse && !error) {
            [user loadDataFromDictionary:jsonResponse];
        }

        if (completionBlock) {
            completionBlock(error == nil, error);
        }
    }];
}

- (void)deleteCurrentUserWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    [self.client DELETE:TGUserManagerAPIEndpointCurrentUser withCompletionBlock:^(BOOL success, NSError *error) {
        [self handleLogoutResponse:success withError:error andCompletionBlock:completionBlock];
    }];
}


- (void)loginWithUsernameOrEmail:(NSString *)usernameOrEmail
                     andPassword:(NSString *)password
             withCompletionBlock:(TGSucessCompletionBlock)completionBlock {

    NSDictionary *loginData = @{@"username": usernameOrEmail,
                                @"password": [TGUser hashPassword:password]};

    NSString *route = [TGUserManagerAPIEndpointCurrentUser stringByAppendingPathComponent:@"login"];
    
    [self.client POST:route withURLParameters:nil andPayload:loginData andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleLoginResponse:jsonResponse
                        withError:error
                      requestUser:nil
               andCompletionBlock:completionBlock];
    }];
}

- (void)loginWithUsernameOrEmail:(NSString *)usernameOrEmail
                     andUnhashedPassword:(NSString *)password
             withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    
    NSDictionary *loginData = @{@"username": usernameOrEmail,
                                @"password": password};
    
    NSString *route = [TGUserManagerAPIEndpointCurrentUser stringByAppendingPathComponent:@"login"];
    
    [self.client POST:route withURLParameters:nil andPayload:loginData andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleLoginResponse:jsonResponse
                        withError:error
                      requestUser:nil
               andCompletionBlock:completionBlock];
    }];
}

- (void)retrieveCurrentUserWithCompletionBlock:(TGGetUserCompletionBlock)completionBlock {
    [self.client GET:TGUserManagerAPIEndpointCurrentUser withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleSingleUserResponse:jsonResponse forCurrentUser:YES withError:error andCompletionBlock:completionBlock];
    }];
}

- (void)logoutWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    NSString *route = [TGUserManagerAPIEndpointCurrentUser stringByAppendingPathComponent:@"logout"];
    [self.client DELETE:route withCompletionBlock:^(BOOL success, NSError *error) {
        [self handleLogoutResponse:success withError:error andCompletionBlock:completionBlock];
    }];
}

#pragma mark  - Other users

- (void)retrieveUserWithId:(NSString*)userId withCompletionBlock:(TGGetUserCompletionBlock)completionBlock {
    NSString *route = [TGUserManagerAPIEndpointUsers stringByAppendingPathComponent:userId];
    [self.client GET:route withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleSingleUserResponse:jsonResponse forCurrentUser:NO withError:error andCompletionBlock:completionBlock];
    }];
}

- (void)searchUsersWithSearchString:(NSString*)searchString
                 andCompletionBlock:(TGGetUserListCompletionBlock)completionBlock {
    [self.client GET:TGUserManagerAPIEndpointSearch withURLParameters:@{@"q" : searchString} andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleUserListResponse:jsonResponse withError:error andCompletionBlock:completionBlock];
    }];
}

- (void)searchUsersWithEmails:(NSArray*)emails andCompletionBlock:(TGGetUserListCompletionBlock)completionBlock {
    NSDictionary *payload = @{
                              @"emails" : emails
                              };
    [self.client POST:[TGUserManagerAPIEndpointSearch stringByAppendingPathComponent:@"emails"] withURLParameters: nil andPayload: payload andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleUserListResponse:jsonResponse withError:error andCompletionBlock:completionBlock];
    }];
}

- (void)searchUsersOnSocialPlatform:(NSString*)socialPlatform
                 withSocialUsersIds:(NSArray*)socialUserIds
                 andCompletionBlock:(TGGetUserListCompletionBlock)completionBlock {
    
    NSString *queryString = [socialUserIds componentsJoinedByString:@"&socialid="];
    NSDictionary *urlParams = @{@"social_platform": socialPlatform,
                                @"socialid" : queryString};

    [self.client GET:TGUserManagerAPIEndpointSearch withURLParameters:urlParams andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleUserListResponse:jsonResponse withError:error andCompletionBlock:completionBlock];
    }];
}


#pragma mark   Helper - Handlers

- (void)handleLoginResponse:(NSDictionary*)jsonResponse
                  withError:(NSError*)responseError
                requestUser:(TGUser*)requestUser
         andCompletionBlock:(TGSucessCompletionBlock)completionBlock {

    if (!responseError) {
        TGUser *currentUser;
        if (requestUser) {
            [requestUser loadDataFromDictionary:jsonResponse];
            [[TGUser cache] addObject:requestUser];
            currentUser = requestUser;
        }
        else {
            currentUser = [TGUser createOrLoadWithDictionary:jsonResponse];
        }

        NSString *sessionToken = [jsonResponse valueForKey:@"session_token"];
        NSAssert(sessionToken, @"Login should return a session token.");  // ToDo: proper error handling if no session token was returned

        [[Tapglue sharedInstance].userDefaults setObject:sessionToken forKey:TapglueUserDefaultsKeySessionToken];
        self.client.sessionToken = sessionToken;

        [TGUser setCurrentUser:currentUser];


        if (completionBlock) {
            completionBlock(YES, nil);
        }
    }
    else if (completionBlock) {
        completionBlock(NO, responseError);
    }

}

- (void)handleLogoutResponse:(BOOL)success withError:(NSError*)responseError andCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    if (!success) {
        TGLog(@"Logout from server failed");
    }
    
    [self clearCurrentUserData];

    if (completionBlock) {
        completionBlock(success, responseError);
    }
}

- (void)handleSingleUserResponse:(NSDictionary*)jsonResponse forCurrentUser:(BOOL)isCurrentUser withError:(NSError*)responseError andCompletionBlock:(TGGetUserCompletionBlock)completionBlock {
    if (jsonResponse && !responseError) {
        TGUser *user = [[TGUser alloc] initWithDictionary:jsonResponse];
        if (isCurrentUser) {
            [TGUser setCurrentUser:user];
        }
        if (completionBlock) {
            completionBlock(user, nil);
        }
    }
    else if (completionBlock) {
        completionBlock(nil, responseError);
    }
}

- (void)handleUserListResponse:(NSDictionary*)jsonResponse withError:(NSError*)responseError andCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {
    if (completionBlock) {
        if (!responseError) {
            NSArray *users = [TGUser createAndCacheObjectsFromDictionaries:[jsonResponse objectForKey:@"users"]];
            completionBlock(users, nil);
        } else {
            completionBlock(nil, responseError);
        }
    }
}

#pragma mark - Connections

- (void)retrieveConnectedUsersOfConnectionType:(TGConnectionType)connectionType
                                       forUser:(TGUser*)user
                           withCompletionBlock:(void (^)(NSArray *users, NSError *error))completionBlock {

    NSString *apiEndpoint = user ? [TGUserManagerAPIEndpointUsers stringByAppendingPathComponent:user.userId] : TGUserManagerAPIEndpointCurrentUser;

    switch (connectionType) {
        case TGConnectionTypeFriend:
            apiEndpoint = [apiEndpoint stringByAppendingPathComponent:@"friends"];
            break;
        case TGConnectionTypeFollow:
            apiEndpoint = [apiEndpoint stringByAppendingPathComponent:@"follows"];
            break;
        case TGConnectionTypeFollowers:
            apiEndpoint = [apiEndpoint stringByAppendingPathComponent:@"followers"];
            break;
        default:
            break;
    }

    [self.client GET:apiEndpoint withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleUserListResponse:jsonResponse withError:error andCompletionBlock:completionBlock];
    }];

}

- (void)retrieveConnectionsForCurrentUserOfState:(TGConnectionState)connectionState
                             withCompletionBlock:(void (^)(NSArray *incoming, NSArray *outgoing, NSError *error))completionBlock {
 
    NSString *route = [TGUserManagerAPIEndpointConnections stringByAppendingPathComponent:[TGConnection stringForConnectionState:connectionState]];
    
    [self.client GET:route withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            if (!error) {
                [TGUser createAndCacheObjectsFromDictionaries:[jsonResponse objectForKey:@"users"]];
                
                NSMutableArray *incomingConnections = [NSMutableArray new];
                for (NSDictionary *objectDict in [jsonResponse objectForKey:@"incoming"]) {
                    [incomingConnections addObject:[[TGConnection alloc] initWithDictionary:objectDict]];
                }

                NSMutableArray *outgoingConnections = [NSMutableArray new];
                for (NSDictionary *objectDict in [jsonResponse objectForKey:@"outgoing"]) {
                    [outgoingConnections addObject:[[TGConnection alloc] initWithDictionary:objectDict]];
                }
                
                completionBlock(incomingConnections, outgoingConnections, nil);
            } else {
                completionBlock(nil, nil, error);
            }
        }
    }];
}

- (void)createSocialConnectionsForCurrentUserOnPlatformWithSocialIdKey:(NSString*)socialIdKey
                                                                ofType:(TGConnectionType)connectionType
                                                      toSocialUsersIds:(NSArray*)toSocialUsersIds
                                                   withCompletionBlock:(TGSucessCompletionBlock)completionBlock {

    NSString *ownSocialId = [[TGUser currentUser] socialIdForKey:socialIdKey];
    if (!ownSocialId) {
        if (completionBlock) {
            completionBlock(NO, [NSError tg_errorWithCode:kTGErrorNoSocialIdForPlattform userInfo:nil]);
        }
        return;
    }

    NSMutableArray *toSocialUsersIdsAsStrings = [NSMutableArray arrayWithCapacity:toSocialUsersIds.count];
    [toSocialUsersIds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [toSocialUsersIdsAsStrings addObject:obj];
        }
        else {
            [toSocialUsersIdsAsStrings addObject:[obj description]];
        }
    }];

    NSDictionary *connectionsData = @{
                                      @"platform" : socialIdKey,
                                      @"type" : [self stringFromConnectionType:connectionType],
                                      @"platform_user_id" : ownSocialId,
                                      @"connection_ids" : toSocialUsersIdsAsStrings
                                      };
    
    NSString *route = [TGUserManagerAPIEndpointConnections stringByAppendingPathComponent:@"social"];

    [self.client POST:route withURLParameters:nil andPayload:connectionsData andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            if (jsonResponse && !error) {
                completionBlock(YES, nil);
            }
            else {
                completionBlock(NO, error);
            }
        }
    }];
}

- (void)createConnectionOfType:(TGConnectionType)connectionType
                        toUser:(TGUser*)toUser
                      andState:(TGConnectionState)connectionState
           withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    
    if (!toUser.userId) {
        if (completionBlock) {
            NSDictionary *errorInfo = @{NSLocalizedDescriptionKey : @"The give toUser was either `nil` or has no userId." };
            completionBlock(NO, [NSError tg_errorWithCode:kTGErrorInconsistentData userInfo:errorInfo]);
        }
        return;
    }

    NSDictionary *connectionData = @{
                                     @"user_to_id" : [[[NSNumberFormatter alloc] init] numberFromString:toUser.userId] ?: @(0),
                                     @"type" : [self stringFromConnectionType:connectionType],
                                     @"state" : [TGConnection stringForConnectionState:connectionState]
                                     };
    
    [self.client PUT:TGUserManagerAPIEndpointConnections withURLParameters:nil andPayload:connectionData andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            if (jsonResponse && !error) {
                completionBlock(YES, nil);
            }
            else {
                completionBlock(NO, error);
            }
        }
    }];
}

- (void)deleteConnectionOfType:(TGConnectionType)connectionType
                        toUser:(TGUser*)toUser
           withCompletionBlock:(TGSucessCompletionBlock)completionBlock {    
    NSString *route = TGUserManagerAPIEndpointConnections;
    route = [route stringByAppendingPathComponent:[self stringFromConnectionType:connectionType]];
    route = [route stringByAppendingPathComponent:toUser.userId];
    [self.client DELETE:route withURLParameters:nil andCompletionBlock:completionBlock];
}

#pragma mark - Recommendations

- (void)retrieveUserRecommendationsOfType:(NSString*)type forPeriod:(NSString*)period andCompletionBlock:(TGGetUserListCompletionBlock)completionBlock {
    NSString *route = [TGApiRoutesBuilder routeForUserRecommendationsOfType:type andPeriod:period];
    [self.client GET:route withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleUserListResponse:jsonResponse withError:error andCompletionBlock:completionBlock];
    }];
}

#pragma mark - Helper

- (NSString*)stringFromConnectionType:(TGConnectionType)connectionType {
    return connectionType == TGConnectionTypeFriend ? @"friend" : @"follow";
}

- (void)clearCurrentUserData {
    [TGUser setCurrentUser:nil];
    NSUserDefaults *tgUserDefaults = [Tapglue sharedInstance].userDefaults;
    [tgUserDefaults removeObjectForKey:TapglueUserDefaultsKeySessionToken];
    [tgUserDefaults synchronize];
}

@end
