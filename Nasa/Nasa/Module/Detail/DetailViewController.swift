//
//  DetailViewController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var goingLabel: UILabel!
    @IBOutlet private weak var landingLabel: UILabel!
    @IBOutlet private weak var cameraLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        configureUI()
    }
    
    private func configureUI() {
        goingLabel.text = viewModel.launchDate()
        landingLabel.text = viewModel.landingDate()
        cameraLabel.text = viewModel.cameraName()
        statusLabel.text = viewModel.status()
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    @IBAction private func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailViewController: DetailViewModelDelegate {
    func prepareNewsImage(with url: URL) {
        imageView.sd_setImage(with: url)
    }
}
