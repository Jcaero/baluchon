//
//  WeatherUITest.swift
//  baluchonUITests
//
//  Created by pierrick viret on 08/09/2023.
//

import XCTest
@testable import baluchon

private extension XCUIApplication {
   var tabBarWeather: XCUIElement {tabBars.buttons.element(boundBy: 2)}

}

final class WeatherUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
    }
    
    func testAppsGivenTapWeather_WhenSwipLeft_ThenDisplayNewYork() {
        app.tabBarWeather.tap()
        let scrollView = app.scrollViews.element(boundBy: 0)

        scrollView.swipeLeft()

        XCTAssertTrue(app.staticTexts["FR"].exists)

    }
    
    func testAppsGivenTapWeather_WhenSwipLeftAndPutCity_ThenDisplayNewYork() {
        app.tabBarWeather.tap()
        let scrollView = app.scrollViews.element(boundBy: 0)

        scrollView.swipeLeft()
        let input = app.textFields["inputTextField"]
        input.tap()
        input.typeText("Brest\n")
        XCTAssertTrue(app.staticTexts["Brest"].waitForExistence(timeout: 5))

    }

}
