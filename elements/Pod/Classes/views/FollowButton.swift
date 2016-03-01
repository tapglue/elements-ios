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
    
    var user: TGUser? {
        didSet {
            setStateForUser()
            addTarget(self, action: "followPressed", forControlEvents: .TouchUpInside)
        }
    }
    
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
    var errorHandler: (() -> Void)?
    private var buttonAction: (() -> Void)?
    
    private func setStateForUser(){
        if let user = user {
            if user.userId == TGUser.currentUser().userId {
                followState = .CurrentUser
            }
            else if user.isFollowed {
                followState = .Followed
            } else {
                followState = .Follow
            }
        }
    }
    
    func followPressed() {
        if let buttonAction = buttonAction {
            buttonAction()
        }
    }
    
    private func setToFollowed() {
        setTitle("Followed", forState: .Normal)
        backgroundColor = UIColor.blueColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonAction = {() -> Void in
            self.enabled = false
            Tapglue.unfollowUser(self.user, withCompletionBlock: { (success: Bool, error:NSError!) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue()) {() -> Void in
                        self.enabled = true
                        self.followState = .Follow
                        self.setToFollow()
                    }
                } else {
                    self.errorHandler?()
                }
            })
        }
    }
    
    private func setToFollow() {
        setTitle("Follow", forState: .Normal)
        backgroundColor = UIColor.whiteColor()
        setTitleColor(UIColor.blueColor(), forState: .Normal)
        buttonAction = {() -> Void in
            self.enabled = false
            Tapglue.followUser(self.user, withCompletionBlock: { (success, error:NSError!) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue()) {() -> Void in
                        self.enabled = true
                        self.followState = .Followed
                        self.setToFollowed()
                    }
                } else {
                   self.errorHandler?()
                }
            })
        }
    }
}
