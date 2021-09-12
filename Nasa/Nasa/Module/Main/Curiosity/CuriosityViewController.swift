//
//  CuriosityViewController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit
import Hero
import CoreAPI

final class CuriosityViewController: UIViewController {
    
    @IBOutlet private weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var photosCollectionView: UICollectionView!
    @IBOutlet private weak var filterCollectionView: UICollectionView!
    
    var viewModel: CuriosityViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private var appDevLogo: UIView?
    
    let appDevLogoSize: CGFloat = 28
    
    // Haptics
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
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

// MARK: - UICollectionViewDelegateFlowLayout
extension CuriosityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == filterCollectionView {
            return .init(width: 150, height: 40)
        } else {
            let size = viewModel.calculateCellSize(collectionViewWidth: Double(collectionView.frame.size.width))
            return .init(width: size.width, height: size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: .zero, left: CGFloat(viewModel.cellPadding), bottom: .zero, right: CGFloat(viewModel.cellPadding))
    }
}

// MARK: - UICollectionViewDataSource
extension CuriosityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return Filter.curiosity.cameras().count
        } else {
            return viewModel.numberOfItems
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let cell = filterCollectionView.dequeCell(cellType: FilterCell.self, indexPath: indexPath)
            let arr = Filter.curiosity.cameras()
            cell.titleLabel.text = arr[indexPath.item].rawValue
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuriosityViewCell.reuseIdentifier,
                                                          for: indexPath) as! CuriosityViewCell
            if let photos = viewModel.photo(indexPath.item) {
                cell.viewModel = CuriosityCellViewModel(roverPhotos: photos)
            }
            
            if !cell.isAnimated {
                UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row),
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 0.5,
                               options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight,
                               animations: {
                    
                    if indexPath.row % 2 == 0 {
                        AnimationUtility.viewSlideInFromLeft(toRight: cell)
                    }
                    else {
                        AnimationUtility.viewSlideInFromRight(toLeft: cell)
                    }
                }, completion: { (done) in
                    cell.isAnimated = true
                })
            }
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CuriosityViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == photosCollectionView {
            viewModel.willDisplay(indexPath.item)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 20 {
            view.layoutIfNeeded()
            headerViewHeightConstraint.constant = 5
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            view.layoutIfNeeded()
            headerViewHeightConstraint.constant = 20
            UIView.animate(withDuration: 0.3, delay: 0, options: [.allowUserInteraction], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView == filterCollectionView {
            let item = collectionView.cellForItem(at: indexPath)
            if item?.isSelected ?? false {
                item?.contentView.backgroundColor = .separator
                viewModel.deSelectFilter()
                collectionView.deselectItem(at: indexPath, animated: true)
            } else {
                for cell in filterCollectionView.visibleCells as [UICollectionViewCell] {
                    cell.contentView.backgroundColor = .separator
                }
                item?.contentView.backgroundColor = .histogramBarBlue
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                return true
            }
            return false
        } else {
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        feedbackGenerator.impactOccurred()
        
        if collectionView == filterCollectionView {
            viewModel.filterFetch(indexPath.item)
        } else {
            self.view.endEditing(true)
            redirectTo(index: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        feedbackGenerator.prepare()
        
        UIView.animate(
            withDuration: 0.35,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            }
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0,
            options: [],
            animations: {
                cell.transform = .identity
            }
        )
    }
}

// MARK: - CuriosityViewModelDelegate
extension CuriosityViewController: CuriosityViewModelDelegate {
    func prepareNavigation() {
        navigationItem.title = Constants.Style.Text.Bar.curiosity
        view.backgroundColor = .wash
        
        let heroEnabled = !UIAccessibility.isReduceMotionEnabled
        navigationController?.hero.isEnabled = heroEnabled
        navigationController?.hero.navigationAnimationType = .fade
        hero.isEnabled = heroEnabled
        
        let logo = UIImageView(image: UIImage(named: "appcentlogo"))
        logo.tintColor = .white
        logo.contentMode = .scaleAspectFit
        navigationController?.navigationBar.addSubview(logo)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.widthAnchor.constraint(equalToConstant: appDevLogoSize).isActive = true
        logo.heightAnchor.constraint(equalToConstant: appDevLogoSize).isActive = true
        
        appDevLogo = logo
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
        }
    }
    
    func prepareCollectionView() {
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
        
        filterCollectionView.register(cellType: FilterCell.self)
        photosCollectionView.register(cellType: CuriosityViewCell.self)
        
        photosCollectionView.backgroundColor = .clear
        filterCollectionView.backgroundColor = .wash
    }
}

extension CuriosityViewController {
    
    private func appDevLogoYPosition(navBarHeight: CGFloat) -> CGFloat {
        let bottomOffset: CGFloat = 12
        
        if navigationItem.searchController == nil {
            return navBarHeight - appDevLogoSize - bottomOffset
        }
        
        let breakPoint: CGFloat = 50 // height of nav bar with expanded title
        let resumePoint: CGFloat = 70 // height of nav bar with expanded title + search bar
        
        var yPosition: CGFloat
        
        yPosition = navBarHeight < breakPoint ? navBarHeight : navBarHeight - (resumePoint - breakPoint)
        
        yPosition -= appDevLogoSize
        yPosition -= bottomOffset
        
        return yPosition
    }
}
