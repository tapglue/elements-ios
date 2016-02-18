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
    var searchResult = [TGUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        let cellNib = UINib(nibName: "ConnectionCell", bundle: NSBundle(forClass: ProfileViewController.self))
        tableView.registerNib(cellNib, forCellReuseIdentifier: "ConnectionCell")
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

extension UserSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("search text '\(searchBar.text!)'")
        Tapglue.searchUsersWithTerm(searchBar.text!) { (users:[AnyObject]!, error:NSError!) -> Void in
            self.searchResult = users as! [TGUser]
            print(users)
            dispatch_async(dispatch_get_main_queue()) {() -> Void in
                self.tableView.reloadData()
            }
        }
    }
}

extension UserSearchViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let connectionCell = tableView.dequeueReusableCellWithIdentifier("ConnectionCell", forIndexPath: indexPath) as! ConnectionCell
        let user = searchResult[indexPath.row]
        connectionCell.user = user
        connectionCell.delegate = self
        
        return connectionCell
    }
}

extension UserSearchViewController: UITableViewDelegate {}

extension UserSearchViewController: ConnectionCellDelegate {
    func connectionCellErrorOcurred() {
    
    }
}
