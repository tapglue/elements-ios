//
//  TGQueryBuilder.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 07/12/15.
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


#import "TGQuery.h"

@interface TGQuery ()
@property (nonatomic, strong) NSMutableDictionary *mutableQuery;
@end

@implementation TGQuery

- (instancetype) init {
    self = [super init];
    if (self) {
        self.mutableQuery = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSDictionary*)query {
    return self.mutableQuery.copy;
}

- (NSString*)queryAsString {
    return [self.class stringFromQuery:self.mutableQuery];
}

+ (NSString*)stringFromQuery:(NSDictionary*)query {
    NSData *data = [NSJSONSerialization dataWithJSONObject:query options:kNilOptions error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}


#pragma mark - ObjectID

- (void)addObjectIdEquals:(NSString*)objectId {
    if (objectId) {
        [self addRequestCondition:@"eq" withValue:objectId forEventCondition:@"tg_object_id"];
    }
}

- (void)addObjectIdIn:(NSArray*)objectIds {
    if ([self validateArrayInput:objectIds]) {
        [self addRequestCondition:@"in" withValue:objectIds forEventCondition:@"tg_object_id"];
    }
}


#pragma mark - Type

- (void)addTypeEquals:(NSString*)type {
    if (type) {
        [self addRequestCondition:@"eq" withValue:type forEventCondition:@"type"];
    }
}

- (void)addTypeIn:(NSArray*)types {
    if ([self validateArrayInput:types]) {
        [self addRequestCondition:@"in" withValue:types forEventCondition:@"type"];
    }
}


#pragma mark - Object.ID

- (void)addEventObjectWithIdEquals:(NSString*)objectId {
    if (objectId) {
        [self addRequestCondition:@"eq" withValue:objectId forEventCondition:@"object.id"];
    }
}

- (void)addEventObjectWithIdIn:(NSArray*)objectIds {
    if ([self validateArrayInput:objectIds]) {
        [self addRequestCondition:@"in" withValue:objectIds forEventCondition:@"object.id"];
    }
}



#pragma mark - Private

/*!
 @abstract Adds a new condtion to the query.
 @discussion Conditions are resolve to a nested json structure.
 @param requestCondition RequestCondition specifies the type for filtering for the fields.
 @param eventCondition EventCondition specifies the evnet field to be filtered. It can also be passed in as a keyPath seperated by a period for conditions effecting event properties.
 */
- (void)addRequestCondition:(NSString*)requestCondition withValue:(id)value forEventCondition:(NSString*)eventCondition {
    NSDictionary *conditionJson = [self jsonDictionaryForRequestCondition:requestCondition withValue:value];
    NSArray *eventCompontents = [eventCondition componentsSeparatedByString:@"."];
    for (NSUInteger i = eventCompontents.count-1; i > 0; i--) {
        conditionJson = @{eventCompontents[i] : conditionJson};
    }
    [self.mutableQuery setValue:conditionJson forKeyPath:eventCompontents.firstObject];
}


- (NSDictionary*)jsonDictionaryForRequestCondition:(NSString*)requestCondition withValue:(id)value {
    if ([requestCondition isEqualToString:@"eq"]) {
        return @{requestCondition: value};
    }
    if ([requestCondition isEqualToString:@"in"]) {
        NSAssert([value isKindOfClass:[NSArray class]], @"value must be an array for requestCondition 'in'");
        return @{requestCondition: value};
    }
    
    NSAssert(false, @"unsupported requestCondition '%@'", requestCondition);
    return nil;
}

#pragma mark - Validate inputs 

- (BOOL)validateArrayInput:(NSArray*)array {
    if (array && array.count > 0) {
        return YES;
    }
    return NO;
}

@end
