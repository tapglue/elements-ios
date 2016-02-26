//
//  NotificationFeedViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 26/2/16.
//
//

import UIKit
import Tapglue

class NotificationFeedViewController: UIViewController {
    
    let cellFollowEventReusableIdentifier = "FollowEventCell"
    let cellFollwedMeEventReusableIdentifier = "FollowedMeEventCell"
    let cellLikeEventReusableIdentifier = "LikeEventCell"

    let acceptedTypes = TapglueUI.acceptedEventTypes
    var events = [TGEvent]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNibs(nibNames: [cellFollowEventReusableIdentifier, cellFollwedMeEventReusableIdentifier, cellLikeEventReusableIdentifier])
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Tapglue.retrieveEventsFeedForCurrentUserForEventTypes(acceptedTypes) { (fetchedEvents: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                let fetchedEvents = fetchedEvents as! [TGEvent]
                self.events = fetchedEvents
                dispatch_async(dispatch_get_main_queue()) {() -> Void in
                    self.tableView.reloadData()
                }
                print("events: \(self.events)")
                
            } else {
                AlertFactory.defaultAlert(self)
            }
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

extension NotificationFeedViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if events[indexPath.row ].type == "tg_follow" {
            if events[indexPath.row].target.user == TGUser.currentUser() {
                let cell = tableView.dequeueReusableCellWithIdentifier(cellFollwedMeEventReusableIdentifier) as! FollowedMeEventCell
                let event = events[indexPath.row]
                cell.user = event.user
                return cell
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellFollowEventReusableIdentifier) as! FollowEventCell
            let event = events[indexPath.row]
            let followingUser = event.user
            let followedUser = event.target.user
            cell.followingUser = followingUser
            cell.followedUser = followedUser
            return cell
        }
        if events[indexPath.row].type == "tg_like" {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellLikeEventReusableIdentifier) as! LikeEventCell
            let event = events[indexPath.row]
            cell.user = event.user
            return cell
        }
        return UITableViewCell()
    }
}