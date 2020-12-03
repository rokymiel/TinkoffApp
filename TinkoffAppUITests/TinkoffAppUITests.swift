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
        XCTAssertTrue(app.textFields["profileUserNameField"].exists)
        XCTAssertTrue(app.textViews["profileDescriptionView"].exists)
        
    }
    
}
