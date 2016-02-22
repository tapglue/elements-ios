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
    let cellNothingFoundReusableIdentifier = "NothingFoundCell"
    let cellSearchAddressBookReusableIdentifier = "SearchAddressBookCell"
    let cellConnectionReusableIdentifier = "ConnectionCell"
    
    var isSearching = false
    var searchResult = [TGUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        let bundle = NSBundle(forClass: ProfileViewController.self)
        let connectionCellNib = UINib(nibName: cellConnectionReusableIdentifier, bundle: bundle)
        let nothingFoundCellNib = UINib(nibName: cellNothingFoundReusableIdentifier, bundle: bundle)
        let searchAddressBookCellNib = UINib(nibName: cellSearchAddressBookReusableIdentifier, bundle: bundle)
        tableView.registerNib(connectionCellNib, forCellReuseIdentifier: cellConnectionReusableIdentifier)
        tableView.registerNib(nothingFoundCellNib, forCellReuseIdentifier: cellNothingFoundReusableIdentifier)
        tableView.registerNib(searchAddressBookCellNib, forCellReuseIdentifier: cellSearchAddressBookReusableIdentifier)
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
                let alert = UIAlertController(title: "Something went wrong", message: "please try again later", preferredStyle: .Alert)
                let action = UIAlertAction(title: "ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated:true, completion: nil)
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
        if searchResult.count == 0 {
            return 1
        }
        return searchResult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchResult.count == 0 {
            if isSearching {
                return tableView.dequeueReusableCellWithIdentifier(cellNothingFoundReusableIdentifier)!
            } else {
                return tableView.dequeueReusableCellWithIdentifier(cellSearchAddressBookReusableIdentifier)!
            }
        }
        let connectionCell = tableView.dequeueReusableCellWithIdentifier(cellConnectionReusableIdentifier, forIndexPath: indexPath) as! ConnectionCell
        let user = searchResult[indexPath.row]
        connectionCell.user = user
        connectionCell.delegate = self
        
        return connectionCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if ((cell as? ConnectionCell) != nil) {
            performSegueWithIdentifier("toProfile", sender: searchResult[indexPath.row])
        } else if (cell as? SearchAddressBookCell) != nil {
            performSegueWithIdentifier("toAddressBook", sender: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
}

extension UserSearchViewController: UITableViewDelegate {}

extension UserSearchViewController: ConnectionCellDelegate {
    func connectionCellErrorOcurred() {
        AlertFactory.defaultAlert(self)
    }
}
