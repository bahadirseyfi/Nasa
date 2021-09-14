//
//  MockCuriorsityViewController.swift
//  NasaTests
//
//  Created by bahadir on 13.09.2021.
//

@testable import Nasa

final class MockCuriorsityViewController: CuriosityViewInterface {

    var invokedPrepareNavigation = false
    var invokedPrepareNavigationCount = 0

    func prepareNavigation() {
        invokedPrepareNavigation = true
        invokedPrepareNavigationCount += 1
    }

    var invokedPrepareCollectionView = false
    var invokedPrepareCollectionViewCount = 0

    func prepareCollectionView() {
        invokedPrepareCollectionView = true
        invokedPrepareCollectionViewCount += 1
    }

    var invokedReloadData = false
    var invokedReloadDataCount = 0

    func reloadData() {
        invokedReloadData = true
        invokedReloadDataCount += 1
    }
}