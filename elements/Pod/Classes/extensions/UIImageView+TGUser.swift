//
//  UIImageView+TGUser.swift
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
import Tapglue

extension UIImageView {
    func setUserPicture(user: TGUser) {
        
        var userImage = TGImage()
        userImage = user.images.valueForKey("profilePic") as! TGImage
        
        if let imageUrl = userImage.url {
            if TapglueUI.config.roundedImages {
                layer.masksToBounds = false
                layer.cornerRadius = frame.height / 2
                clipsToBounds = true
            }
            self.setUrlImage(imageUrl)
        }
    }
}