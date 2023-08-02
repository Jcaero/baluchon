//
//  CalculatorTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 02/08/2023.
//

import XCTest
@testable import baluchon

final class CalculatorTest: XCTestCase {

    private var calculate: Calculator!

    // data output
    private var alerteTitle: String?
    private var alerteDescription: String?
    private var display: String?

    override func setUp() {
        super.setUp()
        calculate = Calculator(delegate: self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

        /*****************************
        *     TEST numberHasBeenTapped        *
        *******************************
        */
    func testExpressionIsZero_WhenTapFive_ResultIsFive() {
        calculate.numberHasBeenTapped("5")

        XCTAssertEqual(display, "5")
    }

    func testExpressionIsFive_WhenTapZero_ResultIsFifty() {
        calculate.numberHasBeenTapped("5")

        calculate.numberHasBeenTapped("0")

        XCTAssertEqual(display, "50")
    }

    func testExpressionIsFive_WhenTapFive_ResultIsFiftyFive() {
        calculate.numberHasBeenTapped("5")

        calculate.numberHasBeenTapped("5")

        XCTAssertEqual(display, "55")
    }

    func testExpressionHaveTenNumber_WhenTapFive_ResultNotChangeAndShowAlerte() {
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")
        calculate.numberHasBeenTapped("5")

        calculate.numberHasBeenTapped("5")

        XCTAssertEqual(display, "5555555555")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "vous ne pouvez pas dépaser 10 chiffres")
    }

    func testExpressionIsFive_WhenWrongElementHasBeenTapped_ResultNotChangeAndShowAlert() {
        calculate.numberHasBeenTapped("5")

        calculate.numberHasBeenTapped("A")

        XCTAssertEqual(display, "5")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "chiffre non reconnu")
    }

    /*****************************
    *     TEST pointHasBeenTapped()        *
    *******************************
    */

    func testExpressionIsFive_WhenPointHasBeenTapped_ResultIsFivePoint() {
        calculate.numberHasBeenTapped("5")

        calculate.pointHasBeenTapped()

        XCTAssertEqual(display, "5.")
    }

    func testExpressionIsFivePoint_WhenPointHasBeenTapped_ResultIsFivePointAndShowAlerte() {
        calculate.numberHasBeenTapped("5")
        calculate.pointHasBeenTapped()

        calculate.pointHasBeenTapped()

        XCTAssertEqual(display, "5.")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "Un point est deja présent")

    }

    func testExpressionIsFivePointTwo_WhenPointHasBeenTapped_ResultIsFivePointAndShowAlerte() {
        calculate.numberHasBeenTapped("5")
        calculate.pointHasBeenTapped()
        calculate.numberHasBeenTapped("2")

        calculate.pointHasBeenTapped()

        XCTAssertEqual(display, "5.2")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "Un point est deja présent")
    }
}

extension CalculatorTest: CalculatorDelegate {
    func showAlert(title: String, desciption: String) {
        alerteTitle = title
        alerteDescription = desciption
    }

    func updateDisplay(_ expression: String) {
        display = expression
    }
}
