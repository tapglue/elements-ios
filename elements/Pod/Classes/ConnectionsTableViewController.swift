//
//  ConnectionsViewControllerTableViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 11/2/16.
//
//

import UIKit
import Tapglue


@objc enum ConnectionType: Int {
    case Followers, Following
}

class ConnectionsTableViewController: UITableViewController {

    var type: ConnectionType?
    var referenceUser: TGUser?
    var usersToDisplay = [TGUser]()
    var currentUsersConnections = [TGUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let type = type {
            switch type {
            case .Followers:
                self.title = "Followers"
                Tapglue.retrieveFollowersForUser(referenceUser, withCompletionBlock: { (followers: [AnyObject]!,error: NSError!) -> Void in
                    Tapglue.retrieveFollowersForCurrentUserWithCompletionBlock { (currentUsersFollowers: [AnyObject]!, error:NSError!) -> Void in
                        self.setUsersAndReload(followers as! [TGUser], currentUsersConnections:currentUsersFollowers as! [TGUser])
                    }
                    }
                )
            case .Following:
                self.title = "Following"
                Tapglue.retrieveFollowsForUser(referenceUser, withCompletionBlock: { (follows: [AnyObject]!,error: NSError!) -> Void in
                    Tapglue.retrieveFollowersForCurrentUserWithCompletionBlock { (currentUsersFollows: [AnyObject]!, error:NSError!) -> Void in
                        self.setUsersAndReload(follows as! [TGUser], currentUsersConnections:currentUsersFollows as! [TGUser] )
                    }
                    }
                )

            }
        }
    }
    
    private func setUsersAndReload(users: [TGUser], currentUsersConnections: [TGUser]) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.usersToDisplay = users
            self.currentUsersConnections = currentUsersConnections
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersToDisplay.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("followsCell", forIndexPath: indexPath)
        let userName = cell.viewWithTag(1000) as! UILabel
        let button = cell.viewWithTag(2000) as! UIButton
        let profilePicture = cell.viewWithTag(3000) as! UIImageView
        let user = usersToDisplay[indexPath.row]
        profilePicture.setUserPicture(user)
        
        if user == TGUser.currentUser() {
            button.hidden = true
        }
        else if currentUsersConnections.contains(user) {
            button.setTitle("Following", forState: .Normal)
            button.backgroundColor = UIColor.blueColor()
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        } else {
            button.setTitle("Follow", forState: .Normal)
        }
        user.userId
        userName.text = user.username

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toProfile", sender: usersToDisplay[indexPath.row])
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toProfile" {
            let vc = segue.destinationViewController as! ProfileViewController
            let user = sender as! TGUser
            vc.userId = user.userId
        }
    }
}
