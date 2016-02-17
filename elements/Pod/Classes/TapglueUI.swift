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
    
    public init() {
    }
    
    public func performSegueToProfile(caller: UIViewController) {
        let s = UIStoryboard (
            name: "ProfileStoryboard", bundle: NSBundle(forClass: ProfileViewController.self)
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
}
