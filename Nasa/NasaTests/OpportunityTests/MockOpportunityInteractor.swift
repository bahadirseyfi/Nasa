//
//  MockOpportunityInteractor.swift
//  NasaTests
//
//  Created by bahadir on 14.09.2021.
//

import Foundation
@testable import Nasa

final class MockOpportunityInteractor: OpportunityInteractorInterface {

    var invokedFetchPhotos = false
    var invokedFetchPhotosCount = 0
    var invokedFetchPhotosParameters: (page: String, filter: String)?
    var invokedFetchPhotosParametersList = [(page: String, filter: String)]()

    func fetchPhotos(page: String, filter: String) {
        invokedFetchPhotos = true
        invokedFetchPhotosCount += 1
        invokedFetchPhotosParameters = (page, filter)
        invokedFetchPhotosParametersList.append((page, filter))
    }
}
