//
//  ManualProfileViewController.swift
//  elements
//
//  Created by John Rikard Nilsen on 9/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import elements

class ManualProfileViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("manual profile VC")
        
        let vc = TapglueUI.profileViewController()
        
        vc.view.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)

        self.addChildViewController(vc)
        containerView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
}
