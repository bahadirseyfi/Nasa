//
//  SpiritEndpointItem.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import Foundation
import CoreAPI

enum EndpointItem: Endpoint {
    
    case curiosity(page: String, filter: String)
    case opportunity(page: String, filter: String)
    case spirit(page: String, filter: String)
    
    var baseUrl: String { Constants.Network.baseUrlRovers }
    
    var method: HTTPMethod {
        switch self {
        case .curiosity:
            return .get
        case .spirit:
            return .get
        case .opportunity:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .curiosity(let page, let filter):
            return "curiosity/photos?sol=1000&\(filter)api_key=\(Constants.Network.apiKey3)&page=\(page)"
        case .opportunity(let page, let filter):
            return "opportunity/photos?api_key=\(Constants.Network.apiKey3)&\(filter)sol=1&page=\(page)"
        case .spirit(let page, let filter):
            return "spirit/photos?api_key=\(Constants.Network.apiKey3)&\(filter)sol=1&page=\(page)"
        }
    }
}
