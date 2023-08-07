//
//  ExchangeTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 02/08/2023.
//

import XCTest
@testable import baluchon

final class ExchangeTest: XCTestCase {

    private var exchange: Exchange!

    // data output
    private var alerteTitle: String?
    private var alerteDescription: String?
    private var displayLocal: String?
    private var displayConverted: String?
    private var clearButton: String?

    override func setUp() {
        super.setUp()
        exchange = Exchange(delegate: self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

        /*****************************
        *     TEST numberHasBeenTapped        *
        *******************************
        */
    func testExpressionIsZero_WhenTapFive_ResultIsFive() {
        exchange.numberHasBeenTapped("5")

        XCTAssertEqual(displayLocal, "5")
    }

    func testExpressionIsFive_WhenTapZero_ResultIsFifty() {
        exchange.numberHasBeenTapped("5")

        exchange.numberHasBeenTapped("0")

        XCTAssertEqual(displayLocal, "50")
    }

    func testExpressionIsFive_WhenTapFive_ResultIsFiftyFive() {
        exchange.numberHasBeenTapped("5")

        exchange.numberHasBeenTapped("5")

        XCTAssertEqual(displayLocal, "55")
    }

    func testExpressionHaveTenNumber_WhenTapFive_ResultNotChangeAndShowAlerte() {
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("5")

        exchange.numberHasBeenTapped("5")

        XCTAssertEqual(displayLocal, "5555555555")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "vous ne pouvez pas dépaser 10 chiffres")
    }

    func testExpressionIsFive_WhenWrongElementHasBeenTapped_ResultNotChangeAndShowAlert() {
        exchange.numberHasBeenTapped("5")

        exchange.numberHasBeenTapped("A")

        XCTAssertEqual(displayLocal, "5")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "chiffre non reconnu")
    }

    /*****************************
    *     TEST pointHasBeenTapped()        *
    *******************************
    */

    func testExpressionIsFive_WhenPointHasBeenTapped_ResultIsFivePoint() {
        exchange.numberHasBeenTapped("5")

        exchange.pointHasBeenTapped()

        XCTAssertEqual(displayLocal, "5.")
    }

    func testExpressionIsFivePoint_WhenPointHasBeenTapped_ResultIsFivePointAndShowAlerte() {
        exchange.numberHasBeenTapped("5")
        exchange.pointHasBeenTapped()

        exchange.pointHasBeenTapped()

        XCTAssertEqual(displayLocal, "5.")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "Un point est deja présent")

    }

    func testExpressionIsFivePointTwo_WhenPointHasBeenTapped_ResultIsFivePointAndShowAlerte() {
        exchange.numberHasBeenTapped("5")
        exchange.pointHasBeenTapped()
        exchange.numberHasBeenTapped("2")

        exchange.pointHasBeenTapped()

        XCTAssertEqual(displayLocal, "5.2")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "Un point est deja présent")
    }

    /*****************************
    *     TEST clearExpression()        *
    *******************************
    */

    func testExpressionIsFive_WhenClearExpressionAC_ResultIsZero() {
        exchange.numberHasBeenTapped("5")

        exchange.clearExpression("AC")

        XCTAssertEqual(displayLocal, "0")
    }

    func testExpressionIsFiftyTwo_WhenClearExpressionC_ResultIsFive() {
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("2")

        exchange.clearExpression("C")

        XCTAssertEqual(displayLocal, "5")
        XCTAssertEqual(clearButton, "AC")
    }

    func testExpressionIsFiftyTwo_WhenClearExpressionIsNotCorrect_ResultNotChnage() {
        exchange.numberHasBeenTapped("5")
        exchange.numberHasBeenTapped("2")

        exchange.clearExpression("D")

        XCTAssertEqual(displayLocal, "52")
    }
}

extension ExchangeTest: ExchangeDelegate {
    func showAlert(title: String, desciption: String) {
        alerteTitle = title
        alerteDescription = desciption
    }

    func updateDisplay(_ expression: String, converted: String) {
        displayLocal = expression
        displayConverted = converted
    }

    func updateClearButton(_ buttonName: String) {
        clearButton = buttonName
    }
}
