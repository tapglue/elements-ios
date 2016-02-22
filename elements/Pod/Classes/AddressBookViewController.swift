//
//  AddressBookViewController.swift
//  Pods
//
//  Created by John Rikard Nilsen on 22/2/16.
//
//

import UIKit
import Contacts
import Tapglue

@available(iOS 9.0, *)
class AddressBookViewController: UIViewController {
    
    let cellNothingFoundReusableIdentifier = "NothingFoundCell"
    let cellConnectionReusableIdentifier = "ConnectionCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    let contactStore = CNContactStore()
    
    var contactEmails: [String] = []
    var contacts: [[String:String]] = []
    var searchResult = [TGUser]()
    var isSearchFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = NSBundle(forClass: ProfileViewController.self)
        let connectionCellNib = UINib(nibName: cellConnectionReusableIdentifier, bundle: bundle)
        let nothingFoundCellNib = UINib(nibName: cellNothingFoundReusableIdentifier, bundle: bundle)
        tableView.registerNib(connectionCellNib, forCellReuseIdentifier: cellConnectionReusableIdentifier)
        tableView.registerNib(nothingFoundCellNib, forCellReuseIdentifier: cellNothingFoundReusableIdentifier)
        tableView.rowHeight = 80
        
        print("address book view!")
        searchForUsersByEmail()
    }
    
    func searchForUsersByEmail() {
        readAddressBookByEmail()
        
        Tapglue.searchUsersWithEmails(contactEmails) { (users: [AnyObject]!, error: NSError!) -> Void in
            if error != nil {
                print("\nError searchUsersWithEmails: \(error)")
            }
            else {
                print("\nSuccessful searchUsersWithEmails: \(users)")
                self.isSearchFinished = true
                self.searchResult = users as! [TGUser]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }

    func readAddressBookByEmail(){
        do {
            try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey])) {
                (contact, cursor) -> Void in
                if (!contact.emailAddresses.isEmpty){
                    var itemCount = 0
                    for item in contact.emailAddresses {
                        itemCount++
                        if itemCount <= 1 {
                            self.contacts.append(["givenName": contact.givenName, "email" : String(item.value)])
                            self.contactEmails.append(String(item.value))
                        }
                    }
                }
                self.contacts.sortInPlace({ (contact1, contact2) -> Bool in
                    return contact1["givenName"] < contact2["givenName"]
                })
            }
        }
        catch{
            self.navigationController?.popViewControllerAnimated(true)
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

@available(iOS 9.0, *)
extension AddressBookViewController: UITableViewDelegate {}

@available(iOS 9.0, *)
extension AddressBookViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchFinished && searchResult.count == 0 {
            return 1
        }
        return searchResult.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchResult.count == 0 && isSearchFinished {
            return tableView.dequeueReusableCellWithIdentifier(cellNothingFoundReusableIdentifier)!
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
        }
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
}

@available(iOS 9.0, *)
extension AddressBookViewController: ConnectionCellDelegate {
    func connectionCellErrorOcurred() {
        AlertFactory.defaultAlert(self)
    }
}