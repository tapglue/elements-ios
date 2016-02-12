//
//  ProfileBiographyView.swift
//  Pods
//
//  Created by John Rikard Nilsen on 9/2/16.
//
//

import UIKit
import Tapglue

@IBDesignable class ProfileBiographyView: UIView {
    
    private let nibName = "ProfileBiographyView"
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followingComboView: UIView!
    @IBOutlet weak var followersComboView: UIView!
    
    var delegate: ProfileBiographyDelegate?
    
    var user: TGUser? {
        didSet{
            if let user = user {
                username.text = user.username
                followerCount.text = String(user.followersCount)
                followingCount.text = String(user.followingCount)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        tapSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        tapSetup()
    }
    
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func tapSetup() {
        let followingTap = UITapGestureRecognizer(target: self, action: Selector("handleFollowingTap"))
        followingComboView.addGestureRecognizer(followingTap)
        
        let followersTap = UITapGestureRecognizer(target: self, action: Selector("handleFollowersTap"))
        followersComboView.addGestureRecognizer(followersTap)
    }

    func handleFollowingTap() {
        delegate?.profileBiographyViewFollowingSelected()
        print("following tap detected")
    }
    
    func handleFollowersTap() {
        delegate?.profileBiographyViewFollowersSelected()
        print("followers tap detected")
    }
}
