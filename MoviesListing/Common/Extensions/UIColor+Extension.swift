//
//  UIColor+Extension.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 30/04/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import UIKit

extension UIColor {
    enum ColorHexType {
        case standard(StandardColorHex)
        case custom(UInt32)
        
        var hex: UInt32 {
            switch self {
            case .standard(let standard): return standard.rawValue
            case .custom(let hex): return hex
            }
        }
        
    }
    
    enum StandardColorHex: UInt32 {
        case themeColor = 0x333337
    }
    
    private convenience init(hex: UInt32) {
        let mask = 0x000000FF
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     
     - returns: UIColor from HexString
     */
    private convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        self.init(hex: color)
    }
    
    convenience init(color: ColorHexType) {
        self.init(hex: color.hex)
    }
}
