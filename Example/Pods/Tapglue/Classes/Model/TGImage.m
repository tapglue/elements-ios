//
//  TGImage.m
//  Tapglue iOS SDK
//
//  Created by Martin Stemmle on 29/09/15.
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


#import "TGImage.h"
#import "TGObject+Private.h"

@implementation TGImage

- (NSDictionary*)jsonMapping {
    return @{
             @"type" : @"type",
             @"url" : @"url"
             };
}

- (void)loadDataFromDictionary:(NSDictionary*)data withMapping:(NSDictionary*)mapping {
    [super loadDataFromDictionary:data withMapping:mapping];
    if ([data valueForKey:@"height"] && [data valueForKey:@"width"]) {
        int height = [[data valueForKey:@"height"] intValue];
        int width = [[data valueForKey:@"width"] intValue];
        self.size = CGSizeMake(width, height);
    }
}

- (NSDictionary*)jsonDictionary {
    NSMutableDictionary *mapping = self.jsonMapping.mutableCopy;
    NSMutableDictionary *jsonDictionary = [self dictionaryWithMapping:mapping];
    if (!CGSizeEqualToSize(self.size, CGSizeZero)) {
        [jsonDictionary setValue:[NSNumber numberWithInt:(int)roundf(self.size.height)] forKey:@"height"];
        [jsonDictionary setValue:[NSNumber numberWithInt:(int)roundf(self.size.width)] forKey:@"width"];
    }
    return jsonDictionary;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@: url='%@', type='%@', size=%.fx%.f>",
            NSStringFromClass(self.class),
            self.url,
            self.type,
            self.size.width, self.size.height
            ];
}



#pragma mark - Helper

+ (NSMutableDictionary*)convertImagesFromDictionary:(NSDictionary*)dictionary {
    NSMutableDictionary *newImagesDict = [NSMutableDictionary new];
    for (NSString *key in dictionary.allKeys) {
        id imageDict = [dictionary valueForKey:key];
        if ([imageDict isKindOfClass:[NSDictionary class]]) {
            TGImage *image = [[TGImage alloc] initWithDictionary:imageDict];
            [newImagesDict setValue:image forKey:key];
        }
    }
    return newImagesDict;
}

+ (NSDictionary*)jsonDictionaryForImagesDictionary:(NSDictionary*)dictionary {
    NSMutableDictionary *imagesJsonDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in dictionary.allKeys) {
        id imageData = [dictionary valueForKey:key];
        if ([imageData isKindOfClass:[TGImage class]]) {
            TGImage *image = (TGImage*)imageData;
            [imagesJsonDictionary setObject:image.jsonDictionary forKey:key];
        }
        else if ([imageData isKindOfClass:[NSDictionary class]]) {
            [imagesJsonDictionary setObject:imageData forKey:key];
        }
    }
    return imagesJsonDictionary.count == 0 ? nil : imagesJsonDictionary;
}

#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.jsonDictionary forKey:@"jsondict"];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self loadDataFromDictionary:[aDecoder decodeObjectForKey:@"jsondict"]];
    }
    return self;
}


@end
