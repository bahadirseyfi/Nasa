//
//  SpiritEndpointItem.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import Foundation
import CoreAPI

enum SpiritEndpointItem: Endpoint {
    
    case opportunity
    case curiosity
    case spirit
    
    var baseUrl: String { Constants.Network.baseUrlRovers }
    
    var method: HTTPMethod {
        switch self {
        case .spirit:
            return .get
        case .curiosity:
            return .get
        case .opportunity:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .spirit:
            return "spirit/photos?sol=1000&api_key=\(Constants.Network.apiKey)&page=1"
        case .curiosity:
            return "curiosity/photos?sol=1000&api_key=\(Constants.Network.apiKey)&page=1"
        case .opportunity:
            return "opportunity/photos?sol=1000&api_key=\(Constants.Network.apiKey)&page=1"
        }
    }
}
