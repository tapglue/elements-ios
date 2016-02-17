//
//  ConnectionCell.swift
//  Pods
//
//  Created by John Rikard Nilsen on 16/2/16.
//
//

import UIKit
import Tapglue

class ConnectionCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var button: FollowButton!
    
    var delegate: ConnectionCellDelegate?
    var buttonAction: (() -> Void)?
    
    var user: TGUser? {
        didSet {
            updateUser()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUser() {
        if let user = user {
            userName.text = user.username
            profilePicture.setUserPicture(user)
            button.setStateForUser(user)
            if user.isFollowed {
                setButtonToFollowed()
            } else {
                setButtonToFollow()
            }
        }
    }

    func setButtonToFollow() {
        if let user = user {
            buttonAction = {() -> Void in
                self.button.enabled = false
                Tapglue.followUser(user, withCompletionBlock: { (success, error:NSError!) -> Void in
                    if success {
                        dispatch_async(dispatch_get_main_queue()) {() -> Void in
                            self.button.enabled = true
                            self.button.followState = .Followed
                            self.setButtonToFollowed()
                        }
                    } else {
                        self.handleError()
                    }
                })
            }
        }
    }
    
    func setButtonToFollowed() {
        if let user = user {
            buttonAction = {() -> Void in
                self.button.enabled = false
                Tapglue.unfollowUser(user, withCompletionBlock: { (success: Bool, error:NSError!) -> Void in
                    if success {
                        dispatch_async(dispatch_get_main_queue()) {() -> Void in
                            self.button.enabled = true
                            self.button.followState = .Follow
                            self.setButtonToFollow()
                        }
                    } else {
                        self.handleError()
                    }
                })
            }
        }
    }
    
    @IBAction func buttonTap() {
        if let buttonAction = buttonAction {
            buttonAction()
        }
    }
    
    func handleError() {
        delegate?.connectionCellErrorOcurred()
    }
}

protocol ConnectionCellDelegate {
    func connectionCellErrorOcurred()
}