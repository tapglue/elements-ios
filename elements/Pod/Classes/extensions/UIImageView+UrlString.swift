//
//  UIImageView+UrlString.swift
//  Pods
//
//  Created by John Rikard Nilsen on 15/2/16.
//
//

import UIKit

extension UIImageView {
    func setUrlImage(url: String) {
        let imageUrl = url
        let imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        
        dispatch_async(imageQueue) {() -> Void in
            let url = NSURL(string: imageUrl)
            let data = NSData(contentsOfURL: url!)
            if let data = data {
                dispatch_async(dispatch_get_main_queue()) {() -> Void in
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}