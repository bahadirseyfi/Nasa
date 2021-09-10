//
//  Filter.swift
//  Nasa
//
//  Created by bahadir on 9.09.2021.
//

import Foundation

enum Filter: String {
    
    case curiosity
    case opportunity
    case spirit
    
    enum Cameras: String {
        case fhaz = "FHAZ"
        case rhaz = "RHAZ"
        case mast = "MAST"
        case chemcam = "CHEMCAM"
        case mahli = "MAHLI"
        case mardi = "MARDI"
        case navcam = "NAVCAM"
    }
    
    
    func cameras() -> [Cameras] {
        switch self {
        case .curiosity:
            let cameras = [Cameras.fhaz, Cameras.rhaz, Cameras.mahli, Cameras.mardi]
            return cameras
        case .opportunity:
            let cameras = [Cameras.mardi]
            return cameras
        case .spirit:
            let cameras = [Cameras.mahli, Cameras.mardi]
            return cameras
        }
    }
}
