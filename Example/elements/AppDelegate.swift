//
//  AppDelegate.swift
//  elements
//
//  Created by John Nilsen on 02/08/2016.
//  Copyright (c) 2016 John Nilsen. All rights reserved.
//

import UIKit
import Tapglue
import elements

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let sampleToken = "1ecd50ce4700e0c8f501dee1fb271344"
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let tgConfig = TGConfiguration.defaultConfiguration()
//        UILabel.appearance().fontName = "Avenir-LightOblique"
        tgConfig.loggingEnabled = true
        Tapglue.setUpWithAppToken(sampleToken, andConfig: tgConfig)
        
        if let path = NSBundle.mainBundle().pathForResource("config", ofType: "json"){
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                try TapglueUI.setConfig(data)
            } catch let error as NSError {
                print("could not load config file! Error: \(error)")
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

