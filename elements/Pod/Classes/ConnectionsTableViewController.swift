//
//  ConnectionsViewControllerTableViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 11/2/16.
//
//

import UIKit
import Tapglue


@objc public enum ConnectionType: Int {
    case Followers, Following
}

class ConnectionsTableViewController: UITableViewController, ConnectionCellDelegate {

    var type: ConnectionType?
    var referenceUser: TGUser?
    var usersToDisplay = [TGUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let cellNib = UINib(nibName: "ConnectionCell", bundle: NSBundle(forClass: ProfileViewController.self))
        tableView.registerNib(cellNib, forCellReuseIdentifier: "ConnectionCell")
        tableView.rowHeight = 80
        
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
        let connectionCell = tableView.dequeueReusableCellWithIdentifier("ConnectionCell", forIndexPath: indexPath) as! ConnectionCell
        let user = usersToDisplay[indexPath.row]
        connectionCell.user = user
        connectionCell.delegate = self

        return connectionCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("toProfile", sender: usersToDisplay[indexPath.row])
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    // MARK: - Connection cell 
    
    func connectionCellErrorOcurred() {
        let alert = UIAlertController(title: "Something went wrong", message: "please try again later", preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated:true, completion: nil)
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
