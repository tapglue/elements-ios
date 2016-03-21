//
//  TGEvent+Networking.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 08/06/15.
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

#import "TGEvent+Networking.h"
#import "Tapglue+Private.h"
#import "TGEventManager.h"
#import "NSError+TGError.h"

@implementation TGEvent (Networking)

- (void)saveWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    if ([self checkCurrentUserHasPermissionWithCompletionBlock:completionBlock]) {
        [[Tapglue sharedInstance].eventManager updateEvent:self withCompletionBlock:completionBlock];
    }
}

- (void)deleteWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    if ([self checkCurrentUserHasPermissionWithCompletionBlock:completionBlock]) {
        [[Tapglue sharedInstance].eventManager deleteEventWithId:self.eventId withCompletionBlock:completionBlock];
    }
}

- (BOOL)checkCurrentUserHasPermissionWithCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    if (!self.user.isCurrentUser) {
        if (completionBlock) {
            completionBlock(NO, [self noPermissionError]);
        }
        return NO;
    }
    return YES;
}

- (NSError*)noPermissionError {
    return [NSError tg_errorWithCode:kTGErrorNoPermission
                            userInfo:@{
                                       NSLocalizedDescriptionKey : @"No permission to change other users' events.",
                                       NSLocalizedFailureReasonErrorKey : @"Only events of the current user can be updated or deleted."
                                       }];
}

@end
