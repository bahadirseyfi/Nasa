//
//  AccessibilityIdentifiable.swift
//  Nasa
//
//  Created by bahadir on 14.09.2021.
//


import UIKit

protocol AccessibilityIdentifiable: AnyObject {
    func setAccessibilityIdentifiers()
    func setAccessibilityIdentifiers(view: UIView, index: Int)
}

extension AccessibilityIdentifiable {
    func setAccessibilityIdentifiers(view: UIView, index: Int) {}
}
