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
            button.user = user
            button.errorHandler = {() -> Void in
                self.handleError()
            }
        }
    }
    
    func handleError() {
        delegate?.connectionCellErrorOcurred()
    }
}

protocol ConnectionCellDelegate {
    func connectionCellErrorOcurred()
}