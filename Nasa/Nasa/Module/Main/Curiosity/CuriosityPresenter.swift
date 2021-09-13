//
//  CuriosityPresenter.swift
//  Nasa
//
//  Created by bahadir on 13.09.2021.
//

import Foundation

extension CuriosityPresenter {
    fileprivate enum Constants {
        static let cellLeftPadding: Double = 15
        static let cellRightPadding: Double = 15
        static let firstPageHref: String = "1"
        static let filter: String = ""
        static let cellBannerImageViewAspectRatio: Double = 130/345
        static let cellDescriptionViewHeight: Double = 60
    }
}

protocol CuriosityPresenterInterface {
    var numberOfItems: Int { get }
    var cellPadding: Double { get }
    func viewDidLoad()
    func photo(_ index: Int) -> RoverPhotos?
    func calculateCellSize(collectionViewWidth: Double) -> (width: Double, height: Double)
    func filterFetch(_ index: Int)
    func willDisplay(_ index: Int)
    func showLoading()
    func hideLoading()
    func deSelectFilter()
}

final class CuriosityPresenter {
    weak var view: CuriosityViewInterface?
    private let interactor: CuriosityInteractorInterface
    
    private var href: String = Constants.firstPageHref
    private var filter: String = Constants.filter
    
    var allPhotos: [RoverPhotos] = []
    
    init(view: CuriosityViewInterface?,
         interactor: CuriosityInteractorInterface) {
        self.view = view
        self.interactor = interactor
    }
    
    private func fetchPhotos() {
        showLoading()
        interactor.fetchPhotos(page: href, filter: filter)
    }
}

extension CuriosityPresenter: CuriosityPresenterInterface {
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
        let camera = Filter.curiosity.cameras()[index].rawValue.lowercased()
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
    
    func viewDidLoad() {
        view?.prepareCollectionView()
        view?.prepareNavigation()
        fetchPhotos()
        view?.reloadData()
    }
    
    func showLoading() {
        ProgressView.shared.show()
    }
    
    func hideLoading() {
        ProgressView.shared.hide()
    }
}

extension CuriosityPresenter: CuriosityInteractorOutput {
    func handlePhotoResult(_ result: PhotoResult) {
        self.hideLoading()
        switch result {
        case .success(let response):
            self.allPhotos.append(contentsOf: response.photos)
            self.view?.reloadData()
            break
        case .failure(let error):
            print("error: ",error.message)
            break
        }
    }
}
