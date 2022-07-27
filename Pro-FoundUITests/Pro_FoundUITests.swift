//
//  Pro_FoundUITests.swift
//  Pro-FoundUITests
//
//  Created by Hsueh Peng Tseng on 2022/7/21.
//

import XCTest

class Pro_FoundUITests: XCTestCase {
	
	var app: XCUIApplication!

    override func setUpWithError() throws {
		
		try super.setUpWithError()
		continueAfterFailure = false
		app = XCUIApplication()
		app.launch()
		
    }
	
	func test_UserLogIn() throws {
		let emailTextField = self.app.textFields["emailTextField"]
		let passwordTextField = self.app.secureTextFields["passwordTextField"]
		let loginButton = self.app.buttons["loginButton"]
		let greetingLabel = self.app/*@START_MENU_TOKEN@*/.staticTexts["greetingLabel"]/*[[".staticTexts[\"Welcome back,\"]",".staticTexts[\"greetingLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
		
		let expectation = expectation(description: "Successfully logged in")
				
		emailTextField.tap()
		emailTextField.typeText("123@gmail.com")
		passwordTextField.tap()
		passwordTextField.typeText("123456")
		app.toolbars["Toolbar"].buttons["Done"].tap()
		loginButton.tap()

		if greetingLabel.isHittable {
			expectation.fulfill()
		} else {
			XCTFail()
		}

		wait(for: [expectation], timeout: 5)
		
	}

	func test_GameStyleSwitch() {
		
		let filterButton = app.buttons["filter"]
		let languageButton = app.buttons["language_filter_button"]
		let artButton = app.buttons["art_filter_button"]
		let sportButton = app.buttons["sport_filter_button"]
		let musicButton = app.buttons["music_filter_button"]
		let technologyButton = app.buttons["technology_filter_button"]
		
		filterButton.tap()
		XCTAssertTrue(languageButton.exists)
		XCTAssertTrue(artButton.exists)
		XCTAssertTrue(sportButton.exists)
		XCTAssertTrue(musicButton.exists)
		XCTAssertTrue(technologyButton.exists)
		
		languageButton.tap()
		XCTAssertTrue(languageButton.isSelected)
		XCTAssertFalse(artButton.isSelected)
		XCTAssertFalse(sportButton.isSelected)
		XCTAssertFalse(musicButton.isSelected)
		XCTAssertFalse(technologyButton.isSelected)
		
		artButton.tap()
		XCTAssertFalse(languageButton.isSelected)
		XCTAssertTrue(artButton.isSelected)
		XCTAssertFalse(sportButton.isSelected)
		XCTAssertFalse(musicButton.isSelected)
		XCTAssertFalse(technologyButton.isSelected)
		
		filterButton.tap()
		XCTAssertFalse(languageButton.exists)
		XCTAssertFalse(artButton.exists)
		XCTAssertFalse(sportButton.exists)
		XCTAssertFalse(musicButton.exists)
		XCTAssertFalse(technologyButton.exists)
		
	}

}
