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

    public var type: ConnectionType?
    public var referenceUser: TGUser?
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
        tableView.backgroundColor = UIColor.clearColor()
        applyConfiguration(TapglueUI.config)
    }
    
    override public func viewWillAppear(animated: Bool) {
        tableView.registerNibs(nibNames: ["ConnectionCell"])
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let type = type {
            switch type {
            case .Followers:
                self.title = "Followers"
                Tapglue.retrieveFollowersForUser(referenceUser, withCompletionBlock: { (followers: [AnyObject]!,error: NSError!) -> Void in
                    if error == nil {
                        self.setUsersAndReload(followers as! [TGUser])
                    } else {
                        AlertFactory.defaultAlert(self)
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
                        AlertFactory.defaultAlert(self)
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
    
    override public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
    override public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
    
    /**
     Asks delegate if the calling view controller should handle its own navigation
     - Parameter connectionsViewController: connections view controller object asking the delegate
     - Returns: boolean value to indicate if navigation should be handled or not
     */
    func defaultNavigationEnabledInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> Bool
    
    /**
     Asks delegate which users connections should be displayed
     - Parameter connectionsViewController: connections view controller object asking the delegate
     - Returns: user whos connections are to be displayed
    */
    func referenceUserInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> TGUser
    
    /**
     Asks delegate which `ConnectionType` should be displayed 
     - Parameter connectionsViewController: connections view controller object asking the delegate
     - Returns: `ConnectionType` to be returned
     */
    func connectionTypeInConnectionsViewController(connectionsViewController: ConnectionsViewController) -> ConnectionType
    
     /**
     Tells delegate that a user was selected
     - Parameters:
        - connectionsViewController: connections view controller object informing the delegate
        - user: user selected
    */
    func connectionsViewController(connectionsViewController: ConnectionsViewController, didSelectUser user: TGUser)
}