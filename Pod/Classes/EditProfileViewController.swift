//
//  EditProfileViewController.swift
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

class EditProfileViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = TGUser.currentUser().username
        
        let save = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(EditProfileViewController.saveTapped))
        navigationItem.rightBarButtonItem = save
        view.backgroundColor = UIColor.clearColor()
        applyConfiguration(TapglueUI.config)
    }
    
    func saveTapped() {
        navigationItem.rightBarButtonItem?.enabled = false
        let user = TGUser.currentUser()
        user.username = userNameTextField.text
        user.saveWithCompletionBlock { (success: Bool, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.navigationItem.rightBarButtonItem?.enabled = true
                if success {
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    AlertFactory.defaultAlert(self)
                }
            }
            
        }
    }
}
