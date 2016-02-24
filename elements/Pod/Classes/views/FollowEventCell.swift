//
//  LikeEventCell.swift
//  Pods
//
//  Created by John Rikard Nilsen on 24/2/16.
//
//

import UIKit
import Tapglue

class FollowEventCell: UITableViewCell {

    @IBOutlet weak var followingUserLabel: UILabel!
    @IBOutlet weak var followedUserLabel: UILabel!
    @IBOutlet weak var followedUserImageView: UIImageView!
    
    var followingUser: TGUser? {
        didSet {
            if let user = followingUser {
                followingUserLabel.text = user.username
            }
        }
    }
    var followedUser: TGUser? {
        didSet {
            if let user = followedUser {
                followedUserLabel.text = user.username
                followedUserImageView.setUserPicture(user)
            }
        }
    }
}