//
//  TGConnection.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 07.12.2015.
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

#import "TGConnection.h"
#import "TGUser+Private.h"
#import "TGModelObject+Private.h"
#import "NSDateFormatter+TGISOFormatter.h"

@implementation TGConnection

- (instancetype)initWithDictionary:(NSDictionary*)data {
    if ([data isKindOfClass:[NSNull class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _fromUser = [TGUser objectWithId:[[data valueForKey:@"user_from_id"] stringValue]];
        _toUser = [TGUser objectWithId:[[data valueForKey:@"user_to_id"] stringValue]];
        _state = [self.class connectionStateFromString:[data valueForKey:@"state"]];
        NSDateFormatter *formatter = [NSDateFormatter tg_isoDateFormatter];
        _createdAt = [formatter dateFromString:[data valueForKey:TGModelObjectCreatedAtJsonKey]];
    }
    return self;
}

+ (NSString*)stringForConnectionState:(TGConnectionState)connectionState {
    switch (connectionState) {
        case TGConnectionStatePending:
            return @"pending";
        case TGConnectionStateConfirmed:
            return @"confirmed";
        case TGConnectionStateRejected:
            return @"rejected";
        default:
            NSAssert(false, @"unknown TGConnectionState");
            break;
    }
}

+ (TGConnectionState)connectionStateFromString:(NSString*)string {
    if ([string isEqualToString:@"pending"]) {
        return TGConnectionStatePending;
    }
    if ([string isEqualToString:@"confirmed"]) {
        return TGConnectionStateConfirmed;
    }
    if ([string isEqualToString:@"rejected"]) {
        return TGConnectionStateRejected;
    }
    NSAssert(false, @"Unsupported connection state: %@", string);
    return 0;
}

@end
