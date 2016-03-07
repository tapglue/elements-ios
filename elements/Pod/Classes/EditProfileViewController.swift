//
//  EditProfileViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 23/2/16.
//
//

import UIKit
import Tapglue

class EditProfileViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = TGUser.currentUser().username
        
        let save = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveTapped")
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
