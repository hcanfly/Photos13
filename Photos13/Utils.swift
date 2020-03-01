//
//  Utils.swift
//
//  Created by main on 4/11/16.
//  Copyright © 2016 Gary Hanson. All rights reserved.
//

import UIKit

let scaleFactor = UIScreen.main.bounds.height / 667.0

var accessibilityIsBoldTextEnabled = false


extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha )
    }
}

func scaled(value: CGFloat) -> CGFloat {
    return  value * scaleFactor
}

struct FileUtilities {
    
    static func documentsDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
}


public enum LyveColors : Int {
    case darkScrim
    case whiteScrim
    case lyveScrim
    case cloudTheme
    case darkText
    case lightText
    case lighterText
    case selection
    case selectedText
    case selectedDarkText
    
    func color() -> UIColor {
        switch (self) {
        case .darkScrim:
            return UIColor(red: 38.0/255.0, green: 50.0/255.0, blue: 56.0/255.0, alpha: 0.25)
        case .whiteScrim:
            return UIColor(white: 1.0, alpha: 0.8)
        case .lyveScrim:
            return UIColor(red: 202.0/255.0, green: 242.0/255.0, blue: 253.0/255.0, alpha: 0.4)
        case .cloudTheme:
            return UIColor(red: 114.0/255.0, green: 109.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        case .darkText:
            return UIColor(hex: 0x263238)
        case .lightText:
            return UIColor(hex: 0x8c8e92)
        case .lighterText:
            return UIColor(hex: 0xb4b4b4)
        case .selection:
            return UIColor(hex: 0xeaf3fc)
        case .selectedText:
            return UIColor(hex: 0x3489e3)
        case .selectedDarkText:
            return UIColor(hex: 0x175ba2)
        }
    }
}

public enum LyveFont : Int {
    case ultraLight
    case light
    case normal
    case medium
    
    func font(_ size: CGFloat) -> UIFont {
        var name: String
        
        if accessibilityIsBoldTextEnabled {
            switch (self) {
            case .ultraLight:
                name = "HelveticaNeue"
            case .light:
                name = "HelveticaNeue-Medium"
            case .normal:
                name = "HelveticaNeue-Bold"
            case .medium:
                name = "HelveticaNeue-Bold"
            }
        } else {
            switch (self) {
            case .ultraLight:
                name = "HelveticaNeue-Light"
            case .light:
                name = "HelveticaNeue"
            case .normal:
                name = "HelveticaNeue-Medium"
            case .medium:
                name = "HelveticaNeue-Bold"
            }
        }
        
        return UIFont(name: name, size: size)!
    }
}

