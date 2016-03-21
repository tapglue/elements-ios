//
//  TGEventManager.m
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

#import "TGEventManager.h"
#import "TGEventManager+Private.h"
#import "TGPost.h"
#import "TGEvent.h"
#import "TGModelObject+Private.h"
#import "TGApiClient.h"
#import "TGLogger.h"
#import "Tapglue+Private.h"
#import "TGUserManager.h"
#import "TGReaction+Private.h"
#import "TGComment.h"
#import "TGApiRoutesBuilder.h"

NSString *const TGEventManagerAPIEndpointEvents = @"events";
NSDictionary* typesWithPost;

@interface TGEventManager ()
@property (nonatomic, strong, readwrite) NSArray *cachedFeed;
@property (nonatomic, assign, readwrite) NSInteger unreadCount;
@property (nonatomic, strong) NSMutableSet *writeQueue;
@property (nonatomic, strong) NSMutableSet *deleteQueue;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end

@implementation TGEventManager

- (instancetype)initWithClient:(TGApiClient *)client {
    self = [super initWithClient:client];
    if (self) {
        NSString *queueLabel = [NSString stringWithFormat:@"%@.%@.%p", TaplueSDKID, NSStringFromClass(self.class), self];
        self.serialQueue = dispatch_queue_create(queueLabel.UTF8String, DISPATCH_QUEUE_SERIAL);
        [self unarchive];
    }
    typesWithPost = [NSDictionary dictionaryWithObject:@"tg_like" forKey: @"tg_like"];
    return self;
}

- (NSMutableSet*)writeQueue {
    if (!_writeQueue) {
        _writeQueue = [NSMutableSet set];
    }
    return _writeQueue;
}

- (NSMutableSet*)deleteQueue {
    if (!_deleteQueue) {
        _deleteQueue =  [NSMutableSet set];
    }
    return _deleteQueue;
}

- (void)clearQueues {
    // simply set them to `nil` as they have lazy initializers
    _writeQueue = nil;
    _deleteQueue = nil;
}

- (NSArray*)cachedUnreadFeed {
    if (!self.cachedFeed) {
        return nil;
    }
    if (self.unreadCount > 0) {
        return [self.cachedFeed subarrayWithRange:NSMakeRange(0, MIN(self.unreadCount, self.cachedFeed.count))];
    }
    return @[];
}

#pragma mark - manager main api

- (void)addEvent:(TGEvent*)event {
    dispatch_async(self.serialQueue, ^{
        [self.writeQueue addObject:event];
    });
    [self flushEvents];
}

- (void)deleteEvent:(TGEvent *)event {
    dispatch_async(self.serialQueue, ^{
        BOOL addToDeleteQueue = YES;
        if ([self.writeQueue containsObject:event]) {
            [self.writeQueue removeObject:event];
            addToDeleteQueue = event.eventId != nil; // if the event as an id it still need to be deleted on the backend
        }

        if (addToDeleteQueue) {
            [self.deleteQueue addObject:event];
        }
    });
    [self flushDeletedEvents];
}

- (void)flush {
    [self flushEvents];
    [self flushDeletedEvents];
}

- (void)archive {
    [self archiveQueues];
    [self archiveFeed];
}

- (void)unarchive {
    [self unarchiveQueues];
    [self unarchiveFeed];
}

- (void)resetCaches {
    // only archive the queue for a later login of the user
    // do not flush here as it might take to long
    [self archiveQueues];
    [self clearQueues];

    // reset the cached feed
    self.cachedFeed = [NSArray array];
    self.unreadCount = 0;
}

#pragma mark Helper

- (void)flushEvents {
    dispatch_async(self.serialQueue, ^{
        __block NSInteger successCount = 0;
        [self.writeQueue enumerateObjectsUsingBlock:^(TGEvent *event, BOOL *stop) {
            if ([self createOrUpdateEventSynchronous:event]) {
                [self.writeQueue removeObject:event];
                successCount++;
            }
        }];
        if (successCount > 0) {
            TGLog(@"Flush: Wrote %ld event(s)", successCount);
        }
    });
}

