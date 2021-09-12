//
//  OpportunityViewController.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//  Opportunity

import UIKit

extension OpportunityViewController {
    fileprivate enum Constants {
        static var layoutSize: CGFloat = 1.0
        static var headerSize: CGFloat = 0.3
        static let numberOfSections: Int = 2
        static let itemContentInsets: CGFloat = 5
        static let sectionContentInsets: CGFloat = 10
        static let groupSizeWidthDimension: CGFloat = 0.4
        static let groupSizeHeightEstimateDimension: CGFloat = 15
        static let itemSizeWidthDimension: CGFloat = 0.9
        static let layoutButtonLeftRightConstraint: CGFloat = 8.0
        static let layoutButtonBottomConstraint: CGFloat = 4.0
    }
}

final class OpportunityViewController: UIViewController {

    private var collectionView: UICollectionView!
    private var selectedPath: Int = 0
    @IBOutlet private weak var isExistDataLabel: UILabel!
    
    var viewModel: OpportunityViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
        view.backgroundColor = .darkNasaBlue
    }
    
    @objc
    private func changeLayoutCollection() {
        switch Constants.layoutSize {
        case 1.0:
            Constants.layoutSize = 0.5
            collectionView.reloadData()
        case 0.5:
            Constants.layoutSize = 1.0
            collectionView.reloadData()
        default:
            break
        }
    }
    
    @objc
    private func pullToRefresh() {
        viewModel.pullToRefresh()
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

// MARK: - UICollectionViewDelegate
extension OpportunityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        case 1:
            viewModel.willDisplay(indexPath.item)
            break
        default:
            debugPrint("UICollectionViewDelegate")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:

            if selectedPath != 0 {
                viewModel.deSelectFilter()
                selectedPath = 0
            } else {
                selectedPath = indexPath.item
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                viewModel.filterFetch(indexPath.item)
            }
            return false
        case 1:
            self.view.endEditing(true)
            redirectTo(index: indexPath)
            return true
        default:
            return false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension OpportunityViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Filter.opportunity.cameras().count
        default:
            if viewModel.numberOfItems < 1 {
                isExistDataLabel.isHidden = false
                return viewModel.numberOfItems
            } else {
                isExistDataLabel.isHidden = true
                return viewModel.numberOfItems
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeCell(cellType: FilterCell.self, indexPath: indexPath)

            let arr = Filter.curiosity.cameras()
            cell.titleLabel.text = arr[indexPath.item].rawValue
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuriosityViewCell.reuseIdentifier,
                                                          for: indexPath) as! CuriosityViewCell
            if let photos = viewModel.photo(indexPath.item) {
                cell.viewModel = CuriosityCellViewModel(roverPhotos: photos)
            }
            return cell
        }
    }
}

extension OpportunityViewController: OpportunityViewModelDelegate {
    func prepareNavigation() {
        navigationItem.title = "Opportunity"
        view.backgroundColor = .wash
        
        let layoutButton = UIBarButtonItem(image: UIImage(named: "settings"),
                                           style: .done, target: self,
                                           action: #selector(changeLayoutCollection))
        
        layoutButton.imageInsets = UIEdgeInsets(top: .zero,
                                                left: Constants.layoutButtonLeftRightConstraint,
                                                bottom: Constants.layoutButtonBottomConstraint,
                                                right: Constants.layoutButtonLeftRightConstraint)
        
        navigationItem.rightBarButtonItems = [layoutButton]
    }
    
    func prepareCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout())
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(cellType: FilterCell.self)
        collectionView.register(cellType: CuriosityViewCell.self)
        collectionView.backgroundColor = .clear
        
        collectionView.allowsMultipleSelection = true
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension OpportunityViewController {
    func createHorizontalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.itemSizeWidthDimension),
                                              heightDimension: .fractionalWidth(Constants.headerSize))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = .init(top: Constants.itemContentInsets,
                                   leading: Constants.itemContentInsets,
                                   bottom: Constants.itemContentInsets,
                                   trailing: Constants.itemContentInsets)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.groupSizeWidthDimension),
                                               heightDimension: .estimated(Constants.groupSizeHeightEstimateDimension))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: Constants.sectionContentInsets,
                                      bottom: 0, trailing: Constants.sectionContentInsets)
        
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
}

extension OpportunityViewController {
    func layout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return self.createHorizontalLayout()
            default:
                break
            }
            if sectionIndex == 1 {
                return self.makeVerticalLayout()
            }
            return self.makeVerticalLayout()
        }
    }
}

extension OpportunityViewController {
    func makeVerticalLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.layoutSize),
                                              heightDimension: .fractionalWidth(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: Constants.itemContentInsets,
                                   leading: Constants.itemContentInsets,
                                   bottom: Constants.itemContentInsets,
                                   trailing: Constants.itemContentInsets)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: Constants.sectionContentInsets,
                                      bottom: 0, trailing: Constants.sectionContentInsets)
        return section
    }
}
