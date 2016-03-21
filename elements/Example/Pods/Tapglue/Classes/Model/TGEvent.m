//
//  TGEvent.m
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

#import "TGEvent.h"
#import "TGUser.h"
#import "TGModelObject+Private.h"
#import "TGEventObject.h"
#import "NSDictionary+TGUtilities.h"
#import "TGObjectCache.h"
#import "NSDateFormatter+TGISOFormatter.h"
#import "TGImage+Private.h"

static NSString *const TGEventUserIdJsonKey = @"user_id";
static NSString *const TGEventTypeJsonKey = @"type";
static NSString *const TGEventImagesJsonKey = @"images";
static NSString *const TGEventObjectKey = @"object";
static NSString *const TGEventTargetKey = @"target";

@implementation TGEvent

#pragma mark - Init & Cache

+ (instancetype)createOrLoadWithDictionary:(NSDictionary*)eventData {
    TGObjectCache *cache = [self cache];
    TGEvent *event = [cache objectWithObjectId:[eventData tg_stringValueForKey:TGModelObjectIdJsonKey]];
    if (!event) {
        event = [[TGEvent alloc] initWithDictionary:eventData];
        if (event) { // user will be nil if the userData is invalid
            [cache addObject:event];
        }
    } else {
        [event loadDataFromDictionary:eventData];
    }
    return event;
}

- (instancetype)initWithDictionary:(NSDictionary*)eventData {
    if (![self.class isValidEventData:eventData]) {
        return nil;
    }
    self = [super initWithDictionary:eventData];
    if (self) {
        // all field defined in the mapping are already set by the super class
        self.user = [TGUser objectWithId:[eventData tg_stringValueForKey:TGEventUserIdJsonKey]];
        self.object = [[TGEventObject alloc] initWithDictionary:[eventData objectForKey:@"object"]];
        self.target = [[TGEventObject alloc] initWithDictionary:[eventData objectForKey:@"target"]];
    }
    return self;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.latitude = NAN;
        self.longitude = NAN;
        // Set default visibility to connections
        self.visibility = TGVisibilityConnection;
    }
    return self;
}

+ (BOOL)isValidEventData:(NSDictionary*)data {
    return ([data tg_hasNumberValueForKey:TGModelObjectIdJsonKey]
            && [data tg_hasNumberValueForKey:TGEventUserIdJsonKey]
            && [data tg_hasStringValueForKey:TGEventTypeJsonKey]);
}

- (NSString*)eventId {
    return super.objectId;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@: %@=%@, %@>",
            NSStringFromClass(self.class),
            TGModelObjectIdJsonKey, self.eventId,
            [NSString stringWithFormat:@"%@ %@ %@", self.user.username, self.type, self.object]
            ];
}


#pragma mark Images

- (NSMutableDictionary*)images {
    if (_images==nil) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

#pragma mark - JSON Parsing

- (void)loadDataFromDictionary:(NSDictionary *)data withMapping:(NSDictionary *)mapping {
    [super loadDataFromDictionary:data withMapping:mapping];
    self.images = [TGImage convertImagesFromDictionary:self.images];
}

- (NSDictionary*)jsonDictionary {
    NSMutableDictionary *dictFromMapping = [self dictionaryWithMapping:[self jsonMappingForWriting]];
    if (self.object) {  [dictFromMapping tg_setValueOrNull:self.object.jsonDictionary forKey:TGEventObjectKey]; }
    if (self.target) {  [dictFromMapping tg_setValueOrNull:self.target.jsonDictionary forKey:TGEventTargetKey]; }
    if (self.user) { [dictFromMapping tg_setValueOrNull:self.user.userId forKey:TGEventUserIdJsonKey]; }
    if (self.createdAt) {
        NSDateFormatter *df = [NSDateFormatter tg_isoDateFormatter];
        [dictFromMapping  tg_setValueOrNull:[df stringFromDate:self.createdAt] forKey:TGModelObjectCreatedAtJsonKey];
    }
    [dictFromMapping tg_setValueIfNotNil:[TGImage jsonDictionaryForImagesDictionary:self.images] forKey:TGEventImagesJsonKey];
    return dictFromMapping;
}

- (NSDictionary*)jsonMapping {
    static NSDictionary *mapping;
    if (!mapping) {
        mapping = [self jsonMappingForReading];
    }
    return mapping;
}

- (NSDictionary*)jsonMappingForWriting {
    // left side: json attribute name , right side: model property name
    return @{
             @"type" : @"type",
             @"language" : @"language",
             @"priority" : @"priority",
             @"location" : @"location",
             @"latitude" : @"latitude",
             @"longitude" : @"longitude",
             @"visibility" : @"visibility",
             @"metadata" : @"metadata",
             @"tg_object_id" : @"tgObjectId"
             };
}

- (NSDictionary*)jsonMappingForReading {
    NSMutableDictionary *mapping = [self jsonMappingForWriting].mutableCopy;
    [mapping addEntriesFromDictionary:@{
                                        TGEventImagesJsonKey : @"images"
                                        }];
    return mapping;
}


#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.objectId];
    [aCoder encodeObject:self.language];
    [aCoder encodeObject:self.location];
    [aCoder encodeFloat:self.latitude forKey:@"latitude"];
    [aCoder encodeFloat:self.longitude forKey:@"longitude"];
    [aCoder encodeInteger:self.visibility forKey:@"visibility"];
    [aCoder encodeObject:self.priority];
    [aCoder encodeObject:self.type];
    [aCoder encodeObject:self.images];
    [aCoder encodeObject:self.object.jsonDictionary forKey:@"object"];
    [aCoder encodeObject:self.target.jsonDictionary forKey:@"target"];
    [aCoder encodeObject:self.user.jsonDictionary forKey:@"user"];
    [aCoder encodeObject:self.tgObjectId];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.objectId = [aDecoder decodeObject];
        self.language = [aDecoder decodeObject];
        self.location = [aDecoder decodeObject];
        self.latitude = [aDecoder decodeFloatForKey:@"latitude"];
        self.longitude = [aDecoder decodeFloatForKey:@"longitude"];
        self.visibility = [aDecoder decodeIntegerForKey:@"visibility"];
        self.priority = [aDecoder decodeObject];
        self.type = [aDecoder decodeObject];
        self.images = [aDecoder decodeObject];
        self.object = [[TGEventObject alloc] initWithDictionary:[aDecoder decodeObjectForKey:@"object"]];
        self.target = [[TGEventObject alloc] initWithDictionary:[aDecoder decodeObjectForKey:@"target"]];
        self.user = [TGUser createOrLoadWithDictionary:[aDecoder decodeObjectForKey:@"user"]];
        self.tgObjectId = [aDecoder decodeObject];
    }
    return self;
}

@end
