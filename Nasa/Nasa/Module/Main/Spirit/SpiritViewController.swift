//
//  SpiritViewController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit

final class SpiritViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    var viewModel: SpiritViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private var appDevLogo: UIView?
    
    let appDevLogoSize: CGFloat = 28
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }
    
    @objc
    private func changeLayoutCollection() {
        let vc = filterBottomSheetViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: false)
    }
    
    private func appDevLogoYPosition(navBarHeight: CGFloat) -> CGFloat {
        let bottomOffset: CGFloat = 12
        return navBarHeight - appDevLogoSize - bottomOffset
    }
    
    private func redirectTo(index: IndexPath) {
        if let roverPhoto = viewModel.photo(index.item) {
            let viewModel = DetailViewModel(roverPhotos: roverPhoto)
            let viewController: DetailViewController = DetailViewController.instantiate(storyboards: .detail)
            viewController.viewModel = viewModel
            present(viewController, animated: true, completion: nil)
        } else {
            debugPrint("viewModel.photo(indexPath.item) Index Fault")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SpiritViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuriosityViewCell.reuseIdentifier,
                                                      for: indexPath) as! CuriosityViewCell
        if let photos = viewModel.photo(indexPath.item) {
            cell.viewModel = CuriosityCellViewModel(roverPhotos: photos)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SpiritViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        redirectTo(index: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let appDevLogo = appDevLogo else {
            return
        }
        
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0.0
        let yPosition = appDevLogoYPosition(navBarHeight: navBarHeight)
        
        let navBarWidth = navigationController?.navigationBar.frame.width ?? 0.0
        let centerOfRightNavigationBarItem = navBarWidth - 200
        let xPosition = centerOfRightNavigationBarItem - appDevLogoSize / 2
        
        appDevLogo.transform = CGAffineTransform(translationX: xPosition, y: yPosition)
        
        let startPoint: CGFloat = 60
        let fullyVisiblePoint: CGFloat = 90
        let maxAlpha: CGFloat = 0.9
        appDevLogo.alpha = min(maxAlpha, (yPosition - startPoint) / (fullyVisiblePoint - startPoint))
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension SpiritViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = viewModel.calculateCellSize(collectionViewWidth: Double(collectionView.frame.size.width))
            return .init(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 15, left: CGFloat(viewModel.cellPadding), bottom: .zero, right: CGFloat(viewModel.cellPadding))
    }
}

// MARK: - SpiritViewModelDelegate
extension SpiritViewController: SpiritViewModelDelegate {
    func prepareNavigation() {
        navigationItem.title = Constants.Style.Text.Bar.spirit
        view.backgroundColor = .steel
        
        let logo = UIImageView(image: UIImage(named: "appcentlogo"))
        logo.tintColor = .white
        logo.contentMode = .scaleAspectFit
        navigationController?.navigationBar.addSubview(logo)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.widthAnchor.constraint(equalToConstant: appDevLogoSize).isActive = true
        logo.heightAnchor.constraint(equalToConstant: appDevLogoSize).isActive = true
        
        appDevLogo = logo
        
        let layoutButton = UIBarButtonItem(image: UIImage(named: "filter30"),
                                           style: .done, target: self,
                                           action: #selector(changeLayoutCollection))
        
        layoutButton.imageInsets = UIEdgeInsets(top: .zero,
                                                left: 8.0,
                                                bottom: .zero,
                                                right: 8.0)

        navigationItem.rightBarButtonItems = [layoutButton]
    }
    
    func prepareCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(cellType: CuriosityViewCell.self)
        collectionView.backgroundColor = .clear
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - FilterViewControllerDelegate
extension SpiritViewController: FilterViewControllerDelegate {
    func didUpdateFilter(index: Int) {
        viewModel.filterFetch(index)
    }
}
