//
//  AlertFactory.swift
//  Pods
//
//  Created by John Rikard Nilsen on 22/2/16.
//
//

import UIKit

class AlertFactory {

    static func defaultAlert(caller: UIViewController) {
        let alert = UIAlertController(title: "Something went wrong", message: "please try again later", preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        caller.presentViewController(alert, animated:true, completion: nil)
    }
}
