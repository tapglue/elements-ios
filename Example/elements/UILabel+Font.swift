//
//  UILabel+Font.swift
//  elements
//
//  Created by John Rikard Nilsen on 4/3/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

extension UILabel {
    
    var fontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
}
