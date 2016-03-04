//
//  UIViewController+Config.swift
//  Pods
//
//  Created by John Rikard Nilsen on 4/3/16.
//
//

import UIKit

extension UIViewController {
    func applyConfiguration(config: Config) {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = TapglueUI.config.navigationBarColor
            navigationBar.tintColor = TapglueUI.config.navigationBarTextColor
            navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: TapglueUI.config.navigationBarTextColor]
        }
        view.backgroundColor = config.backgroundColor
    }
}
