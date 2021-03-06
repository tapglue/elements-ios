//
//  ProfileViewController.swift
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

public class ProfileViewController: UIViewController, ProfileBiographyDelegate {

    let cellProfileBiographyReusableIdentifier = "ProfileBiographyView"
    let cellFollowEventReusableIdentifier = "FollowEventCell"
    let cellLikeEventReusableIdentifier = "LikeEventCell"
    
    let connectionsSegue = "toConnections"
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    var events = [TGEvent]()
    var tapConnectionType: ConnectionType?
    var userId: String?
    var user: TGUser? {
        didSet {
            if user?.isCurrentUser ?? false {
                let edit = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(ProfileViewController.editTapped))
                navigationItem.rightBarButtonItem = edit
            }
        }
    }
    public var delegate: ProfileViewDelegate? {
        didSet {
            user = delegate?.referenceUserInProfileViewController(self)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNibs(nibNames: [cellProfileBiographyReusableIdentifier, cellFollowEventReusableIdentifier, cellLikeEventReusableIdentifier])
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.addTarget(self, action: #selector(ProfileViewController.refresh(_:)), forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.backgroundColor = UIColor.clearColor()
        applyConfiguration(TapglueUI.config)
    }
    
    override public func viewWillAppear(animated: Bool) {
        if let userId = userId {
            retrieveAndSetUserWithId(userId)
        } else if let currentUser = TGUser.currentUser() {
            user = currentUser
            tableView.reloadData()
            if let user = user {
                retrieveAndSetUserWithId(user.userId)
            }
        }
        
        let n = self.navigationController!.viewControllers.count - 2
        if n < 0 {
            let backButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ProfileViewController.popViewController))
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    func retrieveAndSetUserWithId(userId: String) {
        Tapglue.retrieveUserWithId(userId, withCompletionBlock:{(retrievedUser, error) -> Void in
            if error != nil {
                AlertFactory.defaultAlert(self)
            } else {
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    self.user = retrievedUser
                    self.retrieveActivity()
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func editTapped() {
        performSegueWithIdentifier("toEditProfile", sender: nil)
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        // Do your job, when done:
        if let user = user {
            retrieveAndSetUserWithId(user.userId)
        } else {
            refreshControl.endRefreshing()
        }
    }

    
    func retrieveActivity() {
        Tapglue.retrieveEventsForUser(user) { (events: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {() -> Void in
                    let events = events as! [TGEvent]
                    self.events = events.filter({TapglueUI.acceptedEventTypes.contains($0.type)})
                    self.tableView.reloadData()
                    print("fetched events:  \(self.events)")
                }
            } else {
                AlertFactory.defaultAlert(self)
            }
        }
    }
    
    // MARK: - ProfileBiographyView
    
    func profileBiographyViewFollowersSelected() {
        tapConnectionType = ConnectionType.Followers
        if delegate?.defaultNavigationEnabledInProfileViewController(self) ?? true {
            performSegueWithIdentifier(connectionsSegue, sender: user)
        } else {
            delegate?.profileViewController(self, didSelectConnectionsOfType: .Followers, forUser: user!)
        }
    }
    
    func profileBiographyViewFollowingSelected() {
        tapConnectionType = ConnectionType.Following
        if delegate?.defaultNavigationEnabledInProfileViewController(self) ?? true {
            performSegueWithIdentifier(connectionsSegue, sender: user)
        } else {
            delegate?.profileViewController(self, didSelectConnectionsOfType: .Following, forUser: user!)
        }
    }
    
    func profileBiographyViewErrorOcurred(profileBiographyView: ProfileBiographyView) {
        let alert = UIAlertController(title: "Something went wrong", message: "please try again later", preferredStyle: .Alert)
        let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated:true, completion: nil)
    }

    // MARK: - Navigation

    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == connectionsSegue {
            let connectionsVC = segue.destinationViewController as! ConnectionsViewController
            connectionsVC.type = tapConnectionType
            connectionsVC.referenceUser = sender as? TGUser
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (user != nil ? 1:0) + events.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellProfileBiographyReusableIdentifier) as! ProfileBiographyView
            cell.delegate = self
            cell.user = user
            return cell
        }
        if events[indexPath.row - 1].type == "tg_follow" {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellFollowEventReusableIdentifier) as! FollowEventCell
            cell.event = events[indexPath.row - 1]
            return cell
        }
        if events[indexPath.row-1].type == "tg_like" {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellLikeEventReusableIdentifier) as! LikeEventCell
            cell.event = events[indexPath.row - 1]
            return cell
        }
        return UITableViewCell()
    }
}

extension ProfileViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell as? FollowedMeEventCell != nil {
            let cell = cell as! FollowedMeEventCell
            delegate?.profileViewController(self, didSelectEvent: cell.event!)
            if delegate?.defaultNavigationEnabledInProfileViewController(self) ?? true {
                navigateToProfile(cell.user!)
            }
        }
        if cell as? FollowEventCell != nil {
            let cell = cell as! FollowEventCell
            delegate?.profileViewController(self, didSelectEvent: cell.event!)
            if delegate?.defaultNavigationEnabledInProfileViewController(self) ?? true {
                navigateToProfile(cell.followedUser!)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func navigateToProfile(user: TGUser) {
        let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileVC.userId = user.userId
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}

public protocol ProfileViewDelegate {
    
    /**
     Asks delegate if the calling view controller should handle its own navigation
     - Parameter profileViewController: profile view controller object asking the delegate
     - Returns: boolean value to indicate if navigation should be handled or not
     */
    func defaultNavigationEnabledInProfileViewController(profileViewController: ProfileViewController) -> Bool
    
    /**
     Asks delegate which is the user to be displayed in the profile view controller
     - Parameter profileViewController: profile view controller object asking the delegate
     - Returns: user whos profile is to be displayed by the profile view controller
    */
    func referenceUserInProfileViewController(profileViewController: ProfileViewController) -> TGUser
    
    /**
     Tells delegate that a `ConnectionType` was selected
     - Parameters:
        - profileViewController: profile view controller object asking the delegate
        - connectionType: the selected connection type
        - user: the user for which the `ConnectionType` was selected
     */
    func profileViewController(profileViewController: ProfileViewController, didSelectConnectionsOfType connectionType: ConnectionType, forUser user: TGUser)
    
    /**
     Tells delegate that an event was selected
     - Parameters:
        - profileViewController: profile view controller object asking the delegate
        - event: the event that was selected
    */
    func profileViewController(profileViewcontroller: ProfileViewController, didSelectEvent event: TGEvent)
}
