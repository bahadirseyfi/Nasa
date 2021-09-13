//
//  SpiritInteractor.swift
//  Nasa
//
//  Created by bahadir on 13.09.2021.
//

import CoreAPI
import Foundation

protocol SpiritInteractorInterface {
    func fetchPhotos(page: String, filter: String)
}

protocol SpiritInteractorOutput: AnyObject {
    func handlePhotoResult(_ result: SpiritPhotoResult)
}

typealias SpiritPhotoResult = Result<RoverModel, APIClientError>

final class SpiritInteractor {
    
    private var networkManager: NetworkManager<EndpointItem> = NetworkManager()
    
    weak var output: SpiritInteractorOutput?
    
    init(networkManager: NetworkManager<EndpointItem> = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension SpiritInteractor: SpiritInteractorInterface {
    func fetchPhotos(page: String, filter: String) {
        networkManager.request(endpoint: .opportunity(page: page, filter: filter), type: RoverModel.self) { [weak self] (result) in
            self?.output?.handlePhotoResult(result)
        }
    }
}
