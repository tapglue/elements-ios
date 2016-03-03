//
//  ViewController.swift
//  elements
//
//  Created by John Nilsen on 02/08/2016.
//  Copyright (c) 2016 John Nilsen. All rights reserved.
//

import UIKit
import elements
import Tapglue

class ViewController: UIViewController {
    
    let elements = TapglueUI()
    
    let username = "john"
    let password = "qwert"
    var isLoggedIn = false
    
    override func viewDidAppear(animated: Bool) {
        Tapglue.createAndLoginUserWithUsername(username, andPassword: password, withCompletionBlock:{ (success: Bool, error: NSError!) -> Void in
            if error != nil {
                print("\nError loginWithUsernameOrEmail: \(error)")
            } else {
                print("\nUser logged in: \(success)")
                self.isLoggedIn = true
            }
        })
    }
    @IBAction func notificationsTap(sender: AnyObject) {
        if isLoggedIn {
            elements.performSegueToNotificationFeed(self)
        }
    }
    @IBAction func profileTap(sender: AnyObject) {
        if isLoggedIn {
            elements.performSegueToProfile(self)
        }
    }
}
