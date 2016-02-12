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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let type = type {
            switch type {
            case .Followers:
                self.title = "Followers"
                Tapglue.retrieveFollowersForUser(referenceUser, withCompletionBlock: { (followers: [AnyObject]!,error: NSError!) -> Void in
                        self.setUsersAndReload(followers as! [TGUser])
                    }
                )
            case .Following:
                self.title = "Following"
                Tapglue.retrieveFollowsForUser(referenceUser, withCompletionBlock: { (follows: [AnyObject]!,error: NSError!) -> Void in
                        self.setUsersAndReload(follows as! [TGUser])
                    }
                )

            }
        }
    }
    
    private func setUsersAndReload(users: [TGUser]) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.usersToDisplay = users
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
        let user = usersToDisplay[indexPath.row]
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
