//
//  FollowButton.swift
//  Pods
//
//  Created by John Rikard Nilsen on 17/2/16.
//
//

import UIKit
import Tapglue

enum FollowState{
    case CurrentUser, Followed, Follow, None
}

class FollowButton: UIButton {
    
    var followState = FollowState.None {
        didSet {
            if followState == .CurrentUser {
                hidden = true
            } else if followState == .Followed {
                setToFollowed()
            } else if followState == .Follow {
                setToFollow()
            }
        }
    }
    
    func setStateForUser(user: TGUser){
        if user == TGUser.currentUser() {
            followState = .CurrentUser
        }
        else if user.isFollowed {
            followState = .Followed
        } else {
            followState = .Follow
        }
    }
    
    private func setToFollowed() {
        setTitle("Followed", forState: .Normal)
        backgroundColor = UIColor.blueColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    private func setToFollow() {
        setTitle("Follow", forState: .Normal)
        backgroundColor = UIColor.whiteColor()
        setTitleColor(UIColor.blueColor(), forState: .Normal)
    }

}
