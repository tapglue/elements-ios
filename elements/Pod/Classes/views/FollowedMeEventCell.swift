//
//  FollowedMeEventCell.swift
//  Pods
//
//  Created by John Rikard Nilsen on 26/2/16.
//
//

import UIKit
import Tapglue

class FollowedMeEventCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var event: TGEvent? {
        didSet {
            if let event = event {
                user = event.user
            }
        }
    }
    
    private(set) var user: TGUser? {
        didSet {
            if let user = user {
                userLabel.text = user.username
                userImage.setUserPicture(user)
            }
        }
    }
}
