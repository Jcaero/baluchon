//
//  TapbarUITest.swift
//  baluchonUITests
//
//  Created by pierrick viret on 07/09/2023.
//

import XCTest
@testable import baluchon

private extension XCUIApplication {
   var tabBarTraduction: XCUIElement {tabBars.buttons.element(boundBy: 1)}
   var outputButton: XCUIElement {self.buttons["Anglais"]}
    var switchButton: XCUIElement {self.buttons["switch"]}
    var textView: XCUIElement {self.textViews.element}
}

final class TraductionUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDown() {
    }
    
    func testAppsIsInTraductionPages_WhenTapBonjourInTextField_ThenDisplayGoodMorning() {
        app.tabBarTraduction.tap()
        
        app.textView.tap()
        app.textView.typeText("bonjour")
        app.textView.typeText(" ")
        
        XCTAssertTrue(app.staticTexts["Anglais"].exists)
        XCTAssertTrue(app.staticTexts["Français"].exists)
        XCTAssertTrue(app.staticTexts["Good morning"].exists)
    }

    func test_WhenAppsIsInTraductionPages_ThenPlaceholderIsTrue() {
        app.tabBarTraduction.tap()
        
        XCTAssertFalse(app.staticTexts["Inserer le texte à Traduire"].exists)
    }

    func testAppsIsInTraductionPages_WhenTapInTextField_ThenPlaceholderDisapear() {
        app.tabBarTraduction.tap()
        
        app.textView.tap()
        
        XCTAssertFalse(app.staticTexts["Inserer le texte à Traduire"].exists)
    }

    func testBonjourInTextField_WhenTapswitch_ThenDisplayGoodMorningIsInInputText() {
        app.tabBarTraduction.tap()
        
        app.textView.tap()
        app.textView.typeText("bonjour")
        app.switchButton.tap()
        app.switchButton.tap()
        
        XCTAssertEqual(app.textView.value as! String, "Good morning")
    }

    func testAppsIsInTraductionPages_WhenTapInOutputText_ThenShowSelectLanguage() {
        app.tabBarTraduction.tap()
        
        app.outputButton.tap()
        
        XCTAssertTrue(app.staticTexts["Azéri"].exists)
    }

}
