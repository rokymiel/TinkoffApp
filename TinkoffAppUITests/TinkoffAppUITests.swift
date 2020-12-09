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
        let userNameLabel = app.navigationBars["Channels"].staticTexts["userName"]
        _ = userNameLabel.waitForExistence(timeout: 5)
        XCTAssertTrue(userNameLabel.exists)
        userNameLabel.tap()
        let profileUserNameField = app.textFields["profileUserNameField"]
        let  profileDescriptionView = app.textViews["profileDescriptionView"]
        _ = profileUserNameField.waitForExistence(timeout: 5)
        _ = profileDescriptionView.waitForExistence(timeout: 5)
        XCTAssertTrue(profileDescriptionView.exists)
        XCTAssertTrue(profileUserNameField.exists)
        
    }
    
}
