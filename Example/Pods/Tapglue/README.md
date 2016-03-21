# Tapglue iOS SDK

This will help you get started with Tapglue on iOS step by step guide.

A more detailed documentation can be found on our [documentation](http://developers.tapglue.com/docs/ios) website.

If you're interested in the iOS SDK Reference Documentation visit our docs on [CocoaPods](http://cocoadocs.org/docsets/Tapglue/).

## Get started

To start using the Tapglue API you need an `APP_TOKEN`. Visit our [Dashboard](https://dashboard.tapglue.com) and login with your credentials or create a new account.

## Quickstart

We created a template with Tapglue already installed for you. Before diving into the specifics of our SDK you can download the [Quickstart-Project](https://github.com/tapglue/ios_quickstart) and start using Tapglue immediately.

## Sample App

Our [Sample app](https://github.com/tapglue/ios_sample) covers most of the concepts in our SDK and is a great showcase if you want to check implementation details.

# Installing the SDK

This page will help you get started with Tapglue on iOS step by step guide.

## Installing with CocoaPods

The easiest way to install Tapglue into your iOS project is to use [CocoaPods](http://cocoapods.org/).

1. Install CocoaPods with `gem install cocoapods`
2. Run `pod setup` to create a local CocoaPods spec mirror, if this is the first time using CocoaPods.
3. Create a `Podfile` in your Xcode project and add:

```
pod 'Tapglue'
```

4. Run `pod install` in your project directory and Tapglue will be downloaded and installed.
5. Restart your Xcode project

## Manual Installation

If you don't want to use CocoaPods you download the latest version of [Tapglue from Github](https://github.com/tapglue/ios_sdk/releases) and copy it into your project.

1. Clone the SDK with `git clone https://github.com/tapglue/ios_sdk.git`
2. Copy the SDK into your Xcode project's folder
3. Import all dependencies
4. Integrate `<Tapglue/Tapglue.h>` into your files

## Initialise the library

To start using Tapglue, you must initialise our SDK with your app token first. You can find your app token in the [Tapglue dashboard](https://dashboard.tapglue.com).

To initialise the library, import `Tapglue.h` and in your AppDelegate’s -`application:didFinishLaunchingWithOptions:` call `setUpWithAppToken:` with your app token as its argument.

```objective-c
#import <Tapglue/Tapglue.h>

#define tapglueToken @"YOUR_APP_TOKEN"

// Initialise the SDK with your app token
[Tapglue setUpWithAppToken:tapglueToken];
```

### Bridging header

Our SDK is fully compatible with Swift. If you are using Swift, create a `Objective-C-Bridging-Header.h` file and add `#import <Tapglue/Tapglue.h>` to it. You can learn more about bridging headers on [Apples official documentation](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html).

You don't need a bridging header if you enable `use_frameworks!` in your Podfile.

## SDK Configuration

If you want to initialise SDK with a custom configuration you can specify following attributes:

- `apiBaseUrl`
- `loggingEnabled`
- `flushInterval (in seconds)`
- `showNetworkActivityIndicator`
- `analyticsEnabled`

Simply call `setUpWithAppToken: andConfig:` and define a config like in the following:

```objective-c
#import "Tapglue.h"

#define tapglueToken @"YOUR_APP_TOKEN"

// Create config object
TGConfiguration *customConfig = [TGConfiguration defaultConfiguration];

// Configure custom settings
customConfig.loggingEnabled = true;

// Initialize the SDK with app token and config
[Tapglue setUpWithAppToken:tapglueToken andConfig:customConfig];
```

In most cases, it makes sense to do this in `application:didFinishLaunchingWithOptions:`.

## Compatibility

Versions of Tapglue greater than 0.1.0 will work for a deployment target of iOS 7.0 and above. You need to be using Xcode 5 and a Base SDK of iOS 7.0 for your app to build.

# Create users

After installing Tapglue into your iOS app, creating users is usually the first thing you need to do, to build the basis for your news feed.

## Create and login users

Our SDK provides three convenient ways to create users. Creating users will automatically resolve in a login afterwards as you wouldn't ask the users to login again after they registered. Do achieve this, you can call one of the following options:

- `createAndLoginUserWithUsername`
- `createAndLoginUserWithEmail`
- `createAndLoginUser`

Here is an example of creating a user with the username:

```objective-c
[Tapglue createAndLoginUserWithUsername:@"username" andPassword:@"password" withCompletionBlock:^(BOOL success, NSError *error) {
        if (success) {
            // Implement success after user creation/login.
        } else {
            // Implement error handling.
        }
}];
```

In most cases, it makes sense to call this after a signup or login screen and read the data from the values entered in the text fields.

## Login users

Even though `createAndLogin` will automatically login existing users, it's better to call the login only if you are just showing a login screen for example. You can do it with the following call:

```objective-c
[Tapglue loginWithUsernameOrEmail:@"username" andPassword:@"password" withCompletionBlock:^(BOOL success, NSError *error) {
        if (success) {
            // Implement success after login.
        } else {
            // Implement error handling.
        }
    }];
```

## Logout users

To logout users you can simply call `logoutWithCompletionBlock`.

```objective-c
[Tapglue logoutWithCompletionBlock:^(BOOL success, NSError *error) {
	if (success) {
  	// Implement success.
 	} else {
		// Implement error handling.
  }
}]
```

## Current User

When you successfully create or login a user, we store it as the `currentUser` by default. To check if a user object is the currentUser you can simply do the following:

```objective-c
TGUser *user = [[TGUser alloc] init];

if (user.isCurrentUser) {
    // User is currentUser
} else {
    // User isn't currentUser
}
```

If the currentUser is set, you can access it's properties from any place in your project.

```objective-c
NSString *username = [TGUser currentUser].username;
```

## Update Current User

If users want to update their profile information you can update it with the `saveWithCompletionBlock` method.

```objective-c
TGUser *user = [TGUser currentUser]

user.username = @"changedUsername";
[user saveWithCompletionBlock:^(BOOL success, NSError *error) {
	if (success) {
  	// Implement success after login.
 	} else {
		// Implement error handling.
  }
}]
```

## Delete Current User

To delete the current user you can perform `deleteWithCompletionBlock`.

```objective-c
TGUser *user = [TGUser currentUser]

[user deleteWithCompletionBlock:^(BOOL success, NSError *error) {
	if (success) {
  	// Implement success after login.
 	} else {
		// Implement error handling.
  }
}]
```

# Search Users

Connecting users and building a social graph is one of the most challenging parts of building a social experience. We provide three simple ways to help you get started.

## Search single users

One way to create connections between users within your app is to do a search. This can be achieved with the following:

```objective-c
// Search users
[Tapglue searchUsersWithTerm:@"term" andCompletionBlock:^(NSArray *users, NSError *error) {
    if (users && !error) {
        // Update UI with users
    } else {
        // Error handling
    }
}];
```

This will search for the provided term in the `username`, `firstName`, `lastName` and `email`.

## E-Mails search

If you want to search for multiple e-mails and get back a list of users. This is usually the case when you want to sync users from a source like the address-book. To do so use the following:

```objective-c
// Specify list of emails
NSArray *emails = @[@"user@mail.com", @"user2@mail.com"];

// Search users
[Tapglue searchUsersWithEmails:emails andCompletionBlock:^(NSArray *users, NSError *error) {
    if users != nil && error == nil {
        // Update UI with users
    } else {
        // Error handling
    }
}];
```

## SocialIds search

A similar behaviour can be achieved if you want to sync users from another network like Facebook or Twitter.

```objective-c
// Specify list of socialIds
NSArray *socialIds = @[@"1234567", @"7654321"];

// Search users
[Tapglue searchUsersOnSocialPlatform:TGPlatformKeyFacebook withSocialUsersIds:socialIds andCompletionBlock:^(NSArray *users, NSError *error) {
    if users != nil && error == nil {
        // Update UI with users
    } else {
        // Error handling
    }
}];
```

We used `TGPlatformKeyFacebook` in the example above. We created a couple of platform keys for convenience:

- `TGPlatformKeyFacebook`
- `TGPlatformKeyTwitter`
- `TGPlatformKeyGoogle`
-  `TGPlatformKeyCustom`

# Connect Users

In the example above we create a follow connection. You can also also create a friend connection with `friendUser`.

## Follow or Friend a user

The simplest way to create a connection is to either follow or friend a user. To do so you can use the methods:

- `followUser`
- `friendUser`

```objective-c
[Tapglue followUser:user withCompletionBlock:^(BOOL success, NSError *error) {
		if (success) {
		// Update UI with users
		} else {
		// Error handling
		}
}];
```

## Social Connections

A much nicer way to connect users is to use Twitter or Facebook and just sync already existing connections. To do so we have two batch methods:

- `followUsersWithSocialsIds`
- `friendUsersWithSocialsIds`

Here is an example how to follow multiple users with Tapglue:

```objective-c
NSArray *friendsIds = ... // retrieve users
[Tapglue followUsersWithSocialsIds:friendsIds
         onPlatfromWithSocialIdKey:@"twitter"
               withCompletionBlock:^(BOOL success, NSError *error) {
                   if (success) {
                        // friends added successfully
                   }
                   else {
                        // Error handling
                   }
               }];
```

Here is a concrete example, of how to fetch friends from the Facebook SDK:

```objective-c
// #1 be logged in at Tapglue
// #2 be logged in at Facebook

FBSDKGraphRequest *myFriendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil];

[myFriendsRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {

    if (result && !error) {
        // request succeeded > found frined
        NSArray *friendsIds = [result valueForKeyPath:@"data.id"];
        [Tapglue friendUsersWithSocialsIds:friendsIds
                 onPlatfromWithSocialIdKey:TGUserSocialIdFacebookKey
                       withCompletionBlock:^(BOOL success, NSError *error) {
                           if (success) {
                                // friends added successfully
                           }
                           else {
                                // Error Handling
                           }
                       }];           
    } else {
        // Error handling (Facebook request)
    }       
}];
```

## Delete connections

To delete a connection you can use:

- `unfollowUser`
- `unfriendUser`

```objective-c
[Tapglue unfollowUser:user withCompletionBlock:^(BOOL success, NSError *error) {
		if (success) {
		// Update UI with users
		} else {
		// Error handling
		}
}];
```

You can learn more about [deleting connections](doc:delete-connection) etc. in the reference documentation below.

# Send events

Once you have users and connections in place, events are the last thing you need to send before retrieving a production-ready activity feed.

## Create Events

There are three ways to create events in the SDK.

1. `createEventWithType: andObjectId`
2. `createEventWithType: onObject`
3. `createEvent:`

The first method is for convenience and works best if the only thing you have to specify when triggering an event is the `type` and an `objectId`.

If you use the second option you are able to attach a rich object with multiple attributes to an event.

In the last example you create a `TGEvent` object first that creates all information you can attach to an event. In the following example we will use this option:

```objective-c
// Create TGEvent object
TGEvent *event = [[TGEvent alloc] init];

event.type = @"like";
event.language = @"en";
event.location = @"berlin";
event.latitude = 52.520007;
event.longitude = 13.404954;

// Create object
TGEventObject *object = [[TGEventObject alloc] init];

object.objectId = @"article_123";
object.type = @"article";
object.url = @"app://articles/article_123";
[object setDisplayName:@"article title" forLanguage:@"en"];
[object setDisplayName:@"artikel titel" forLanguage:@"de"];

event.object = object;

event.metadata = @{
                   @"foo" : @"bar",
                   @"amount" : @12,
                   @"progress" : @0.95
   	               };

// Send event
[Tapglue createEvent:event];
```

## Event visibilities

Besides the attributes that you attach to each event, you can specify different visibilities. Those

- `TGVisibility.Private`
- `TGVisibility.Connection`
- `TGVisibility.Public`

Events will be queued and eventually flushed to send them to Tapglue. That way you can also track events when offline and send them at once when online again. In the [first section](doc:ios) of the iOS Guide you can learn more about configuring the flush settings.

You can learn more about [deleting events](doc:delete-event) etc. in the reference documentation below.

# Create Posts

Events are very powerful to build Notification centers or activity feeds. However, if you wan't to include user generated content to build a proper news feed we provide a much more powerful entity for you: `Posts`.

## Create Posts

We currently provide two methods to create Posts:

1. `createPostWithText`
2. `createPost`

The first method is for convenience and works best if the only thing you have to specify when creating a post is the `text`.

If you use the second option you are able to attach a rich object with multiple attributes to a post.

In the last example you create a `TGPost` object first that creates all information you can attach to a post. In the following example we will use this option:

```objective-c
// Create TGPost Object
TGPost *post = [TGPost new];
post.visibility = TGVisibilityPublic;
post.tags = @[@"fitness",@"running"];

// Create Attachment
[post addAttachment:[TGAttachment attachmentWithText:@"This is the Text of the Post." andName:@"body"]];

// Create Post
[Tapglue createPost:post withCompletionBlock:^(BOOL success, NSError *error) {
		if (success) {
			// Success handling
		}
		else {
			// Error handling
		}
}];
```

## Attachments

Each post can have multiple attachments. An attachments of a post can currently be of type text or a url. A text can be used to represent the user generated text. A url is useful for different use-case such as a reference to an image or video. Furthermore you can specify a name for each attachments to add more context to the post. To create attachments of a post we currently provide following methods:

- `attachmentWithText`
- `attachmentWithURL`
- `attachmentWithNSURL`

# Comments and Likes

Posts are the core entity of a news feed. To provide a richer and more engaging experiences, Tapglue enables you to comment or like posts

## Create comments

There are ways to create a comment on a post:

- `createCommentWithContent`
- `post.commentWithContent`

The first option is the main method to create a comment. This requires to pass the post object. The second option is a convenience method that can be performed on a post object. To create a comment here is an example below:

```objective-c
// Specify comment
NSString *comment = @"This is the comment of the post.";

// Create comment
[Tapglue createCommentWithContent:comment forPost:post withCompletionBlock:^(BOOL success, NSError *error) {
		if (success) {
			// Success handling
		}
		else {
			// Error handling
		}
}];
```

## Retrieve comments

To retrieve all comments that have been created on a post there are two methods:

- `retrieveCommentsForPost`
- `retrieveCommentsForPostWithId`

The first one requires a post object, the second one a `postId` only. Comments could be displayed in a post detail page under the post detail itself.

```objective-c
[Tapglue retrieveCommentsForPost:post withCompletionBlock:^(NSArray *comments, NSError *error) {
		if (comments) {
			// Success handling
		}
		else {
			// Error handling
		}
}];
```

## Update comments

To update or delete a comment you can use:

- `updateComment`
- `deleteComment`

Both methods require a comment object, that you have to retrieve from a post before.

You can learn more about [deleting comments](doc:delete-comment) etc. in the reference documentation below.

## Like posts

Besides regular events that you can always use, we've created an explicit like method for posts as this is one of the core interactions of a social network. Similar to comments there are two methods to like a post:

- `createLikeForPost`
- `post.likeWithCompletionBlock`

The first option is the main method to create a like. This requires to pass the post object. The second option is a convenience method that can be performed on a post object. To create a like here is an example below:

```objective-c
[Tapglue createLikeForPost:post withCompletionBlock:^(BOOL success, NSError *error) {
		if (success) {
			// Success handling
		}
		else {
			// Error handling
		}
}];
```

## Retrieve likes

To retrieve all likes for a post there are two methods:

- `retrieveLikesForPost`
- `retrieveLikesForPostWithId`

Simply run the following to retrieve them:

```objective-c
[Tapglue retrieveLikesForPost:post withCompletionBlock:^(NSArray *likes, NSError *error) {
		if (likes) {
			// Success handling
		}
		else {
			// Error handling
		}
}];
```

For convenience we've added the attribute `isLiked` to each post. That values determines wether the post has been like by the currentUser or not.

## Unlike posts

If a user unlikes a post again, use following method:

```objective-c
[Tapglue deleteLike:post withCompletionBlock:^(BOOL success, NSError *error) {
		if (success) {
			// Success handling
		}
		else {
			// Error handling
		}
}];
```

# Display feeds

In general there are three different types of feeds that Tapglue provides:

- News Feed
- Posts Feed
- Events Feed

The News Feed contains both: Posts and Events that have been created in the users social graph.
The Posts- and Events Feeds only contain entries of their associated type.

Additionally Tapglue provides lists of Posts and Events for a single user.

- User posts
- User events

Eventually, there is also the opportunity to query the feeds to only get certain types of events.

## News Feed

When retrieving the news feed you will get to lists: `posts` and `events` to do so run:

```objective-c
[Tapglue retrieveNewsFeedForCurrentUserWithCompletionBlock:^(NSArray *posts, NSArray *events, NSError *error) {
if (posts && events && !error) {
      	// Success handling
    } else {
    		// Error handling
    }
}];
```

## Posts Feed

To retrieve a Posts Feed there is following method:

```objective-c
[Tapglue retrievePostsFeedForCurrentUserWithCompletionBlock:^(NSArray *posts, NSError *error) {
  	if (posts && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

## Events Feed

Similar to the examples above, you can retrieve an events feed as shown in the example below:

```objective-c
[Tapglue retrieveEventsFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSInteger unreadCount, NSError *error) {
  	if (events && !error) {
      	// Update UI with events
    } else {
    		// Error handling
    }
}];
```

Sometimes the users will be offline and it would be bad to have an empty feed. Therefore we provide you a cached feed that provides the items from the latest events feed fetch.

### Cached events feed

```objective-c
NSArray *events;
events = [Tapglue cachedEventsFeedForCurrentUser];
```

### Unread events feed

To retrieve only the latest events that have not been read by the user you can call `` to save bandwidth.

```objective-c
[Tapglue retrieveUnreadEventsFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSError *error) {
  if (events && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

### Count of unread events

Sometimes you just want to know how many new events exists to display for a user. You can use that information and display in a badge over an icon. You can retrieve the count with `retrieveUnreadEventsCountForCurrentWithCompletionBlock`.

```objective-c
[Tapglue retrieveUnreadEventsCountForCurrentWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
  if (unreadCount && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

## User posts

You can also retrieve the posts of a single user and display them under a profile screen for example. There are two methods to achieve this:

- `retrievePostsForCurrentUser`
- `retrievePostsForUser`
- `retrievePostsForUserWithId`

The first option will retrieve the currentUsers posts. The other two for a user object or id that you pass.

```objective-c
[Tapglue retrievePostsForUser:user withCompletionBlock:^(NSArray *posts, NSError *error) {
  	if (posts && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

## User events

For retrieving a single users events there are following methods:

- `retrieveEventsForCurrentUser`
- `retrieveEventsForUser`

The first option will retrieve the currentUsers events. The second one will retrieve events for a user object that you pass.

```objective-c
[Tapglue retrieveEventsForUser:user withCompletionBlock:^(NSArray *events, NSError *error) {
  	if (events && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

## Queries

For all feeds there is the possibility to specify a query object to narrow down the results. These methods are:

- `retrieveNewsFeedForCurrentUserWithQuery`
- `retrieveEventsFeedForCurrentUserWithQuery`
- `retrieveEventsForCurrentUserWithQuery`
- `retrieveEventsWithQuery`

```objective-c
// Create Query Object
TGQuery *query = [TGQuery new];
[query addEventObjectWithIdEquals:objectId];
[query addTypeEquals:eventType];

// Retrieve Events with Query
[Tapglue retrieveEventsWithQuery:query andCompletionBlock:^(NSArray *events, NSError *error) {
 		if (events && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

For convenience we also created some methods if you only want to retrieve certain event types of events for a specific objectId. These are:

- `retrieveNewsFeedForCurrentUserForEventTypes`
- `retrieveEventsFeedForCurrentUserForEventTypes`
- `retrieveEventsForCurrentUserForEventTypes``

These methods expect an array that define a set of events, as shown in the example below:

```objective-c
[Tapglue retrieveEventsForCurrentUserForEventTypes:types withCompletionBlock:^(NSArray *events, NSError *error) {
  	if (events && !error) {
    		// Success handling
    } else {
    		// Error handling
    }
}];
```

# Friends and Follower Lists

You might want to show friends, follower and following lists to user in your app. Our SDK provides three methods to do so:

- `retrieveFollowersForCurrentUserWithCompletionBlock`
- `retrieveFollowsForCurrentUserWithCompletionBlock`
- `retrieveFriendsForCurrentUserWithCompletionBlock`

These methods can also be applied to other users with:

- `retrieveFollowsForUser:withCompletionBlock`
- `retrieveFollowersForUser:withCompletionBlock`
- `retrieveFriendsForUser:withCompletionBlock`

## Retrieve Follower

Here is an example to retrieve all follower of the currentUser:

```objective-c
[Tapglue retrieveFollowersForCurrentUserWithCompletionBlock:^(NSArray *users, NSError *error) {
    if (users && !error) {
        // Update UI with users
    } else {
        // Error handling
    }
}];
```

# Debugging and Logging

You can turn on Tapglue logging by initialising the SDK with a custom configuration and setting enabling the logging there.

```objective-c
// Create config object
TGConfiguration *customConfig = [TGConfiguration defaultConfiguration];

// Configure custom settings
customConfig.loggingEnabled = true;
```

Setting `loggingEnabled = true` will cause the Tapglue library to log the users, queuing, and uploading of events, and other fine-grained info that's useful for understanding what the library is doing.

# Error handling

Error handling is an important area when building apps. To always provide the best user-experience to your users we defined custom errors that might happen when implementing Tapglue.

Most methods will provide you either a value or an error. We recommend to always check the `success` or value first and handle errors in case they occur. Each error will contain a `code` and a `message`. You can use the codes do define the behaviour on certain errors. The following example shows an error if the user already exists.

```objective-c
[Tapglue createAndLoginUserWithUsername:@"username" andPassword:@"password" withCompletionBlock:^(BOOL success, NSError *error) {
    if (error.code == kTGErrorUserAlreadyExists) {
        // Error handling
    } else {
        // Something else
    }
}];
```

# License

This SDK is provided under Apache 2.0 license. For the full license, please see the [LICENSE](LICENSE) file that
ships with this SDK.

# PR

TODO: Implement Comments & Likes on external objects
