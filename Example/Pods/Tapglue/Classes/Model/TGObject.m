//
//  TGObject.m
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

#import "TGObject+Private.h"
#import "NSDateFormatter+TGISOFormatter.h"
#import "NSDictionary+TGUtilities.h"

NSString *const TGModelObjectIdJsonKey = @"id";

@interface TGObject ()
@property (nonatomic, strong, readwrite) NSString *objectId;
@end

@implementation TGObject


- (instancetype)initWithDictionary:(NSDictionary*)data {
    if ([data isKindOfClass:[NSNull class]]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _objectId = [data tg_stringValueForKey:TGModelObjectIdJsonKey];

        if ([self respondsToSelector:@selector(jsonMapping)]) {
            [self loadDataFromDictionary:data withMapping:[self jsonMapping]];
        }
    }
    return self;
}

- (NSDictionary*)jsonDictionary {
    if ([self respondsToSelector:@selector(jsonMappingForWriting)]) {
        return [self dictionaryWithMapping:[self jsonMappingForWriting]];
    }
    return [self dictionaryWithMapping:[self jsonMapping]];
}

- (void)loadDataFromDictionary:(NSDictionary *)data {
    _objectId = [data tg_stringValueForKey:TGModelObjectIdJsonKey];
    [self loadDataFromDictionary:data withMapping:[self jsonMapping]];
}

- (void)loadDataFromDictionary:(NSDictionary*)data withMapping:(NSDictionary*)mapping {
    [mapping enumerateKeysAndObjectsUsingBlock:^(id jsonKey, id objKey, BOOL *stop) {
        id dataValue = [data valueForKeyPath:jsonKey];
        if (dataValue) {
            [self setValue:dataValue forKey:objKey];
        }
    }];
}

- (NSMutableDictionary*)dictionaryWithMapping:(NSDictionary*)mapping {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [mapping enumerateKeysAndObjectsUsingBlock:^(id jsonKey, id objKey, BOOL *stop) {
        id objectValue = [self valueForKeyPath:objKey];
        if ([objectValue isKindOfClass:[NSURL class]]) {
            NSURL *urlValue = (NSURL*)objectValue;
            objectValue = urlValue.absoluteString;
        } else if([objectValue isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrayValue = ((NSArray*)objectValue).mutableCopy;
            for (NSUInteger i = 0; i < arrayValue.count; i++) {
                if ([arrayValue[i] isKindOfClass:[TGObject class]]) {
                    arrayValue[i] = [((TGObject*)arrayValue[i]) jsonDictionary];
                }
            }
            objectValue = arrayValue;
        }
        
        BOOL addValue = objectValue != nil;
        addValue &= ![objectValue isEqual:@{}];
        if (addValue && [objectValue isKindOfClass:[NSNumber class]]) {
            addValue &= ![objectValue isEqual:[NSNumber numberWithFloat:NAN]];
            addValue &= ![objectValue isEqual:[NSNumber numberWithInteger:NAN]];
        }
        if (addValue) {
            [dict setObject:objectValue forKey:jsonKey];
        }
    }];
    
    if (self.objectId) {
        [dict tg_setValueIfNotNil:[[[NSNumberFormatter alloc] init] numberFromString:self.objectId] forKey:TGModelObjectIdJsonKey];
    }
    
    return dict;
}


@end
