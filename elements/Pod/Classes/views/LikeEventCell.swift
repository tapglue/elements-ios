//
//  LikeEventCell.swift
//  Pods
//
//  Created by John Rikard Nilsen on 25/2/16.
//
//

import UIKit
import Tapglue

class LikeEventCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: TGUser? {
        didSet {
            if let user = user {
                userNameLabel.text = user.username
            }
        }
    }
}
