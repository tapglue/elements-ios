//
//  FollowButton.swift
//  Pods
//
//  Created by John Rikard Nilsen on 17/2/16.
//
//

import UIKit
import Tapglue

class FollowButton: UIButton {
    
    func setStateForUser(user: TGUser){
        if user == TGUser.currentUser() {
            hidden = true
        }
        else if user.isFollowed {
            setToFollowed()
        } else {
            setToFollow()
        }
    }
    
    func setToFollowed() {
        setTitle("Followed", forState: .Normal)
        backgroundColor = UIColor.blueColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func setToFollow() {
        setTitle("Follow", forState: .Normal)
        backgroundColor = UIColor.whiteColor()
        setTitleColor(UIColor.blueColor(), forState: .Normal)
    }

}
