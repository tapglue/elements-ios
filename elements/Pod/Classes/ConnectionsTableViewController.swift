//
//  ConnectionsViewControllerTableViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 11/2/16.
//
//

import UIKit
import Tapglue

public class ConnectionsViewController: UITableViewController, ConnectionCellDelegate {

    var type: ConnectionType?
    var referenceUser: TGUser?
    var usersToDisplay = [TGUser]()
    public var delegate: ConnectionsViewDelegate? {
        didSet {
            type = delegate?.connectionTypeInConnectionsViewController(self)
            referenceUser = delegate?.referenceUserInConnectionsViewController(self)
        }
    }

    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let search = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchTapped")
        navigationItem.rightBarButtonItem = search
    }
    
    override public func viewWillAppear(animated: Bool) {
        let cellNib = UINib(nibName: "ConnectionCell", bundle: NSBundle(forClass: ProfileViewController.self))
        tableView.registerNib(cellNib, forCellReuseIdentifier: "ConnectionCell")
        tableView.rowHeight = 80
        
        if let type = type {
            switch type {
            case .Followers:
                self.title = "Followers"
                Tapglue.retrieveFollowersForUser(referenceUser, withCompletionBlock: { (followers: [AnyObject]!,error: NSError!) -> Void in
                    if error == nil {
                        self.setUsersAndReload(followers as! [TGUser])
                    } else {
                        print("ERROR! \(error)")
                    }
                    }
                )
            case .Following:
                self.title = "Following"
                Tapglue.retrieveFollowsForUser(referenceUser, withCompletionBlock: { (follows: [AnyObject]!,error: NSError!) -> Void in
                    //TODO: add error handling
                    if error == nil {
                        self.setUsersAndReload(follows as! [TGUser])
                    } else {
                        print("ERROR! \(error)")
                    }
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
    
    func searchTapped() {
        print("tapped search")
        if delegate?.defaultNavigationEnabledInConnectionsViewController(self) ?? true {
            performSegueWithIdentifier("toUserSearch", sender: nil)
        }
    }

    // MARK: - Table view data source

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersToDisplay.count
    }

    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let connectionCell = tableView.dequeueReusableCellWithIdentifier("ConnectionCell", forIndexPath: indexPath) as! ConnectionCell
        let user = usersToDisplay[indexPath.row]
        connectionCell.user = user
        connectionCell.delegate = self

        return connectionCell
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if delegate?.defaultNavigationEnabledInConnectionsViewController(self) ?? true {
            performSegueWithIdentifier("toProfile", sender: usersToDisplay[indexPath.row])
            tableView.deselectRowAtIndexPath(indexPath, animated:true)
        } else {
            delegate?.connectionsViewController(self, didSelectUser: usersToDisplay[indexPath.row])
        }
    }
    
    // MARK: - Connection cell 
    
    func connectionCellErrorOcurred() {
        AlertFactory.defaultAlert(self)
    }

    // MARK: - Navigation

    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toProfile" {
            let vc = segue.destinationViewController as! ProfileViewController
            let user = sender as! TGUser
            vc.userId = user.userId
        }
    }
}

public protocol ConnectionsViewDelegate {
    func connectionTypeInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> ConnectionType
    func defaultNavigationEnabledInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> Bool
    func referenceUserInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> TGUser
    func connectionsViewController(connectionsViewController: ConnectionsViewController, didSelectUser: TGUser)
}