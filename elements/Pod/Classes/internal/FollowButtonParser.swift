//
//  FollowButtonParser.swift
//  Pods
//
//  Created by John Rikard Nilsen on 7/3/16.
//
//

import UIKit

class FollowButtonParser {
    static func parse(followBtnDictionary: [String: AnyObject]) -> FollowButtonConfig {
        let notFollowedColor = UIColor.colorFromHexString(followBtnDictionary["notFollowedColor"] as! String)
        let notFollowedTextColor = UIColor.colorFromHexString(followBtnDictionary["notFollowedTextColor"] as! String)
        let followedColor = UIColor.colorFromHexString(followBtnDictionary["followedColor"] as! String)
        let followedTextColor = UIColor.colorFromHexString(followBtnDictionary["followedTextColor"] as! String)
        
        
        return FollowButtonConfig(notFollowed: notFollowedColor, notFollowedText: notFollowedTextColor, followed: followedColor, followedText: followedTextColor)
    }
}