# Tapglue Elements

This will help you get started with Tapglue Elements on iOS step by step guide.

A more detailed documentation can be found on our [documentation](https://developers.tapglue.com/docs/elements-ios-installation) website.

## Components

Create User Profiles, Followers & Following Lists, Notifications Feeds & User Search.

![Elements](https://www.filepicker.io/api/file/WN6w8kOiQbeMVtQj2uCe)

## Get started

To start using the Tapglue API you need an `APP_TOKEN`. Visit our [Dashboard](https://dashboard.tapglue.com) and login with your credentials or create a new account.

## Installation

In this section we'll explain how to integrate Tapglue Elements into your iOS app.
Tapglue Elements goes one step beyond the SDK and includes a full set of screens and navigations. 

To install elements first install tapglue as explained in the ios sdk documentation, and then add elements as a submodule to your project by executing:

`git submodule add https://github.com/tapglue/elements-ios.git externals/elements`

then in your project add the elements folder to your project checking the targets you need.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Configuration

We want to make Elements as flexible as possible and allow you to customize it. You will need to set up Tapglue within your application, which will look something like this:

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tgConfig = TGConfiguration.defaultConfiguration()
        Tapglue.setUpWithAppToken(YOUR_TOKEN, andConfig: tgConfig)
}
```

For further detail on how to configure the Tapglue SDK please refer to the [installation section](https://developers.tapglue.com/docs/installation-ios) in the iOS guide. This is also the point where you should customize the appearance of Tapglue Elements. To customize it you need to provide a configuration `JSON` to Elements.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tgConfig = TGConfiguration.defaultConfiguration()
        Tapglue.setUpWithAppToken(YOUR_TOKEN, andConfig: tgConfig)
        
        if let path = NSBundle.mainBundle().pathForResource("config", ofType: "json"){
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                try TapglueUI.setConfig(data)
            } catch let error as NSError {
                print("could not load config file! Error: \(error)")
            }
        }
        
        return true
    }
```

## Simple approach

Integrate Elements with a single line of code for a fully fledged experience. The easiest way to use elements in your app is by simply segueing into our view controllers.

![Simple_Approach](https://www.filepicker.io/api/file/NEdkzTYQGaLXLZwCh8R5)

There are two segues you can perform, one is to the profile screen

```swift
import UIKit
import elements

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TapglueUI.performSegueToProfile(self)
    }
}
```

The other segue is to the notifications feed:

```swift
import UIKit
import elements

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        TapglueUI.performSegueToNotificationFeed(self)
    }
}
```

With this approach we push our navigation controller on top of your view controller and thus replace your navigation with elements own navigation.

## Flexible approach

Integrate Elements into your existing experience and let us handle the social parts.

To get full control over the events that occur within elements we recommend using our view controllers as child view controllers in your own view controllers.

![Flexible_Approach](https://www.filepicker.io/api/file/oCUBC5JWRzS4V0FJmYY0)

This way element seams into your app in a more natural way for the end user.

```swift
import UIKit
import elements

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = TapglueUI.profileViewController()
        
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)

        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
}
```

When using our view controllers like this the default behavior is to integrate our own navigation. This means when the user taps different actionable items we will navigate to our different screens.

If you need more flexibility we also provide delegates that can be implemented to get a deeper control of the events that can occur in the view controllers. For example, the notification screen has the following delegate protocol.

```swift
public protocol NotificationFeedViewDelegate{
    func defaultNavigationEnabledInNotificationFeedViewController(notificationFeedViewController: NotificationFeedViewController) -> Bool
    func notificationFeedViewController(noticationFeedViewController: NotificationFeedViewController, didSelectEvent event: TGEvent)
}
```

`defaultNavigationEnabledInNotificationFeedViewController(notificationFeedViewController: NotificationFeedViewController) -> Bool` lets you decide if elements should navigate for you or not. You will find analogue methods to this in all our view controller delegates.

A practical example would be the following.

```swift
import UIKit
import elements
import Tapglue

class ViewController: UIViewController, NotificationFeedViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.notificationFeedViewController()
        vc.delegate = self
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    func defaultNavigationEnabledInNotificationFeedViewController(notificationFeedViewController: NotificationFeedViewController) -> Bool {
        return false
    }
    
    func notificationFeedViewController(noticationFeedViewController: NotificationFeedViewController, didSelectEvent event: TGEvent) {
			 //handle event tap
    }
}
```

Here the navigation in elements is turned off, thus when the user taps a event cell you ideally want to navigate to some specific event screen.

### Profile View Controller

To use the profile view controller add it as a child view controller and child view of your view controller.

```swift
 let vc = TapglueUI.profileViewController()
        
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)

        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
```

If you want to make use of the delegate be sure to assign the profile view controllers delegate.

```swift
import UIKit
import elements
import Tapglue

class ViewController: UIViewController, ProfileViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.profileViewController()
        vc.delegate = self
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    func defaultNavigationEnabledInProfileViewController(profileViewController: ProfileViewController) -> Bool {
    		//answer if you want to override navigation or not
        return false
    }
    
    func referenceUserInProfileViewController(profileViewController: ProfileViewController) -> TGUser {
    	//return user whos profile is to be displayed
        return TGUser.currentUser()
    }
    
    func profileViewController(profileViewController: ProfileViewController, didSelectConnectionsOfType connectionType: ConnectionType, forUser user: TGUser) {
    //add handling for when a connection type was selected for the displayed user  
    }
    
    func profileViewController(profileViewcontroller: ProfileViewController, didSelectEvent event: TGEvent) {
        //add handling for when an event was selected on the user profile
    }
}
```

### Connections View Controller

To use the connections view controller add it as a child view controller and sub view in your view controller

```swift
import UIKit
import elements
import Tapglue

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.connectionsViewController()
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
}
```

If you want to make use of the delegate be sure to assign the connections view controllers delegate

```swift
import UIKit
import elements
import Tapglue

class ViewController: UIViewController, ConnectionsViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.connectionsViewController()
        vc.delegate = self
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    func defaultNavigationEnabledInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> Bool {
        //answer if you want to override navigation or not
        return false
    }
    
    func referenceUserInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> TGUser {
        	//return user whos connections is to be displayed
            return TGUser.currentUser()
    }
    func connectionTypeInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> ConnectionType {
        //return the type of connections to be displayed, can be either
        // ConnectionType.Followers or ConnectionType.Following
        return ConnectionType.Followers
    }
    
    func connectionsViewController(connectionsViewController: ConnectionsViewController, didSelectUser user: TGUser) {
        //handle event when a connection is tapped
    }
}
```

### Notifications Feed View Controller

To use the notification feed view controller add it as a child view controller and child view of your view controller.

```swift
import UIKit
import elements

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.notificationFeedViewController()
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
}
```

If you want to make use of the delegate be sure to assign the notification feed view controllers delegate. For the notification screen this is specially interesting as we don't provide a news feed and this is the place where you can link back to posts.

```swift
import UIKit
import elements
import Tapglue

class ViewController: UIViewController, NotificationFeedViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.notificationFeedViewController()
        vc.delegate = self
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    func defaultNavigationEnabledInNotificationFeedViewController(notificationFeedViewController: NotificationFeedViewController) -> Bool {
        //answer if you want to override navigation or not
        return false
    }
    
    func notificationFeedViewController(noticationFeedViewController: NotificationFeedViewController, didSelectEvent event: TGEvent) {
       //add handling for when an event was selected on the user profile
    }
}

```

### User Search View Controller

To use the user search view controller add it as a child view controller and child view of your view controller.

```swift
import UIKit
import elements
import Tapglue

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.userSearchViewController()
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
}
```

If you want to make use of the delegate be sure to assign the user search view controllers delegate

```swift
import UIKit
import elements
import Tapglue

class ViewController2: UIViewController, UserSearchViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.userSearchViewController()
        vc.delegate = self
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        
        self.addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    func defaultNavigationEnabledInUserSearchViewController(userSearchViewController: UserSearchViewController) -> Bool {
         //answer if you want to override navigation or not
        return false
    }
    
    func userSearchViewController(userSearchViewController: UserSearchViewController, didSelectUser user: TGUser) {
        //handle event when a user is tapped
    }
    
    func didTapAddressBookInUserSearchViewController(userSearchViewController: UserSearchViewController) {
     		//handle event when address book search is requested   
    }
}
```
