//
//  Exchange.swift
//  baluchon
//
//  Created by pierrick viret on 07/08/2023.
//

import Foundation

protocol ExchangeDelegate: AnyObject {
    func showAlert(title: String, description: String)
    func updateDisplay(_ expression: String, converted: String)
    func updateClearButton(_ buttonName: String)
}

class Exchange {
    // MARK: - Delegate
    private weak var delegate: ExchangeDelegate?

    init(delegate: ExchangeDelegate?) {
        self.delegate = delegate
        expression = "0"
        converted = "0"
        exchangeRates = ["USD": 1.112954]
    }

    // MARK: - Expression
    private var expression: String
    private var converted: String

    private  var newExpression: Bool {
        return expression == "0"
    }

    private let availableNumber: Set = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    // MARK: - Rates
    private var exchangeRates: [String: Float]
    private var availableRate = ["EUR", "USD"]

    private var localCurrencyISOCode: String = "EUR"
    private var convertedCurrencyISOCode: String = "USD"

    // MARK: - Configuration
    private let numberMaxLenght = 10

    func setCurrencyISOCode( local: String, converted: String) {
        guard availableRate.contains(local), availableRate.contains(converted) else {
            delegate?.showAlert(title: "Erreur", description: "monnaie non disponible")
            return
        }
        localCurrencyISOCode = local
        convertedCurrencyISOCode = converted
    }

    // MARK: - PAD Methode
    func numberHasBeenTapped(_ selection: String) {
        guard availableNumber.contains(selection) else {
            delegate?.showAlert(title: "Erreur", description: "chiffre non reconnu")
            return
        }

        // check size on number
        guard expression.count < numberMaxLenght else {
            delegate?.showAlert(title: "Limitation", description: "vous ne pouvez pas dépaser 10 chiffres")
            return
        }

        // check number after point
        if hasPoint {
            guard let index = indexOfPoint, index < 3  else {
                delegate?.showAlert(title: "Limitation", description: "Deux nombres après la virgule maximum")
                return
            }
        }

        if newExpression {
            expression.removeLast()
        }

        expression.append(selection)
        updateDisplay()
        delegate?.updateClearButton("C")
    }

    private var indexOfPoint: Int? {
        if let index = expression.firstIndex(where: {$0 == "."}) {
            let distance = expression.distance(from: index, to: expression.endIndex)
            return distance
        } else {
            return nil
        }
    }

    private var hasPoint: Bool {
        return expression.contains(".")
    }

    func pointHasBeenTapped() {

        guard hasPoint == false else {
            delegate?.showAlert(title: "Erreur", description: "Un point est deja présent")
            return
        }

        // check size on number
        guard expression.count < numberMaxLenght else {
            delegate?.showAlert(title: "Limitation", description: "vous ne pouvez pas dépaser 10 chiffres")
            return
        }

        expression.append(".")
        updateDisplay()
    }

    func clearExpression(_ selection: String) {
        guard selection == "AC" || selection == "C" else {return}

        switch selection {
        case "C":
            if expression.count == 1 {
                expression = "0"
            } else {
                expression.removeLast()
            }

            delegate?.updateClearButton("AC")
        default:
            expression = "0"
        }

        updateDisplay()
    }

    // MARK: - Display
    private func updateDisplay() {
        guard let convertedNumber = calculateConvertedCurrency() else {
            delegate?.showAlert(title: "Erreur", description: "Problème de conversion")
            return
        }
        converted = convertInString(convertedNumber)
        delegate?.updateDisplay(expression, converted: converted)
    }

    private func convertInString (_ floatNumber: Float) -> String {
        var stringFloat: String
        stringFloat = String(format: "%.2f", floatNumber)

        // remove O at the end of expression
        while stringFloat.last == "0"{
            stringFloat.removeLast()
        }
        // remove point if number have no decimal
        if stringFloat.last == "."{
            stringFloat.removeLast()
        }

        return stringFloat
    }

    private func calculateConvertedCurrency() -> Float? {
        guard let expressionNumber = Float(expression) else {return nil}
        let result: Float

        if localCurrencyISOCode == "EUR" {
            guard let rate = exchangeRates[convertedCurrencyISOCode] else {return nil}
            result = expressionNumber * rate
        } else {
            guard let rate = exchangeRates[localCurrencyISOCode] else {return nil}
            result = expressionNumber / rate
        }
        return result
    }

    // MARK: - Rates

    func setupRates(with rates: [String: Float]) {
        exchangeRates = rates

        availableRate = Array(exchangeRates.keys)
        availableRate.append("EUR")
    }

    // MARK: - Switch information
    func switchHasBeenTapped(with localCode: String, convertedCode: String) {
        setCurrencyISOCode(local: localCode, converted: convertedCode)
        expression = converted
        updateDisplay()
    }
}
