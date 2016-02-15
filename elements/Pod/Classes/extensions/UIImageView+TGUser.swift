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
            self.setUrlImage(imageUrl)
        }
    }
}