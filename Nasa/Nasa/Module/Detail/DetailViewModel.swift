//
//  DetailViewModel.swift
//  Nasa
//
//  Created by bahadir on 13.09.2021.
//

import Foundation

protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    func load()
    func landingDate() -> String
    func launchDate() -> String
    func cameraName() -> String
    func status() -> String
}

protocol DetailViewModelDelegate: AnyObject {
    func prepareNewsImage(with url: URL)
}

final class DetailViewModel {
    
    private let roverPhotos: RoverPhotos
    
    weak var delegate: DetailViewModelDelegate?
    
    init(roverPhotos: RoverPhotos) {
        self.roverPhotos = roverPhotos
    }
    
    private func setPhotoImage() {
        let urlString = roverPhotos.imageSrc
        if let url = URL(string: urlString) {
            delegate?.prepareNewsImage(with: url)
        }
    }
}

extension DetailViewModel: DetailViewModelProtocol {
    
    func load() {
        setPhotoImage()
    }
    
    func landingDate() -> String {
        let date = roverPhotos.rover.landingDate
        return DateFormatter().convertDateFormater(date)
    }
    
    func launchDate() -> String {
        let date = roverPhotos.rover.launchDate
        return DateFormatter().convertDateFormater(date)
    }
    
    func cameraName() -> String {
        roverPhotos.camera.fullName
    }
    
    func status() -> String {
        roverPhotos.rover.status
    }
}