- (void)flushDeletedEvents {
    dispatch_async(self.serialQueue, ^{
        __block NSInteger successCount = 0;
        [self.deleteQueue enumerateObjectsUsingBlock:^(TGEvent *event, BOOL *stop) {
            if ([self deleteEventSynchronous:event]) {
                [self.deleteQueue removeObject:event];
                successCount++;
            }
        }];
        if (successCount > 0) {
            TGLog(@"Flush: Deleted %ld event(s)", successCount);
        }
    });
}

#pragma mark - backend api calls

#pragma mark members

- (void)createEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock{
    [self.client POST:[TGApiRoutesBuilder routeForEventsOfUserWithId:nil] withURLParameters:nil andPayload:event.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {

        [event loadDataFromDictionary:jsonResponse];

        if (!error) {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

- (void)updateEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock{
    NSString *route = [[TGApiRoutesBuilder routeForEventsOfUserWithId:nil] stringByAppendingPathComponent:event.eventId];
    [self.client PUT:route withURLParameters:nil andPayload:event.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            completionBlock(error == nil, error);
        }
    }];
}

- (void)createOrUpdateEvent:(TGEvent*)event withCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    if (!event.eventId) {
        [self createEvent:event withCompletionBlock:completionBlock];
    }
    else {
        [self updateEvent:event withCompletionBlock:completionBlock];
    }
}

- (BOOL)createOrUpdateEventSynchronous:(TGEvent*)event {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);

    __block BOOL credateSuccess = NO;
    [self createOrUpdateEvent:event withCompletionBlock:^(BOOL success, NSError *error) {
        if (!success) {
            TGLog(@"WARNING: create event %@ failed with error: %@", event, error);
        }
        credateSuccess = success;
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // blocks current thread to wait

    return credateSuccess;
}


- (void)deleteEventWithId:(NSString*)eventId withCompletionBlock:(TGSucessCompletionBlock)completionBlock{
    NSString *route = [[TGApiRoutesBuilder routeForEventsOfUserWithId:nil] stringByAppendingPathComponent:eventId];
    [self.client DELETE:route withCompletionBlock:completionBlock];
}

- (BOOL)deleteEventSynchronous:(TGEvent*)event {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);

    __block BOOL deleteSuccess = NO;
    [self deleteEventWithId:event.eventId withCompletionBlock:^(BOOL success, NSError *error) {
        if (!success) {
            TGLog(@"WARNING: delete event %@ failed with error: %@", event, error);
        }
        deleteSuccess = success;
        dispatch_group_leave(group);
    }];
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER); // blocks current thread to wait

    return deleteSuccess;
}

- (void)retrieveEventWithId:(NSString*)eventId
              forUserWithID:(NSString*)userId
        withCompletionBlock:(TGGetEventCompletionBlock)completionBlock {

    NSString *endPoint = [self endPointForUserWithId:userId];
    endPoint = [endPoint stringByAppendingPathComponent:TGApiEndpointEvents];
    endPoint = [endPoint stringByAppendingPathComponent:eventId];

    [self.client GET:endPoint withURLParameters:nil andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [self handleSingleEventResponse:jsonResponse withError:error andCompletionBlock:completionBlock];
    }];
}

- (void)retrieveEventForCurrentUserWithEventId:(NSString*)eventId withCompletionBlock:(TGGetEventCompletionBlock)completionBlock {
    [self retrieveEventWithId:eventId forUserWithID:nil withCompletionBlock:completionBlock];
}

#pragma mark - Comments -

- (TGComment*)createComment:(NSString*)comment forObjectWithId:objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    NSString *route = [TGApiRoutesBuilder routeForCommentOnObjectId:objectId];
    TGComment *objectComment = [[TGComment alloc] init];
    objectComment.content = comment;
    objectComment.user = [TGUser currentUser];
    
    [self.client POST:route withURLParameters:nil andPayload:objectComment.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        [objectComment loadDataFromDictionary:jsonResponse]; // update the data
        if (!error) {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
    
    return objectComment;
}

- (void)updateComment:(TGComment*)comment forObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    NSString *route = [TGApiRoutesBuilder routeForCommentWithId:comment.objectId onObjectWithId:objectId];
    [self.client PUT:route withURLParameters:nil andPayload:comment.jsonDictionary andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            completionBlock(error == nil, error);
        }
    }];
}

