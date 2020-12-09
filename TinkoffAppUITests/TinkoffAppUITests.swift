//
//  TinkoffAppUITests.swift
//  TinkoffAppUITests
//
//  Created by Михаил on 03.12.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import XCTest

class TinkoffAppUITests: XCTestCase {
    
    func testFindTextsInProfileView() throws {
        
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Channels"].staticTexts["userName"].tap()
        let profileUserNameField = app.textFields["profileUserNameField"]
        let  profileDescriptionView = app.textViews["profileDescriptionView"]
        _ = profileUserNameField.waitForExistence(timeout: 5)
        _ = profileDescriptionView.waitForExistence(timeout: 5)
        XCTAssertTrue(profileDescriptionView.exists)
        XCTAssertTrue(profileUserNameField.exists)
        
    }
    
}
