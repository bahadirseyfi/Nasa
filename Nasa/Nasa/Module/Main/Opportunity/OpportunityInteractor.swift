//
//  OpportunityInteractor.swift
//  Nasa
//
//  Created by bahadir on 13.09.2021.
//

import CoreAPI
import Foundation

protocol OpportunityInteractorInterface {
    func fetchPhotos(page: String, filter: String)
}

protocol OpportunityInteractorOutput: AnyObject {
    func handlePhotoResult(_ result: OpportunityPhotoResult)
}

typealias OpportunityPhotoResult = Result<RoverModel, APIClientError>

final class OpportunityInteractor {
    
    private var networkManager: NetworkManager<EndpointItem> = NetworkManager()
    
    weak var output: OpportunityInteractorOutput?
    
    init(networkManager: NetworkManager<EndpointItem> = NetworkManager()) {
        self.networkManager = networkManager
    }
}

extension OpportunityInteractor: OpportunityInteractorInterface {
    func fetchPhotos(page: String, filter: String) {
        networkManager.request(endpoint: .opportunity(page: page, filter: filter), type: RoverModel.self) { [weak self] (result) in
            self?.output?.handlePhotoResult(result)
        }
    }
}
