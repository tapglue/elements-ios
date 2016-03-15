//
//  FollowButton.swift
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

enum FollowState{
    case CurrentUser, Followed, Follow, None
}

class FollowButton: UIButton {
    
    var followConfig: FollowButtonConfig?
    
    var user: TGUser? {
        didSet {
            followConfig = TapglueUI.config.followButtonConfig
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
        hidden = false
        setTitle("Followed", forState: .Normal)
        backgroundColor = followConfig!.followed
        setTitleColor(followConfig!.followedText, forState: .Normal)
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
        hidden = false
        setTitle("Follow", forState: .Normal)
        backgroundColor = followConfig!.notFollowed
        setTitleColor(followConfig!.notFollowedText, forState: .Normal)
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
