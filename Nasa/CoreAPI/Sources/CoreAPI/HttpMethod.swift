//
//  File.swift
//  
//
//

import Alamofire

public typealias HTTPMethod = Alamofire.HTTPMethod

public extension Endpoint {
//    var encoding: ParameterEncoding {
//        switch method {
//        case .get: return URLEncoding.default
//        default: return URLEncoding.default
//        }
//    }
    var encoding: ParameterEncoding { URLEncoding.default } 
}
