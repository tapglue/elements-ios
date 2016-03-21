//
//  UIImageView+UrlString.swift
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