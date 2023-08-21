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
        exchange.setupRates(with: ["Test": 5, "USD": 1.112954, "CHF": 0.964686 ])
        exchange.setCurrencyISOCode(local: "EUR", converted: "Test")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - TEST numberHasBeenTapped

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
        XCTAssertEqual(alerteTitle, "Limitation")
        XCTAssertEqual(alerteDescription, "vous ne pouvez pas dépaser 10 chiffres")
    }

    func testExpressionIsFive_WhenWrongElementHasBeenTapped_ResultNotChangeAndShowAlert() {
        exchange.numberHasBeenTapped("5")

        exchange.numberHasBeenTapped("A")

        XCTAssertEqual(displayLocal, "5")
        XCTAssertEqual(alerteTitle, "Erreur")
        XCTAssertEqual(alerteDescription, "chiffre non reconnu")
    }

    // MARK: - TEST pointHasBeenTapped()

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

    func testExpressionHaveTwoNumberAfterPoint_WhenNumberHasBeenTapped_ResultNotCHange() {
        exchange.numberHasBeenTapped("5")
        exchange.pointHasBeenTapped()
        exchange.numberHasBeenTapped("2")
        exchange.numberHasBeenTapped("2")

        exchange.numberHasBeenTapped("2")

        XCTAssertEqual(displayLocal, "5.22")
        XCTAssertEqual(alerteTitle, "Limitation")
        XCTAssertEqual(alerteDescription, "Deux nombres après la virgule Maximum")
    }

    // MARK: - TEST clearExpression()

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

    // MARK: - TEST converted

    func testExpressionIsZero_WhenTapEight_ConvertedIsForty() {
        exchange.numberHasBeenTapped("8")

        XCTAssertEqual(displayLocal, "8")
        XCTAssertEqual(displayConverted, "40")
    }

    // MARK: - TEST SWITCH

    func testExpressionIs5AndConvertedIs25_WhenSwitchTapped_ExpressionIs25AndConvertedIs5() {
        exchange.numberHasBeenTapped("5")

        exchange.switchHasBeenTapped()

        XCTAssertEqual(displayLocal, "25")
        XCTAssertEqual(displayConverted, "125")
    }

    // MARK: - Test CalCulateConverted
    func testLocalIsEuroAndConvertedIsUSD_WhenTap5_ConvertedIs5_56() {
        exchange.setCurrencyISOCode(local: "EUR", converted: "USD")

        exchange.numberHasBeenTapped("5")

        XCTAssertEqual(displayLocal, "5")
        XCTAssertEqual(displayConverted, "5.56")

    }

    func testLocalIsUSDAndConvertedIsEUR_WhenTap5_ConvertedIs5_56() {
        exchange.setCurrencyISOCode(local: "USD", converted: "EUR")

        exchange.numberHasBeenTapped("5")

        XCTAssertEqual(displayLocal, "5")
        XCTAssertEqual(displayConverted, "4.49")
    }

    func testWhenSetAvailableRate_AlerteIsNil() {
        exchange.setCurrencyISOCode(local: "EUR", converted: "USD")

        XCTAssertNil(alerteTitle)
    }

    func testWhenSetNotAvailableRate_AlerteIsNil() {
        exchange.setCurrencyISOCode(local: "AAA", converted: "USD")

        XCTAssertEqual(alerteDescription, "monnaie non disponible")
    }

    func testWhenUpdateRates_RatesUpdated() {
        let newRates: [String: Float] = ["USD": 2.0, "BBB": 3.0]
        exchange.setupRates(with: newRates)
        exchange.setCurrencyISOCode(local: "USD", converted: "BBB")

        XCTAssertNil(alerteTitle)
    }

    func testWhenUpdateRates_CHFNotExist() {
        let newRates: [String: Float] = ["USD": 2.0, "BBB": 3.0]
        exchange.setupRates(with: newRates)
        exchange.setCurrencyISOCode(local: "USD", converted: "CHF")

        XCTAssertEqual(alerteDescription, "monnaie non disponible")
    }
}
    // MARK: - Delegate
extension ExchangeTest: ExchangeDelegate {
    func showAlert(title: String, description: String) {
        alerteTitle = title
        alerteDescription = description
    }

    func updateDisplay(_ expression: String, converted: String) {
        displayLocal = expression
        displayConverted = converted
    }

    func updateClearButton(_ buttonName: String) {
        clearButton = buttonName
    }
}
