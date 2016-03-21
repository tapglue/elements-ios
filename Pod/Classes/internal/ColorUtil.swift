//
//  ColorUtil.swift
//  Pods
//
//  Created by John Rikard Nilsen on 15/3/16.
//
//

import UIKit

class ColorUtil {
    static func configColorFromHex(hex: String?, orDefault defaultColor: UIColor) -> UIColor {
        if let hex = hex {
            return UIColor.colorFromHexString(hex)
        } else {
            return defaultColor
        }
    }
}