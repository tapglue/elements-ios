//
//  UIImageView+TGUser.swift
//  Pods
//
//  Created by John Rikard Nilsen on 15/2/16.
//
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