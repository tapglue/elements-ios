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
    
    private static func profileStoryboard() -> UIStoryboard {
        return UIStoryboard (name: "ProfileStoryboard", bundle: NSBundle(forClass: ProfileViewController.self))
    }
    
    private static func notificationStoryboard() -> UIStoryboard {
        return UIStoryboard (
            name: "NotificationStoryboard", bundle: NSBundle(forClass: NotificationFeedViewController.self)
        )
    }
}
