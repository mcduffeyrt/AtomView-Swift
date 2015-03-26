//
//  UIColor-Hex.swift
//  AtomView-Swift
//
//  Created by Richard McDuffey on 3/23/15.
//  Copyright (c) 2015 Richard McDuffey. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    class func ue_ColorWithHex(hex : String!) -> UIColor {
        var hexVal : UInt32 = 0;
        let scanner : NSScanner = NSScanner(string: hex)
        scanner.charactersToBeSkipped = NSCharacterSet(charactersInString: "#")
        scanner.scanHexInt(&hexVal)
        
        
        let color : UIColor = UIColor(red: CGFloat((hexVal & 0xFF0000) >> 16) / 255.0,
                                    green: CGFloat((hexVal & 0xFF00) >> 8) / 255.0,
                                     blue: CGFloat(hexVal & 0xFF) / 255.0,
                                    alpha: CGFloat(1.0))
        
        
        return color
    }
}
