//
//  UITableView+NibLoading.swift
//  Pods
//
//  Created by John Rikard Nilsen on 22/2/16.
//
//

import UIKit

extension UITableView {
    func registerNibs(nibNames nibs: [String]) {
        let bundle = NSBundle(forClass: ProfileViewController.self)
        
        for nib in nibs {
            let cellNib = UINib(nibName: nib, bundle: bundle)
            registerNib(cellNib, forCellReuseIdentifier: nib)
        }
    }
}
