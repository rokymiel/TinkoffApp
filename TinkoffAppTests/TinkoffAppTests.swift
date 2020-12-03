//
//  TinkoffAppTests.swift
//  TinkoffAppTests
//
//  Created by Михаил on 02.12.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//
@testable import TinkoffApp
import XCTest

class TinkoffAppTests: XCTestCase {
    
    func testThemeManager() throws {
        //Arange
        let themeSaver = ThemeSaverMock()
        let themeManager = ThemeManager(themeSaver)
        let firstTheme = themeSaver.theme
        
        //Act
        let firstThemeFromThemeManager = themeManager.currentTheme()
        themeManager.apply(theme: .day)
        let secondTheme = themeManager.currentTheme()
        
        //Assert
        XCTAssertEqual(firstTheme, firstThemeFromThemeManager)
        XCTAssertEqual(themeSaver.theme, secondTheme)
        XCTAssertEqual(themeSaver.readCallsCount, 1)
        XCTAssertEqual(themeSaver.writeCallsCount, 1)
    }
    func testUserIDManager() throws {
        //Arange
        let userIDSaverWithID = UserIDSaverMock(id: "firstID")
        let userIDManagerWithSavedID: UserIDManager
        let userIDSaverWithoutID = UserIDSaverMock(id: "")
        let userIDManagerWithoutSavedID: UserIDManager
        
        //Act
        userIDManagerWithSavedID = UserIDManager(userIDSaverWithID)
        userIDManagerWithoutSavedID = UserIDManager(userIDSaverWithoutID)
        
        //Assert
        XCTAssertEqual(userIDSaverWithID.readCallsCount, 1)
        XCTAssertEqual(userIDSaverWithID.writeCallsCount, 0)
        XCTAssertEqual(userIDSaverWithID.id, userIDManagerWithSavedID.userId)
        
        XCTAssertEqual(userIDSaverWithoutID.readCallsCount, 1)
        XCTAssertEqual(userIDSaverWithoutID.writeCallsCount, 1)
        XCTAssertEqual(userIDSaverWithoutID.id, userIDManagerWithoutSavedID.userId)
        
    }
    func testNetManager() throws {
        //Arange
        let requestSenderWithFail = RequestSenderMock(fail: true)
        let netManagerWithFail = NetManager(requestSender: requestSenderWithFail)
        let requestSenderWithSucces = RequestSenderMock(fail: false)
        let netManagerWithSucces = NetManager(requestSender: requestSenderWithSucces)
        
        var failureFirtsResult: String?
        var succesFirstResult: ResponseModel?
        var failureSecondResult: String?
        var succesSecondResult: ResponseModel?
        
        //Act
        netManagerWithFail.loadImageList { (model, error) in
            succesFirstResult = model
            failureFirtsResult = error
            
        }
        
        netManagerWithSucces.loadImageList { (model, error) in
            succesSecondResult = model
            failureSecondResult = error
            
        }
        //Assert
        XCTAssertNil(succesFirstResult)
        XCTAssertNotNil(failureFirtsResult)
        XCTAssertEqual(requestSenderWithFail.failurMessage, failureFirtsResult)
        XCTAssertEqual(requestSenderWithFail.callsCount, 1)
        
        XCTAssertNil(failureSecondResult)
        XCTAssertNotNil(succesSecondResult)
        XCTAssertEqual(requestSenderWithSucces.model, succesSecondResult)
        XCTAssertEqual(requestSenderWithSucces.callsCount, 1)
        
    }
    func testGCDDataManager() throws {
        //Arange
        let dataManager = DataManagerMock {  fault in
            XCTAssertFalse(fault)
        }
        let gcdDataManager = GCDDataManager(dataManager: dataManager)
        let userName = "Bob"
        let description = "Description"
        let imageProfile = UIImage(named: "tinkoff")
        
        //Act
        gcdDataManager.write(name: userName, description: description, image: imageProfile)
        sleep(1)
        //Assert
        gcdDataManager.read { name, decr, image  in
            XCTAssertEqual(userName, name)
            XCTAssertEqual(description, decr)
            XCTAssertNotNil(image)
            XCTAssertEqual(dataManager.readCallsCount, 2)
            XCTAssertEqual(dataManager.writeCallsCount, 2)
            XCTAssertEqual(dataManager.checkDirectoryCallsCount, 0)
            XCTAssertEqual(dataManager.deleteCallsCount, 0)
            XCTAssertEqual(dataManager.writeImageCallsCount, 1)
            XCTAssertEqual(dataManager.readImageCallsCount, 1)
        }
        sleep(1)
    }
    
}
