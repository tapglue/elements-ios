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

    let username = "john"
    let password = "qwert"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReplaceMe()
        Tapglue.createAndLoginUserWithUsername(username, andPassword: password, withCompletionBlock:{ (success: Bool, error: NSError!) -> Void in
            if error != nil {
                print("\nError loginWithUsernameOrEmail: \(error)")
            } else {
                print("\nUser logged in: \(success)")
                //                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //                    self.navigationController?.popToRootViewControllerAnimated(false)
                //                })
            }
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        let elements = TapglueUI()
        elements.performSegueToProfile(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

