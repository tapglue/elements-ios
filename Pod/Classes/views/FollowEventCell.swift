//
//  LikeEventCell.swift
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

class FollowEventCell: UITableViewCell {

    @IBOutlet weak var followTextLabel: UILabel!
    @IBOutlet weak var followedUserImageView: UIImageView!
    
    var event: TGEvent? {
        didSet {
            if let event = event {
                followingUser = event.user
                followedUser = event.target.user
                let userNameAttributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(16)]
                let followingUserName = followingUser!.firstName + " " + followingUser!.lastName
                
                let followText = NSMutableAttributedString(string:followingUserName, attributes:userNameAttributes)
                followText.appendAttributedString(NSMutableAttributedString(string:" started following "))
                let followedUserName = followedUser!.firstName + " " + followedUser!.lastName
                followText.appendAttributedString(NSMutableAttributedString(string:followedUserName, attributes: userNameAttributes))
                followTextLabel.attributedText = followText
                
            }
        }
    }
    
    private(set) var followingUser: TGUser? {
        didSet {
            if let user = followingUser {
                followTextLabel.text = user.username
            }
        }
    }
    private(set) var followedUser: TGUser? {
        didSet {
            if let user = followedUser {
                followedUserImageView.setUserPicture(user)
            }
        }
    }
}
