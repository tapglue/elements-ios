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
    let followButtonConfig: FollowButtonConfig
    
    init() {
        navigationBarColor = UIColor.whiteColor()
        navigationBarTextColor = UIColor.blackColor()
        backgroundColor = UIColor.whiteColor()
        followButtonConfig = FollowButtonConfig()
    }
    
    init(navigationBarColor: UIColor, navigationBarTextColor: UIColor, backgroundColor: UIColor, followButtonConfig: FollowButtonConfig) {
        self.navigationBarColor = navigationBarColor
        self.navigationBarTextColor = navigationBarTextColor
        self.backgroundColor = backgroundColor
        self.followButtonConfig = followButtonConfig
    }
}

class FollowButtonConfig {
    let notFollowed: UIColor
    let notFollowedText: UIColor
    let followed: UIColor
    let followedText: UIColor
    
    init() {
        notFollowed = UIColor.whiteColor()
        notFollowedText = UIColor.blueColor()
        followed = UIColor.blueColor()
        followedText = UIColor.whiteColor()
    }
    
    init(notFollowed: UIColor, notFollowedText: UIColor, followed: UIColor, followedText: UIColor) {
        self.notFollowed = notFollowed
        self.notFollowedText = notFollowedText
        self.followed = followed
        self.followedText = followedText
    }
}