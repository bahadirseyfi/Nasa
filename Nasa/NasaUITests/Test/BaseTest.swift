//
//  BaseTest.swift
//  NasaUITests
//
//  Created by bahadir on 14.09.2021.
//

import XCTest

class BaseTest: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        TestHelper.shared.setUpAndLaunch()
    }
    override func tearDown() {
        super.tearDown()
        let screenshot = XCUIScreen.main.screenshot()
        let fullScreenshotAttachment = XCTAttachment(screenshot: screenshot)
        fullScreenshotAttachment.lifetime = .deleteOnSuccess
        add(fullScreenshotAttachment)
        TestHelper.shared.terminate()
    }
}
