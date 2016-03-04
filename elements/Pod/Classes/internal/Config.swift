//
//  Config.swift
//  Pods
//
//  Created by John Rikard Nilsen on 3/3/16.
//
//

import UIKit

class Config {

    let navigationBarColor: UIColor
    let navigationBarTextColor: UIColor
    let backgroundColor: UIColor
    
    init() {
        navigationBarColor = UIColor.whiteColor()
        navigationBarTextColor = UIColor.blackColor()
        backgroundColor = UIColor.whiteColor()
    }
    
    init(navigationBarColor: UIColor, navigationBarTextColor: UIColor, backgroundColor: UIColor) {
        self.navigationBarColor = navigationBarColor
        self.navigationBarTextColor = navigationBarTextColor
        self.backgroundColor = backgroundColor
    }
}