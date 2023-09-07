//
//  baluchonUITests.swift
//  baluchonUITests
//
//  Created by pierrick viret on 02/08/2023.
//

 import XCTest
 @testable import baluchon

private extension XCUIApplication {
    var fiveButton: XCUIElement {self.buttons["5"]}
    var CButton: XCUIElement {self.buttons["C"]}
    var PointButton: XCUIElement {self.buttons["."]}
}

 final class ExchangeUITests: XCTestCase {
     let app = XCUIApplication()

     override func setUp() {
         continueAfterFailure = false
         app.launch()
     }

     override func tearDown() {
     }

     func testWhenTapFive_ThenDisplayIsFiveOneTheScreen() {
         app.fiveButton.tap()
         
         XCTAssertTrue(app.staticTexts["5"].exists)
     }

     func testWhenTapTenButtonFive_ThenDisplayIsFiveOneTheScreen() {
         for _ in 1...11 {
             app.fiveButton.tap()
         }
         
         XCTAssertTrue(app.staticTexts["5555555555"].exists)
         XCTAssertTrue(app.staticTexts["Limitation: vous ne pouvez pas dépaser 10 chiffres"].exists)
     }
     
     func testDisplayIsFivePointWhenTapPoint_ThenShowAlert() {
        app.fiveButton.tap()
         app.PointButton.tap()

         app.PointButton.tap()
         
         XCTAssertTrue(app.staticTexts["5."].exists)
         XCTAssertTrue(app.alerts["Erreur"].exists)
     }

     func testFiveOnDisplay_WhenTapFive_ThenDisplayIsZeroTheScreen() {
         app.fiveButton.tap()
         
         app.CButton.tap()
         
         XCTAssertTrue(app.staticTexts["0"].exists)
     }
 }
