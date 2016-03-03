//
//  ProfileBiographyView.swift
//  Pods
//
//  Created by John Rikard Nilsen on 9/2/16.
//
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