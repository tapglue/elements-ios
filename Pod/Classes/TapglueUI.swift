//
//  TapglueUI.swift
//  Tapglue Elements
//
//  Created by John Nilsen  on 14/03/16.
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

import Foundation
import UIKit
import Tapglue

public class TapglueUI {
    
    static let expectedConfigVersion = 1
    
    static let acceptedEventTypes = ["tg_follow", "tg_like"]
    
    static var config = Config()
    
    public init() {
    }
    
    public static func setConfig(config: NSData) throws {
        TapglueUI.config = try ConfigParser().parse(config)
    }
    
    /**
     performs segue to elements profile screen
     - Parameter caller: calling UIViewController
    */
    public static func performSegueToProfile(caller: UIViewController) {
        let vc = profileStoryboard().instantiateInitialViewController()!
        caller.presentViewController(vc, animated: true, completion: nil)
    }
    
    /**
     performs segue to elements notification screen
     - Parameter caller: calling UIViewController
     */
    public static func performSegueToNotificationFeed(caller: UIViewController) {
        let vc = notificationStoryboard().instantiateInitialViewController()!
        caller.presentViewController(vc, animated: true, completion: nil)
    }
    
    /**
     instantiates a profile view controller from elements
     - Returns: elements profile view controller
     */
    public static func profileViewController() -> ProfileViewController {
        return profileStoryboard().instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
    }

    /**
     instantiates a notification feed view controller from elements
     - Returns: elements notification feed view controller
     */
    public static func notificationFeedViewController() -> NotificationFeedViewController {
        return notificationStoryboard().instantiateViewControllerWithIdentifier("NotificationFeedViewController") as! NotificationFeedViewController
    }
    
    /**
     instantiates a connections view controller from elements
     - Returns: elements connections view controller
     */
    public static func connectionsViewController() -> ConnectionsViewController {
        return profileStoryboard().instantiateViewControllerWithIdentifier("ConnectionsViewController") as! ConnectionsViewController
    }

    /**
     instantiates a user search view controller from elements
     - Returns: elements user search view controller
     */
    public static func userSearchViewController() -> UserSearchViewController {
        return profileStoryboard().instantiateViewControllerWithIdentifier("UserSearchViewController") as! UserSearchViewController
    }
    
    private static func profileStoryboard() -> UIStoryboard {
        return UIStoryboard (name: "ProfileStoryboard", bundle: getBundle())
    }
    
    private static func notificationStoryboard() -> UIStoryboard {
        return UIStoryboard (
            name: "NotificationStoryboard", bundle: getBundle()
        )
    }
    
    static func getBundle() -> NSBundle {
        let podBundle = NSBundle(forClass: ProfileViewController.self)
        
        let bundleURL = podBundle.URLForResource("Elements", withExtension: "bundle")
        return NSBundle(URL: bundleURL!)!
    }
}
