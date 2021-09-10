//
//  UICollectionViewCell+Extension.swift
//  Nasa
//
//  Created by bahadir on 23.06.2021.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