- (void)deleteComment:(TGComment*)comment forObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    NSString *route = [TGApiRoutesBuilder routeForCommentWithId:comment.objectId onObjectWithId:objectId];
    [self.client DELETE:route withCompletionBlock:completionBlock];
}

- (void)retrieveCommentsForObjectWithId:objectId withCompletionBlock:(void (^)(NSArray *comments, NSError *error))completionBlock {
    [self.client GET:[TGApiRoutesBuilder routeForCommentOnObjectId:objectId] withURLParameters:nil andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        
        if (!error) {
            NSArray *userDictionaries = [[jsonResponse objectForKey:@"users"] allValues];
            [TGUser createAndCacheObjectsFromDictionaries:userDictionaries];
            
            NSArray *commentDictionaries = [jsonResponse objectForKey:@"comments"];
            NSMutableArray *comments = [NSMutableArray arrayWithCapacity:commentDictionaries.count];
            for (NSDictionary *data in commentDictionaries) {
                [comments addObject:[[TGComment alloc] initWithDictionary:data]];
            }
            
            if (completionBlock) {
                completionBlock(comments, nil);
            }
        }
        else if(completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

#pragma mark - Likes -

- (void)createLikeForObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    NSString *route = [TGApiRoutesBuilder routeForLikeOnObjectId:objectId];
    [self.client POST:route withURLParameters:nil andPayload:nil andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (!error) {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

- (void)deleteLikeForObjectWithId:(NSString*)objectId andCompletionBlock:(TGSucessCompletionBlock)completionBlock {
    NSString *route = [TGApiRoutesBuilder routeForLikeOnObjectId:objectId];
    [self.client DELETE:route withCompletionBlock:^(BOOL success, NSError *error) {
        if (!error) {
            if (completionBlock) {
                completionBlock(YES, nil);
            }
        } else if (completionBlock) {
            completionBlock(NO, error);
        }
    }];
}

- (void)retrieveLikesForObjectWithId:(NSString*)objectId andCompletionBlock:(void (^)(NSArray *Likes, NSError *error))completionBlock {
    NSString *route = [TGApiRoutesBuilder routeForLikeOnObjectId:objectId];
    [self.client GET:route withURLParameters:nil andCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        
        if (!error) {
            NSArray *userDictionaries = [[jsonResponse objectForKey:@"users"] allValues];
            [TGUser createAndCacheObjectsFromDictionaries:userDictionaries];
            
            NSArray *likeDictionaries = [jsonResponse objectForKey:@"likes"];
            NSMutableArray *likes = [NSMutableArray arrayWithCapacity:likeDictionaries.count];
            for (NSDictionary *data in likeDictionaries) {
                [likes addObject:[[TGLike alloc] initWithDictionary:data]];
            }
            
            if (completionBlock) {
                completionBlock(likes, nil);
            }
        }
        else if(completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

#pragma mark collection


- (void)retrieveEventsForCurrentUserWithCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock {
    [self retrieveEventsForUser:nil withCompletionBlock:completionBlock];
}

- (void)retrieveEventsForUser:(TGUser*)user withCompletionBlock:(void (^)(NSArray *events, NSError *error))completionBlock {
    NSString *apiEndpoint = [self endPointForUser:user];
    apiEndpoint = [apiEndpoint stringByAppendingPathComponent:TGEventManagerAPIEndpointEvents];
    [self.client GET:apiEndpoint withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            if (!error) {
                NSArray *events = [self eventsFromJsonResponse:jsonResponse];
                if (completionBlock) {
                    completionBlock(events, nil);
                }
            }
            else if(completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)retrieveEventsFeedForCurrentUserOnlyUnread:(BOOL)onlyUnread
                         withCompletionBlock:(TGFeedCompletionBlock)completionBlock {
    
    NSString *apiEndpoint = [TGApiRoutesBuilder routeForEventsFeed];
    if (onlyUnread) {
        apiEndpoint = [apiEndpoint stringByAppendingPathComponent:@"unread"];
    }


    // TODO: [improvement] find a way to push a all completion blocks on the calling queue
    NSOperationQueue *current_queue = [NSOperationQueue currentQueue];


    [self.client GET:apiEndpoint withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            if (!error) {
                NSArray *userDictionaries = [[jsonResponse objectForKey:@"users"] allValues];
                [TGUser createAndCacheObjectsFromDictionaries:userDictionaries];
                
                NSInteger unreadCount = [[jsonResponse objectForKey:@"unread_events_count"] integerValue];
                NSArray *events = [self eventsFromJsonResponse:jsonResponse];

                self.cachedFeed = events;
                self.unreadCount = unreadCount;

                if (completionBlock) {
                    [current_queue addOperationWithBlock:^{
                        completionBlock(events, unreadCount, nil);
                    }];
                }
            }
            else if(completionBlock) {
                [current_queue addOperationWithBlock:^{
                    completionBlock(nil, 0, error);
                }];
            }
        }
    }];
}

- (void)retrieveNewsFeedForCurrentUserOnlyUnread:(BOOL)onlyUnread
                               withCompletionBlock:(TGGetNewsFeedCompletionBlock)completionBlock {
    
    NSString *apiEndpoint = [TGApiRoutesBuilder routeForNewsFeed];
    if (onlyUnread) {
        apiEndpoint = [apiEndpoint stringByAppendingPathComponent:@"unread"];
    }
    
    
    // TODO: [improvement] find a way to push a all completion blocks on the calling queue
    NSOperationQueue *current_queue = [NSOperationQueue currentQueue];
    
    [self.client GET:apiEndpoint withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            if (!error) {
                NSArray *userDictionaries = [[jsonResponse objectForKey:@"users"] allValues];
                [TGUser createAndCacheObjectsFromDictionaries:userDictionaries];
                
                NSInteger unreadCount = [[jsonResponse objectForKey:@"unread_events_count"] integerValue];
                NSArray *posts = [self postsFromJsonResponse:jsonResponse];
                NSArray *events = [self eventsFromJsonResponse:jsonResponse];
                
                self.cachedFeed = events;
                self.unreadCount = unreadCount;
                
                if (completionBlock) {
                    [current_queue addOperationWithBlock:^{
                        completionBlock(posts, events, nil);
                    }];
                }
            }
            else if(completionBlock) {
                [current_queue addOperationWithBlock:^{
                    completionBlock(nil, 0, error);
                }];
            }
        }
    }];
}

- (void)retrieveFeedUnreadCountForCurrentWithCompletionBlock:(void (^)(NSInteger, NSError *))completionBlock {
    NSString *route = [[TGApiRoutesBuilder routeForEventsFeed] stringByAppendingPathComponent:@"unread/count"];
    [self.client GET:route withCompletionBlock:^(NSDictionary *jsonResponse, NSError *error) {
        if (completionBlock) {
            if (!error) {
                NSInteger unreadCount = [[jsonResponse valueForKey:@"unread_events_count"] integerValue];
                completionBlock(unreadCount, nil);
            }
            else {
                completionBlock(NSNotFound, error);
            }
        }
    }];
}

#pragma mark Helper
- (void)handleSingleEventResponse:(NSDictionary*)jsonResponse withError:(NSError*)responseError andCompletionBlock:(TGGetEventCompletionBlock)completionBlock {
    if (jsonResponse && !responseError) {
        TGEvent *currentEvent = [[TGEvent alloc] initWithDictionary:jsonResponse];
        if (completionBlock) {
            completionBlock(currentEvent, nil);
        }
    }
    else if (completionBlock) {
        completionBlock(nil, responseError);
    }
}

- (NSArray*)eventsFromJsonResponse:(NSDictionary*)jsonResponse {
    NSDictionary *postDictionaries = [jsonResponse objectForKey:@"post_map"];
    
    for(NSDictionary *postData in postDictionaries) {
        [TGPost createOrLoadWithDictionary:postDictionaries[postData]];
    }
    
    NSDictionary *userDictionaries = [jsonResponse objectForKey:@"users"];
    for(NSDictionary *userData in userDictionaries) {
        [TGUser createOrLoadWithDictionary:userDictionaries[userData]];
    }
    
    NSArray *eventDictionaries = [jsonResponse objectForKey:@"events"];
    NSMutableArray *events = [NSMutableArray arrayWithCapacity:eventDictionaries.count];

    for (NSDictionary *eventData in eventDictionaries) {
        TGEvent *newEvent = [TGEvent createOrLoadWithDictionary:eventData];
        if([typesWithPost  objectForKey:newEvent.type] != nil) {
            newEvent.post = [TGPost objectWithId:newEvent.tgObjectId];
        }
        [events addObject:newEvent];
    }
    return events;
}

- (NSArray*)postsFromJsonResponse:(NSDictionary*)jsonResponse {
    NSArray *postDictionaries = [jsonResponse objectForKey:@"posts"];
    NSMutableArray *posts = [NSMutableArray arrayWithCapacity:postDictionaries.count];
    for (NSDictionary *postData in postDictionaries) {
        TGPost *newPost = [TGPost createOrLoadWithDictionary:postData];
        [posts addObject:newPost];
    }
    return posts;
}

/**
 @param user the user to get the connected users of or nil to get current user's connected users
 */
- (NSString*)endPointForUser:(TGUser*)user {
    return [self endPointForUserWithId:user.userId];
}

- (NSString*)endPointForUserWithId:(NSString*)userId {
    return userId ? [TGUserManagerAPIEndpointUsers stringByAppendingPathComponent:userId] : TGUserManagerAPIEndpointCurrentUser;
}

#pragma mark - Persistence

- (NSString *)filePathForData:(NSString *)data {
    NSString *userId = [TGUser currentUser].userId;
    NSString *filename = [NSString stringWithFormat:@"tapglue-%@-%@.plist", userId, data];
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:filename];
}

- (void)archiveQueues {
    NSMutableSet *writeQueueCopy = [NSMutableSet setWithSet:[self.writeQueue copy]];
    [self archiveData:writeQueueCopy withFilenameKey:@"write-event-queue"];

    NSMutableSet *deleteQueueCopy = [NSMutableSet setWithSet:[self.deleteQueue copy]];
    [self archiveData:deleteQueueCopy withFilenameKey:@"delete-event-queue"];
}

- (void)archiveFeed {
    NSMutableArray *feedCopy = [NSMutableArray arrayWithArray:[self.cachedFeed copy]];
    NSDictionary *feedData = @{@"events" : feedCopy, @"unread_count" : [NSNumber numberWithInteger:self.unreadCount]};
    [self archiveData:feedData withFilenameKey:@"feed"];
}

- (void)archiveData:(id)data withFilenameKey:(NSString*)dataKey {
    NSString *filePath = [self filePathForData:dataKey];
    TGLog(@"%@ archiving %@ data to %@: %@", self, dataKey, filePath, data);
    if (![NSKeyedArchiver archiveRootObject:data toFile:filePath]) {
        TGLog(@"%@ failed to archive %@ data", self, dataKey);
    }
}

-(void)unarchiveQueues {
    self.writeQueue = (NSMutableSet *)[self unarchiveFromFile:[self filePathForData:@"write-event-queue"]];
    self.deleteQueue = (NSMutableSet *)[self unarchiveFromFile:[self filePathForData:@"delete-event-queue"]];
}

- (void)unarchiveFeed {
    NSDictionary *feedData = (NSDictionary *)[self unarchiveFromFile:[self filePathForData:@"feed"]];
    self.cachedFeed = [feedData objectForKey:@"events"];
    self.unreadCount = [[feedData objectForKey:@"unread_count"] integerValue];
}

- (id)unarchiveFromFile:(NSString *)filePath {
    id unarchivedData = nil;
    @try {
        unarchivedData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        TGLog(@"%@ unarchived data from %@: %@", self, filePath, unarchivedData);
    }
    @catch (NSException *exception) {
        TGLog(@"%@ unable to unarchive data in %@, starting fresh\nerror:\t%@\n\n", self, filePath, exception);
        unarchivedData = nil;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!removed) {
            TGLog(@"%@ unable to remove archived file at %@ - %@", self, filePath, error);
        }
    }
    return unarchivedData;
}

@end
