//
//  TapglueUI.swift
//  Pods
//
//  Created by John Rikard Nilsen on 9/2/16.
//
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
    
    public static func performSegueToProfile(caller: UIViewController) {
        let vc = profileStoryboard().instantiateInitialViewController()!
        caller.presentViewController(vc, animated: true, completion: nil)
    }
    
    public static func performSegueToNotificationFeed(caller: UIViewController) {
        let vc = notificationStoryboard().instantiateInitialViewController()!
        caller.presentViewController(vc, animated: true, completion: nil)
    }
    
    public static func profileViewController() -> ProfileViewController {
        return profileStoryboard().instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
    }
    
    public static func notificationFeedViewController() -> NotificationFeedViewController {
        return notificationStoryboard().instantiateViewControllerWithIdentifier("NotificationFeedViewController") as! NotificationFeedViewController
    }
    
    public static func connectionsViewController() -> ConnectionsViewController {
        return profileStoryboard().instantiateViewControllerWithIdentifier("ConnectionsViewController") as! ConnectionsViewController
    }
    
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
        
        let bundleURL = podBundle.URLForResource("elements", withExtension: "bundle")
        return NSBundle(URL: bundleURL!)!
    }
}
