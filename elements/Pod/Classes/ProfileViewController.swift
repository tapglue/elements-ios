//
//  ProfileViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 8/2/16.
//
//

import UIKit
import Tapglue

class ProfileViewController: UIViewController, ProfileBiographyDelegate {

    @IBOutlet weak var profileBiographyView: ProfileBiographyView!
    
    var tapConnectionType: ConnectionType?
    var userId: String?
    var user: TGUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        profileBiographyView.delegate = self
        if let userId = userId {
            retrieveAndSetUserWithId(userId)
        } else if let currentUser = TGUser.currentUser() {
            user = currentUser
            profileBiographyView.user = currentUser
            if let user = user {
                retrieveAndSetUserWithId(user.userId)
            }
        }
    }
    
    func retrieveAndSetUserWithId(userId: String) {
        Tapglue.retrieveUserWithId(userId, withCompletionBlock:{(retrievedUser, error) -> Void in
            if error != nil {
                print("could not retrieve user! Show error")
            } else {
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.profileBiographyView.user = retrievedUser
                    self.user = retrievedUser
                })
            }
        })
    }
    
    func profileBiographyViewFollowersSelected() {
        tapConnectionType = ConnectionType.Followers
        performSegueWithIdentifier("toConnections", sender: user)
    }
    
    func profileBiographyViewFollowingSelected() {
        tapConnectionType = ConnectionType.Following
        performSegueWithIdentifier("toConnections", sender: user)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toConnections" {
            let connectionsVC = segue.destinationViewController as! ConnectionsTableViewController
            connectionsVC.type = tapConnectionType
            connectionsVC.referenceUser = sender as? TGUser
        }
    }

}
