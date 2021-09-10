//
//  FilterCell.swift
//  Nasa
//
//  Created by bahadir on 9.09.2021.
//

import UIKit

final class FilterCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "FilterCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .separator
        containerView.backgroundColor = .clear
        contentView.layer.cornerRadius = 10
        titleLabel.tintColor = .nasaOrange
    }
}
