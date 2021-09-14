//
//  CuriorsityPage.swift
//  NasaUITests
//
//  Created by bahadir on 14.09.2021.
//

import Foundation

class CuriorsityPage {
    var app = TestHelper.shared.app
    
    lazy var navigationBar = app.navigationBars["curiorstiyNavigationBar"]
    lazy var photosCollectionView = app.collectionViews["photosCollectionView"]
    
    @discardableResult
    func checkNavigationBar() -> Self {
        let _ = navigationBar.waitForExistence(timeout: 3)
        return self
    }
    
    @discardableResult
    func checkCollectionView() -> Self {
        let _ = photosCollectionView.waitForExistence(timeout: 3)
        return self
    }
}
