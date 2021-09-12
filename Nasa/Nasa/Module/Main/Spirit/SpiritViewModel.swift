//
//  SpiritViewModel.swift
//  Nasa
//
//  Created by bahadir on 12.09.2021.
//

import Foundation
import CoreAPI

extension SpiritViewModel {
    fileprivate enum Constants {
        static let cellLeftPadding: Double = 15
        static let cellRightPadding: Double = 15
        static let firstPageHref: String = "1"
        static let filter: String = ""
        static let cellBannerImageViewAspectRatio: Double = 100/345
        static let cellDescriptionViewHeight: Double = 60
    }
}

protocol SpiritViewModelProtocol {
    var delegate: SpiritViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var cellPadding: Double { get }
    func load()
    func photo(_ index: Int) -> RoverPhotos?
    func calculateCellSize(collectionViewWidth: Double) -> (width: Double, height: Double)
    func filterFetch(_ index: Int)
    func willDisplay(_ index: Int)
    func showLoading()
    func hideLoading()
    func deSelectFilter()
}

protocol SpiritViewModelDelegate: AnyObject {
    func prepareNavigation()
    func prepareCollectionView()
    func reloadData()
}

final class SpiritViewModel {
    private var networkManager: NetworkManager<EndpointItem> = NetworkManager()
    
    weak var delegate: SpiritViewModelDelegate?
    private var href: String = Constants.firstPageHref
    private var filter: String = Constants.filter

    var allPhotos: [RoverPhotos] = []
    
    init(networkManager: NetworkManager<EndpointItem>) {
        self.networkManager = networkManager
    }
    
    private func fetchPhotos() {
        showLoading()
        networkManager.request(endpoint: .spirit(page: href, filter: filter), type: RoverModel.self) { [weak self] (result) in
            self?.hideLoading()
            switch result {
            case .success(let response):
                self?.allPhotos.append(contentsOf: response.photos)
                self?.delegate?.reloadData()
                break
            case .failure(let error):
                print("error: ",error.message)
                break
            }
        }
    }
}

extension SpiritViewModel: SpiritViewModelProtocol {
    
    func willDisplay(_ index: Int) {
        if allPhotos.count >= 25 {
            if index == (allPhotos.count - 1) {
                guard var intPage = Int(href) else { return }
                intPage += 1
                href = String(intPage)
                fetchPhotos()
            }
        }
    }
    
    func deSelectFilter() {
        allPhotos.removeAll()
        self.filter = ""
        fetchPhotos()
    }
    
    func filterFetch(_ index: Int) {
        href = "1"
        allPhotos.removeAll()
        let camera = Filter.spirit.cameras()[index].rawValue.lowercased()
        let filterCamera = "camera=\(camera)&"
        self.filter = filterCamera
        fetchPhotos()
    }
    
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
    
    func showLoading() {
        ProgressView.shared.show()
    }
    
    func hideLoading() {
        ProgressView.shared.hide()
    }
}
