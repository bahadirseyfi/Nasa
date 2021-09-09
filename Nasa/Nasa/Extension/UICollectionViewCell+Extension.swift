//
//  UICollectionViewCell+Extension.swift
//  GameListApp
//
//  Created by Oguzhan Bekir on 24.05.2021.
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
