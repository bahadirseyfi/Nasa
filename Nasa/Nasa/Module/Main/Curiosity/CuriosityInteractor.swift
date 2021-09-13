//
//  CuriosityInteractor.swift
//  Nasa
//
//  Created by bahadir on 13.09.2021.
//

import CoreAPI
import Foundation

// ViewController -> presenter Interface
protocol CuriosityInteractorInterface {
    func fetchPhotos(page: String, filter: String)
}

// CuriosityInteractorOutput -> presenter
protocol CuriosityInteractorOutput: AnyObject {
    func handlePhotoResult(_ result: CuriosityPhotoResult)
}

typealias CuriosityPhotoResult = Result<RoverModel, APIClientError>

final class CuriosityInteractor {
    
    private var networkManager: NetworkManager<EndpointItem> = NetworkManager()
    
    weak var output: CuriosityInteractorOutput?
    
    init(networkManager: NetworkManager<EndpointItem> = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension CuriosityInteractor: CuriosityInteractorInterface {
    func fetchPhotos(page: String, filter: String) {
        networkManager.request(endpoint: .curiosity(page: page, filter: filter), type: RoverModel.self) { [weak self] (result) in
            self?.output?.handlePhotoResult(result)
        }
    }
}
