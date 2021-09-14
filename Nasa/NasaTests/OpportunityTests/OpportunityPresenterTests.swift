//
//  OpportunityPresenterTests.swift
//  NasaTests
//
//  Created by bahadir on 14.09.2021.
//

import XCTest
@testable import Nasa

class OpportunityPresenterTests: XCTestCase {

    var presenter: OpportunityPresenter!
    var view: MockOpportunityViewController!
    var interactor: MockOpportunityInteractor!
    
    override func setUp() {
        super.setUp()
        view = .init()
        interactor = .init()
        presenter = .init(view: view, interactor: interactor)
    }
    
    func test_viewDidLoad_InvokesRequiredViewMethods() {
        XCTAssertFalse(view.invokedPrepareNavigation)
        XCTAssertFalse(view.invokedPrepareCollectionView)
        XCTAssertFalse(view.invokedReloadData)
        XCTAssertFalse(interactor.invokedFetchPhotos)
        XCTAssertNil(interactor.invokedFetchPhotosParameters)
        
        presenter.viewDidLoad()
            
        XCTAssertTrue(view.invokedPrepareNavigation)
        XCTAssertTrue(view.invokedPrepareCollectionView)
        XCTAssertTrue(view.invokedReloadData)
        XCTAssertTrue(interactor.invokedFetchPhotos)

    }
    
    func test_willDisplay_WithIndexZero_InvokesNothing() {
        XCTAssertFalse(interactor.invokedFetchPhotos)
        
        presenter.willDisplay(0)
        
        XCTAssertFalse(interactor.invokedFetchPhotos)
    }
    
    func test_willDisplay_WithValidIndex_InvokesFetchWidgets() {
        XCTAssertFalse(interactor.invokedFetchPhotos)
        presenter.handlePhotoResult(.success(.response))
        
        presenter.willDisplay(24)
        
        XCTAssertTrue(interactor.invokedFetchPhotos)
        presenter.handlePhotoResult(.success(.response))
    }
    
    func test_handlePhotoResult_WithSuccessResponseAndFirstPage_InvokesRequiredViews() {
        XCTAssertFalse(view.invokedReloadData)
        XCTAssertEqual(presenter.numberOfItems, 0)
        
        presenter.handlePhotoResult(.success(.response))
        
        XCTAssertTrue(view.invokedReloadData)
        XCTAssertEqual(presenter.numberOfItems, 25)
    }
}
