//
//  NotificationFeedViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 26/2/16.
//
//

import UIKit
import Tapglue

public class NotificationFeedViewController: UIViewController {
    
    public var delegate: NotificationFeedViewDelegate?
    
    let cellFollowEventReusableIdentifier = "FollowEventCell"
    let cellFollwedMeEventReusableIdentifier = "FollowedMeEventCell"
    let cellLikeEventReusableIdentifier = "LikeEventCell"
    let profileSegueName = "toProfile"

    let acceptedTypes = TapglueUI.acceptedEventTypes
    var events = [TGEvent]()
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNibs(nibNames: [cellFollowEventReusableIdentifier, cellFollwedMeEventReusableIdentifier, cellLikeEventReusableIdentifier])
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        let backButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "popViewController")
        navigationItem.leftBarButtonItem = backButton
        
        refreshControl.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.backgroundColor = UIColor.clearColor()
        applyConfiguration(TapglueUI.config)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        retrieveEventsForCurrentUser()
    }
    
    func retrieveEventsForCurrentUser() {
        Tapglue.retrieveEventsFeedForCurrentUserForEventTypes(acceptedTypes) { (fetchedEvents: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                let fetchedEvents = fetchedEvents as! [TGEvent]
                self.events = fetchedEvents
                dispatch_async(dispatch_get_main_queue()) {() -> Void in
                    self.tableView.reloadData()
                }
            } else {
                AlertFactory.defaultAlert(self)
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func refresh() {
        retrieveEventsForCurrentUser()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == profileSegueName {
            let vc = segue.destinationViewController as! ProfileViewController
            let user = sender as! TGUser
            vc.userId = user.userId
        }
    }

}

extension NotificationFeedViewController: UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if events[indexPath.row ].type == "tg_follow" {
            if events[indexPath.row].target.user.userId == TGUser.currentUser().userId {
                let cell = tableView.dequeueReusableCellWithIdentifier(cellFollwedMeEventReusableIdentifier) as! FollowedMeEventCell
                cell.event = events[indexPath.row]
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellFollowEventReusableIdentifier) as! FollowEventCell
            cell.event = events[indexPath.row]
            return cell
        }
        if events[indexPath.row].type == "tg_like" {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellLikeEventReusableIdentifier) as! LikeEventCell
            cell.event = events[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}

extension NotificationFeedViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell as? FollowedMeEventCell != nil {
            let cell = cell as! FollowedMeEventCell
            delegate?.notificationFeedViewController(self, didSelectEvent: cell.event!)
            if delegate?.defaultNavigationEnabledInNotificationFeedViewController(self) ?? true {
                performSegueWithIdentifier(profileSegueName, sender: cell.user)
            }
        }
        if cell as? FollowEventCell != nil {
            let cell = cell as! FollowEventCell
            delegate?.notificationFeedViewController(self, didSelectEvent: cell.event!)
            if delegate?.defaultNavigationEnabledInNotificationFeedViewController(self) ?? true {
                performSegueWithIdentifier(profileSegueName, sender: cell.followedUser)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

public protocol NotificationFeedViewDelegate{
    func defaultNavigationEnabledInNotificationFeedViewController(notificationFeedViewController: NotificationFeedViewController) -> Bool
    func notificationFeedViewController(noticationFeedViewController: NotificationFeedViewController, didSelectEvent event: TGEvent)
}