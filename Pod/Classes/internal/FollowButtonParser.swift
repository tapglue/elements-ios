//
//  FollowButtonParser.swift
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

class FollowButtonParser {
    static func parse(followBtnDictionary: [String: AnyObject]) -> FollowButtonConfig {
        let defaultFollowButton = FollowButtonConfig()
        
        let notFollowedColor = ColorUtil.configColorFromHex(followBtnDictionary["notFollowedColor"] as? String,
            orDefault: defaultFollowButton.notFollowed)
        let notFollowedTextColor = ColorUtil.configColorFromHex(followBtnDictionary["notFollowedTextColor"] as? String,
            orDefault: defaultFollowButton.notFollowedText)
        let followedColor = ColorUtil.configColorFromHex(followBtnDictionary["followedColor"] as? String,
            orDefault: defaultFollowButton.followed)
        let followedTextColor = ColorUtil.configColorFromHex(followBtnDictionary["followedTextColor"] as? String,
            orDefault: defaultFollowButton.followedText)
        let border = ColorUtil.configColorFromHex(followBtnDictionary["borderColor"] as? String,
            orDefault: defaultFollowButton.border)
        
        return FollowButtonConfig(notFollowed: notFollowedColor, notFollowedText: notFollowedTextColor,
            followed: followedColor, followedText: followedTextColor, border: border)
    }
}