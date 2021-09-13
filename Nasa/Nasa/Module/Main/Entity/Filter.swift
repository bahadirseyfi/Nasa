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
        case pancam = "PANCAM"
        case chemcam = "CHEMCAM"
        case mahli = "MAHLI"
        case mardi = "MARDI"
        case navcam = "NAVCAM"
        case minites = "MINITES"
    }
    
    func cameras() -> [Cameras] {
        switch self {
        case .curiosity:
            let cameras = [Cameras.fhaz, Cameras.rhaz, Cameras.mast, Cameras.chemcam, Cameras.mahli, Cameras.mardi, Cameras.navcam]
            return cameras
        case .opportunity:
            let cameras = [Cameras.fhaz, Cameras.rhaz, Cameras.navcam, Cameras.pancam, Cameras.minites]
            return cameras
        case .spirit:
            let cameras = [Cameras.fhaz, Cameras.rhaz, Cameras.navcam, Cameras.pancam, Cameras.minites]
            return cameras
        }
    }
}
