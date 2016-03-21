//
//  TGEventObject.m
//  Tapglue iOS SDK
//
//  Created by Onur Akpolat on 03/06/15.
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

#import "TGEventObject.h"
#import "TGObject+Private.h"
#import "TGUser+Private.h"
#import "TGModelObject+Private.h"

@interface TGEventObject ()
@property (nonatomic, strong) NSMutableDictionary *displayNames;
@end

@implementation TGEventObject

@dynamic objectId;
@synthesize displayNames = _displayNames;

- (instancetype)initWithDictionary:(NSDictionary *)data {
    self = [super initWithDictionary:data];
    
    if ([self.type isEqualToString:@"tg_user"]) {
        self.user = [TGUser objectWithId:self.objectId];
    }
    
    return self;
}

- (NSDictionary*)jsonMapping {
    return @{
             @"type" : @"type",
             @"url" : @"url",
             @"display_names" : @"displayNames"
             };
}

- (NSDictionary*)jsonDictionary {
    NSMutableDictionary *mapping = self.jsonMapping.mutableCopy;
    [mapping setValue:@"objectId" forKey:TGModelObjectIdJsonKey];
    return [self dictionaryWithMapping:mapping];
}

- (NSMutableDictionary*)displayNames {
    if (!_displayNames) {
        _displayNames = [NSMutableDictionary dictionary];
    }
    return _displayNames;
}

- (void)setDisplayNames:(NSMutableDictionary *)displayNames {
    if ([displayNames isKindOfClass:[NSDictionary class]]) {
        _displayNames = displayNames.mutableCopy;
    } else {
        _displayNames = displayNames;
    }
}

- (NSString*)displayNameForLanguage:(NSString*)language {
    NSString *displayName = [self.displayNames objectForKey:language];
    if (!displayName) {
        displayName = [self.displayNames objectForKey:@"en"];
    }
    return displayName;
}

- (NSString*)displayNameForDeviceLanguage {
    NSString *deviceLanguage = [NSLocale preferredLanguages].firstObject;
    return [self displayNameForLanguage:deviceLanguage];
}

- (void)setDisplayName:(NSString*)displayName forLanguage:(NSString*)language {
    [self.displayNames setObject:displayName forKey:language];
}

@end
