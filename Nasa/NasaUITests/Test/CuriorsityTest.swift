//
//  CuriorsityTest.swift
//  NasaUITests
//
//  Created by bahadir on 14.09.2021.
//

class CuriorsityTest: BaseTest {
    
    func testNavigationBar() {
        CuriorsityPage()
            .checkNavigationBar()
    }
    
    func testPhotosCollectionView() {
        CuriorsityPage()
            .checkCollectionView()
    }
}
