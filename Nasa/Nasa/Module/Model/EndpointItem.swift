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
    case opportunity    
    case spirit
    
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
            return "curiosity/photos?sol=1000&\(filter)api_key=\(Constants.Network.apiKey2)&page=\(page)"
//          return "curiosity/photos?sol=1000&\(filter)api_key=DEMO_KEY&page=\(page)"
        case .spirit:
            return "spirit/photos?sol=1000&api_key=\(Constants.Network.apiKey)&page=1"
        case .opportunity:
            return "opportunity/photos?sol=1000&api_key=\(Constants.Network.apiKey)&page=1"
        }
    }
}
