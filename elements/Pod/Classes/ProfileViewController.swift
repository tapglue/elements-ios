//
//  ProfileViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 8/2/16.
//
//

import UIKit
import Tapglue

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileBiographyView: ProfileBiographyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("displaying profile...")
        if let user = TGUser.currentUser() {
            profileBiographyView.user = user
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
