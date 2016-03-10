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
    
    public func performSegueToProfile(caller: UIViewController) {
        let s = UIStoryboard (
            name: "ProfileStoryboard", bundle: NSBundle(forClass: ProfileViewController.self)
        )
        let vc = s.instantiateInitialViewController()!
        caller.presentViewController(vc, animated: true, completion: nil)
    }
    
    public func performSegueToNotificationFeed(caller: UIViewController) {
        let s = UIStoryboard (
            name: "NotificationStoryboard", bundle: NSBundle(forClass: NotificationFeedViewController.self)
        )
        let vc = s.instantiateInitialViewController()!
        caller.presentViewController(vc, animated: true, completion: nil)
    }
    
    public func performSegueToConnections(caller: UIViewController, forUser user: TGUser, andForType type: ConnectionType) {
        let s = UIStoryboard (
            name: "ProfileStoryboard", bundle: NSBundle(forClass: ProfileViewController.self)
        )
        let connectionsVC = s.instantiateViewControllerWithIdentifier("ConnectionsViewController") as! ConnectionsViewController
        
        connectionsVC.type = type
        connectionsVC.referenceUser = user
        
        caller.presentViewController(connectionsVC, animated: true, completion: nil)
    }
    
    public static func profileViewController() -> ProfileViewController {
        let s = UIStoryboard (name: "ProfileStoryboard", bundle: NSBundle(forClass: ProfileViewController.self))
        return s.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
    }
    
    public static func notificationFeedViewController() -> NotificationFeedViewController {
        let s = UIStoryboard (
            name: "NotificationStoryboard", bundle: NSBundle(forClass: NotificationFeedViewController.self)
        )
        return s.instantiateViewControllerWithIdentifier("NotificationFeedViewController") as! NotificationFeedViewController
    }
}
