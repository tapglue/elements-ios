//
//  UserSearchViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 18/2/16.
//
//

import UIKit
import Tapglue

class UserSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    var searchResult = [TGUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        let bundle = NSBundle(forClass: ProfileViewController.self)
        let connectionCellNib = UINib(nibName: "ConnectionCell", bundle: bundle)
        let nothingFoundCellNib = UINib(nibName: "NothingFoundCell", bundle: bundle)
        tableView.registerNib(connectionCellNib, forCellReuseIdentifier: "ConnectionCell")
        tableView.registerNib(nothingFoundCellNib, forCellReuseIdentifier: "NothingFoundCell")
        tableView.rowHeight = 80
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

extension UserSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        isSearching = true
        searchBar.resignFirstResponder()
        Tapglue.searchUsersWithTerm(searchBar.text!) { (users:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                self.searchResult = users as! [TGUser]
                dispatch_async(dispatch_get_main_queue()) {() -> Void in
                    self.tableView.reloadData()
                }
            } else {
                print("ERROR! \(error)")
            }
        }
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}

extension UserSearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching && searchResult.count == 0 {
            return 1
        }
        return searchResult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchResult.count == 0 {
            return tableView.dequeueReusableCellWithIdentifier("NothingFoundCell")!
        }
        let connectionCell = tableView.dequeueReusableCellWithIdentifier("ConnectionCell", forIndexPath: indexPath) as! ConnectionCell
        let user = searchResult[indexPath.row]
        connectionCell.user = user
        connectionCell.delegate = self
        
        return connectionCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if delegate?.defaultNavigationEnabledInConnectionsViewController(self) ?? true {
            performSegueWithIdentifier("toProfile", sender: searchResult[indexPath.row])
            tableView.deselectRowAtIndexPath(indexPath, animated:true)
//        } else {
//            delegate?.connectionsViewController(self, didSelectUser: usersToDisplay[indexPath.row])
//        }
    }
}

extension UserSearchViewController: UITableViewDelegate {}

extension UserSearchViewController: ConnectionCellDelegate {
    func connectionCellErrorOcurred() {
    
    }
}
