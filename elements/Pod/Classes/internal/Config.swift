//
//  Config.swift
//  Tapglue Elements
//
//  Created by John Nilsen  on 14/03/16.
//  Copyright (c) 2015 Tapglue (https://www.tapglue.com/). All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

class Config {

    let navigationBarColor: UIColor
    let navigationBarTextColor: UIColor
    let backgroundColor: UIColor
    let roundedImages: Bool
    let followButtonConfig: FollowButtonConfig
    
    init() {
        navigationBarColor = UIColor.whiteColor()
        navigationBarTextColor = UIColor.blackColor()
        backgroundColor = UIColor.whiteColor()
        followButtonConfig = FollowButtonConfig()
        roundedImages = false
    }
    
    init(navigationBarColor: UIColor, navigationBarTextColor: UIColor, backgroundColor: UIColor, followButtonConfig: FollowButtonConfig, roundedImages: Bool) {
        self.navigationBarColor = navigationBarColor
        self.navigationBarTextColor = navigationBarTextColor
        self.backgroundColor = backgroundColor
        self.followButtonConfig = followButtonConfig
        self.roundedImages = roundedImages
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