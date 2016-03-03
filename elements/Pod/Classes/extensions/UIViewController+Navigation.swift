//
//  UIViewController+Navigation.swift
//  Pods
//
//  Created by John Rikard Nilsen on 1/3/16.
//
//

import UIKit

extension UIViewController {

    func popViewController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}