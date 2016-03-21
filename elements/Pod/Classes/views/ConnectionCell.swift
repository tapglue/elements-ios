//
//  ConnectionCell.swift
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

class ConnectionCell: UITableViewCell {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var fullName: UILabel!
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
            fullName.text = user.firstName + " " + user.lastName
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