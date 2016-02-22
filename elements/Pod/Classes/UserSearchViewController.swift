//
//  UserSearchViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 18/2/16.
//
//

import UIKit
import Tapglue

public class UserSearchViewController: UIViewController {

    public var delegate: UserSearchViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    let cellNothingFoundReusableIdentifier = "NothingFoundCell"
    let cellSearchAddressBookReusableIdentifier = "SearchAddressBookCell"
    let cellConnectionReusableIdentifier = "ConnectionCell"
    
    var isSearching = false
    var searchResult = [TGUser]()
    
    override public func viewDidLoad() {
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
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
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

extension UserSearchViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(searchBar: UISearchBar) {
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
    public func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
}

extension UserSearchViewController: UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResult.count == 0 {
            return 1
        }
        return searchResult.count
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
}

extension UserSearchViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if ((cell as? ConnectionCell) != nil) {
            if delegate?.defaultNavigationEnabledInUserSearchViewController(self) ?? true {
                performSegueWithIdentifier("toProfile", sender: searchResult[indexPath.row])
            } else {
                delegate?.userSearchViewController(self, didSelectUser: searchResult[indexPath.row])
            }
        } else if (cell as? SearchAddressBookCell) != nil {
            if delegate?.defaultNavigationEnabledInUserSearchViewController(self) ?? true {
                performSegueWithIdentifier("toAddressBook", sender: nil)
            } else {
                delegate?.didTapAddressBookInUserSearchViewController(self)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
}

extension UserSearchViewController: ConnectionCellDelegate {
    func connectionCellErrorOcurred() {
        AlertFactory.defaultAlert(self)
    }
}

public protocol UserSearchViewDelegate {
    func defaultNavigationEnabledInUserSearchViewController(connectionsViewController: UserSearchViewController) -> Bool
    func userSearchViewController(userSearchViewController: UserSearchViewController, didSelectUser: TGUser)
    func didTapAddressBookInUserSearchViewController(userSearchViewController: UserSearchViewController)
}
