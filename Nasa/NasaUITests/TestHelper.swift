//
//  TestHelper.swift
//  Nasa
//
//  Created by bahadir on 14.09.2021.
//

import XCTest

class TestHelper {
    var app: XCUIApplication
    static var shared: TestHelper = {
        let testHelper = TestHelper()
        return testHelper
    }()
    
    private init() {
        self.app = XCUIApplication()
    }
    
    func setUpAndLaunch() {
        app.launch()
    }
    
    func terminate() {
        app.terminate()
    }
}
