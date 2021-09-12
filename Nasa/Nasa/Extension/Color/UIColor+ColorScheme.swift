//
//  UIColor+ColorScheme.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit

extension UIColor {

    convenience init(hex: Int) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255

        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    /// 0xF2655D
    static let nasaRed = UIColor(hex: 0xF2655D)

    /// 0x2C7EDF
    static let navigationBarBlue = UIColor(hex: 0x2C7EDF)

    /// 0x4A90E2
    static let nasaBlue = UIColor(hex: 0x4A90E2)

    /// 0x3B73B5
    static let darkNasaBlue = UIColor(hex: 0x3B73B5)

    /// 0xb7d3f3
    static let histogramBarBlue = UIColor(hex: 0xb7d3f3)

    /// 0x63C774
    static let nasaGreen = UIColor(hex: 0x63C774)

    static let nasaOrange = UIColor(hex: 0xFF990E)

    /// 0x222222
    static let primary = UIColor(hex: 0x222222)

    /// 0x7d8288
    static let secondary = UIColor(hex: 0x7D8288)

    /// 0xE1E1E1
    static let inactive = UIColor(hex: 0xE1E1E1)

    /// 0xE1E1E1
    static let separator = UIColor(hex: 0xE1E1E1)

    /// 0xF5F5F5
    static let wash = UIColor(hex: 0xF5F5F5)

    /// 0x7d8288
    static let steel = UIColor(hex: 0x7D8288)

}
