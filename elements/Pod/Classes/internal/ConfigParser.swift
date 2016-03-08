//
//  ConfigParser.swift
//  Pods
//
//  Created by John Rikard Nilsen on 3/3/16.
//
//

import Foundation

class ConfigParser {

    func parse(data: NSData) throws  -> Config{
        let configDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        let navigationBarColor = UIColor.colorFromHexString(configDictionary["navigationBarColor"] as! String)
        let navigationBarTextColor = UIColor.colorFromHexString(configDictionary["navigationBarTextColor"] as! String)
        let backgroundColor = UIColor.colorFromHexString(configDictionary["backgroundColor"] as! String)
        let followBtnDictionary = configDictionary["followButton"] as! [String: AnyObject]
       let followButtonConfig = FollowButtonParser.parse(followBtnDictionary)
        
        return Config(navigationBarColor: navigationBarColor, navigationBarTextColor: navigationBarTextColor, backgroundColor: backgroundColor, followButtonConfig: followButtonConfig)
    }
}
