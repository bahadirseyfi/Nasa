//
//  CuriosityViewController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import UIKit
import CoreAPI

final class CuriosityViewController: UIViewController {
        
    var collectionView: UICollectionView!
    
    var viewModel: CuriosityViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private var appDevLogo: UIView?
    
    static let appDevLogoSize: CGFloat = 28
    
    // Haptics
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }
}

// MARK: - UICollectionViewDataSource
extension CuriosityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuriosityViewCell.reuseIdentifier,
                                                      for: indexPath) as! CuriosityViewCell
        if let photos = viewModel.photo(indexPath.item) {
            cell.viewModel = CuriosityCellViewModel(roverPhotos: photos)
        }
        
        if !cell.isAnimated {
            UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
                
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

// MARK: - UICollectionViewDelegate
extension CuriosityViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let appDevLogo = appDevLogo else {
            return
        }
        
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0.0
        let yPosition = appDevLogoYPosition(navBarHeight: navBarHeight)
        
        let navBarWidth = navigationController?.navigationBar.frame.width ?? 0.0
        let centerOfRightNavigationBarItem = navBarWidth - 40
        let xPosition = centerOfRightNavigationBarItem - CuriosityViewController.appDevLogoSize / 2
        
        appDevLogo.transform = CGAffineTransform(translationX: xPosition, y: yPosition)
        
        let startPoint: CGFloat = 60 // px until AppDev logo starts showing
        let fullyVisiblePoint: CGFloat = 90 // px until AppDev logo is fully visible
        let maxAlpha: CGFloat = 0.9
        appDevLogo.alpha = min(maxAlpha, (yPosition - startPoint) / (fullyVisiblePoint - startPoint))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        feedbackGenerator.impactOccurred()
        
        self.view.endEditing(true)
        let viewController: DetailViewController = DetailViewController.instantiate(storyboards: .detail)
//        self.navigationController?.pushViewController(viewController, animated: true)
        present(viewController, animated: true, completion: nil)
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
        view.backgroundColor = .nasaGreen
        
        let logo = UIImageView(image: UIImage(named: "appcentlogo"))
        logo.tintColor = .white
        logo.contentMode = .scaleAspectFit
        navigationController?.navigationBar.addSubview(logo)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.widthAnchor.constraint(equalToConstant: CuriosityViewController.appDevLogoSize).isActive = true
        logo.heightAnchor.constraint(equalToConstant: CuriosityViewController.appDevLogoSize).isActive = true
        
        appDevLogo = logo
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func prepareCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: self.layout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.loadNib(name: CuriosityViewCell.reuseIdentifier), forCellWithReuseIdentifier: CuriosityViewCell.reuseIdentifier)
        collectionView.backgroundColor = .clear
    }
}

extension CuriosityViewController {
    func layout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        // Now setup the flowLayout required for drawing the cells
        let space = 10.0 as CGFloat
        
        // Set view cell size
        flowLayout.itemSize = CGSize(width: 350,height: 175)
        
        // Set left and right margins
        flowLayout.minimumInteritemSpacing = space
        
        // Set top and bottom margins
        flowLayout.minimumLineSpacing = space
        return flowLayout
    }
    
    private func appDevLogoYPosition(navBarHeight: CGFloat) -> CGFloat {
        let bottomOffset: CGFloat = 12
        
        if navigationItem.searchController == nil {
            return navBarHeight - CuriosityViewController.appDevLogoSize - bottomOffset
        }
        
        let breakPoint: CGFloat = 50 // height of nav bar with expanded title
        let resumePoint: CGFloat = 70 // height of nav bar with expanded title + search bar
        
        var yPosition: CGFloat
        
        if navBarHeight < breakPoint {
            yPosition = navBarHeight
        } else if navBarHeight < resumePoint {
            yPosition = breakPoint
        } else {
            yPosition = navBarHeight - (resumePoint - breakPoint)
        }
        
        yPosition -= CuriosityViewController.appDevLogoSize
        yPosition -= bottomOffset
        
        return yPosition
    }
}
