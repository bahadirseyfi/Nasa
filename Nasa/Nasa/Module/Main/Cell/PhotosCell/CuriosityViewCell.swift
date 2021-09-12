//
//  CuriosityViewCell.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit
import SDWebImage

final class CuriosityViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "CuriosityViewCell"

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var isAnimated = false
    
    var viewModel: CuriosityCellViewModelProtocol! {
        didSet {
            viewModel.delegate = self
            viewModel.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 10
        layer.cornerRadius = 15.0
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        layer.masksToBounds = false
    }
}

extension CuriosityViewCell: CuriosityCellViewModelDelegate {
    func prepareNewsImage(with url: URL) {
        imageView.sd_setImage(with: url)
    }
}
 
