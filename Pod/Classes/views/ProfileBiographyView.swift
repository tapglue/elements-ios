//
//  ProfileBiographyView.swift
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

@IBDesignable class ProfileBiographyView: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followerCount: UIButton!
    @IBOutlet weak var followingCount: UIButton!

    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followButton: FollowButton!
    
    var delegate: ProfileBiographyDelegate?
    
    var user: TGUser? {
        didSet{
            if let user = user {
                username.text = user.username
                followerCount.setTitle(String(user.followersCount), forState: .Normal)
                followingCount.setTitle(String(user.followingCount), forState: .Normal)
                followButton.user = user
                followButton.errorHandler = {() -> Void in
                    self.handleError()
                }
                loadImage()
            }
        }
    }
    
    func handleError() {
        delegate?.profileBiographyViewErrorOcurred(self)
    }
    
    func loadImage() {
        profilePicture.setUserPicture(user!)
    }

    @IBAction func followingTap() {
        delegate?.profileBiographyViewFollowingSelected()
    }
    
    
    @IBAction func followerTap() {
        delegate?.profileBiographyViewFollowersSelected()
    }
}

protocol ProfileBiographyDelegate {
    func profileBiographyViewErrorOcurred(profileBiographyView: ProfileBiographyView)
    func profileBiographyViewFollowersSelected()
    func profileBiographyViewFollowingSelected()
}