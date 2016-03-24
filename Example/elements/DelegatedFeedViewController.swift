//
//  DelegatedFeedViewController.swift
//  elements
//
//  Created by John Rikard Nilsen on 10/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import TapglueElements
import Tapglue

class DelegatedFeedViewController: UIViewController, NotificationFeedViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = TapglueUI.notificationFeedViewController()
        vc.delegate = self
        vc.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    func defaultNavigationEnabledInNotificationFeedViewController(notificationFeedViewController: NotificationFeedViewController) -> Bool {
        return false
    }
    
    func notificationFeedViewController(noticationFeedViewController: NotificationFeedViewController, didSelectEvent event: TGEvent) {
        print("tapped event! \(event)")
    }
}
