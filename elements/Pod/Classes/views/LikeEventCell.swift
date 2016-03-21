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

class LikeEventCell: UITableViewCell {
    
    @IBOutlet weak var likeEventImage: UIImageView!
    @IBOutlet weak var likeEventLabel: UILabel!
    var event: TGEvent? {
        didSet {
            if let event = event {
                likeEventLabel.text = event.user!.username + " liked " + event.post.user.username + "'s post"
                user = event.user
            }
        }
    }
    
    private var user: TGUser? {
        didSet {
            if let user = user {
                likeEventImage.setUserPicture(user)
            }
        }
    }
}
