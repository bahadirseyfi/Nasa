//
//  CuriosityViewModel.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import Foundation
import CoreAPI

extension CuriosityViewModel {
    fileprivate enum Constants {
        static let cellLeftPadding: Double = 15
        static let cellRightPadding: Double = 15
        static let firstPageHref: String = "page=1"
        static let cellBannerImageViewAspectRatio: Double = 130/345
        static let cellDescriptionViewHeight: Double = 60
    }
}

protocol CuriosityViewModelProtocol {
    var delegate: CuriosityViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var cellPadding: Double { get }
    func load()
    func photo(_ index: Int) -> RoverPhotos?
    func calculateCellSize(collectionViewWidth: Double) -> (width: Double, height: Double)
}

protocol CuriosityViewModelDelegate: AnyObject {
    func prepareNavigation()
    func prepareCollectionView()
    func reloadData()
}

final class CuriosityViewModel {
    private var networkManager: NetworkManager<SpiritEndpointItem> = NetworkManager()
    
    weak var delegate: CuriosityViewModelDelegate?

    var allPhotos: [RoverPhotos] = []
    
    init(networkManager: NetworkManager<SpiritEndpointItem>) {
        self.networkManager = networkManager
    }
    
    private func fetchPhotos() {
        networkManager.request(endpoint: .curiosity, type: RoverModel.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.allPhotos = response.photos
                self?.delegate?.reloadData()
                break
            case .failure(let error):
                print("error: ",error.message)
                break
            }
        }
    }
}

extension CuriosityViewModel: CuriosityViewModelProtocol {
    var cellPadding: Double {
        Constants.cellLeftPadding
    }
    
    var numberOfItems: Int {
        allPhotos.count
    }
    
    func photo(_ index: Int) -> RoverPhotos? {
        allPhotos[safe: index]
    }
    
    func calculateCellSize(collectionViewWidth: Double) -> (width: Double, height: Double) {
        let cellWidth = collectionViewWidth - (Constants.cellLeftPadding + Constants.cellRightPadding)
        let bannerImageHeight = cellWidth * Constants.cellBannerImageViewAspectRatio
        return (width: cellWidth, height: Constants.cellDescriptionViewHeight + bannerImageHeight)
    }
    
    func load() {
        delegate?.prepareCollectionView()
        delegate?.prepareNavigation()
        fetchPhotos()
        delegate?.reloadData()
    }
}
