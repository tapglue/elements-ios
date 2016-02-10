# Tapglue iOS SDK

This will help you get started with Tapglue on iOS step by step guide.

A more detailed documentation can be found on our [documentation](http://developers.tapglue.com/docs/ios) website.

## Get started

To start using the Tapglue API you need an `APP_TOKEN`. Visit our [Dashboard](https://beta.tapglue.com) and login with the credentials you have received from us. If you don't have a Tapglue account yet, please [get in touch](mailto:contact@tapglue.com). Check our [API documentation](http://developers.tapglue.com/docs) for more details.

## Swift Sample App

Bevore diving into the specifics of our SDK we recommend to check out the [Sample app](https://github.com/tapglue/ios_sample). It covers most of the concepts in our SDK and is a great template to use.

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

To start using Tapglue, you must initialise our SDK with your app token first. You can find your app token in the [Tapglue dashboard](https://beta.tapglue.com).

To initialise the library, import `Tapglue.h` and in your AppDelegate’s -`application:didFinishLaunchingWithOptions:` call `setUpWithAppToken:` with your app token as its argument.

```objective-c
#import <Tapglue/Tapglue.h>

#define TAPGLUE_TOKEN @"YOUR_APP_TOKEN"

// Initialise the SDK with your app token
[Tapglue setUpWithAppToken:TAPGLUE_TOKEN];
```

Our SDK is fully compatible with Swift. If you are using Swift, create a `Objective-C-Bridging-Header.h` file and add `#import "Tapglue.h"` to it. You can learn more about bridging headers on [Apples official documentation](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html).

If you want to initialise SDK with a custom configuration you can specify following attributes:

- `apiBaseUrl`
- `apiVersion`
- `loggingEnabled`
- `flushInterval (in seconds)`
- `showNetworkActivityIndicator`
- `analyticsEnabled`

Simply call `setUpWithAppToken: andConfig:` and define a config like in the following:

```objective-c
#import "Tapglue.h"

#define TAPGLUE_TOKEN @"YOUR_APP_TOKEN"

// Create config object
TGConfiguration *customConfig = [TGConfiguration defaultConfiguration];
    
// Configure custom settings
customConfig.loggingEnabled = true;
    
// Initialize the SDK with app token and config
[Tapglue setUpWithAppToken:TAPGLUE_TOKEN andConfig:customConfig];
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

# Connect Users

Connecting users and building a social graph is one of the most challenging parts of building a social experience. We provide three simple ways to help you get started.

## Search users

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

// Create a follow connection
[Tapglue followUser:users.firstObject withCompletionBlock:^(BOOL success, NSError *error) {
    if (success) {
        // Update UI with connection
    } else {
        // Error handling
    }
}];
```

In the example above we create a follow connection. You can also also create a friend connection with `friendUser`.

## Social Connections

A much nicer way to connect users is to use Twitter or Facebook and just sync already existing connections. To do so we have two batch methods:

- `followUsersWithSocialsIds`
- `friendUsersWithSocialsIds`

Here is an example how to follow multiple users with Tapglue:

```objective-c
NSArray *friendsIds = ... // retrieve user ids of friends from somewhere (i.e. twi
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

Events will be queued and eventually flushed to send them to Tapglue. That way you can also track events when offline and send them at once when online again.

# Display news feed

## News feed

The last thing we need to do is retrieve the news feed and display the data. To achieve that we can simply call:

```objective-c
[Tapglue retrieveFeedForCurrentUserWithCompletionBlock:^(NSArray *events, NSInteger unreadCount, NSError *error) {
    if (events && !error) {
        // Update UI with events
    } else {
        // Error handling
    }
}];
```

Sometimes the users will be offline and it would be bad to have an empty feed. Therefore we provide you a cached feed that provides the items from the latest feed fetch.

```objective-c
NSArray *events;
events = [Tapglue cachedFeedForCurrentUser];
```

## User feed

You can also retrieve the events of a single user and display them under a profile screen for example:

```objective-c
[Tapglue retrieveEventsForCurrentUserWithCompletionBlock:^(NSArray *events, NSError *error) {
    if (events && !error) {
        // Update UI with events
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
