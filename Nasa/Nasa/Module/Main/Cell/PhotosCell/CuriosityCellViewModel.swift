//
//  CuriosityCellViewModel.swift
//  Nasa
//
//  Created by bahadir on 8.09.2021.
//

import Foundation

protocol CuriosityCellViewModelProtocol {
    var delegate: CuriosityCellViewModelDelegate? { get set }
    func load()
}

protocol CuriosityCellViewModelDelegate: AnyObject {
    func prepareNewsImage(with url: URL)
}

final class CuriosityCellViewModel {
    
    private let roverPhotos: RoverPhotos
    weak var delegate: CuriosityCellViewModelDelegate?
    
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

extension CuriosityCellViewModel: CuriosityCellViewModelProtocol {
    
    func load() {
        setPhotoImage()
    }
}
