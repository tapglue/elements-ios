//
//  TapglueUI.swift
//  Pods
//
//  Created by John Rikard Nilsen on 9/2/16.
//
//

import Foundation
import UIKit

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
}
