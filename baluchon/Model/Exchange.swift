//
//  Exchange.swift
//  baluchon
//
//  Created by pierrick viret on 07/08/2023.
//

import Foundation

protocol ExchangeDelegate: AnyObject {
    func showAlert(title: String, desciption: String)
    func updateDisplay(_ expression: String, converted: String)
    func updateClearButton(_ buttonName: String)
}

class Exchange {
    // MARK: - Delegate
    private weak var delegate: ExchangeDelegate?

    init(delegate: ExchangeDelegate?) {
        self.delegate = delegate
        expression = "0"
    }

    // MARK: - Expression
     var expression: String

    private  var newExpression: Bool {
        return expression == "0"
    }

    private let numberAvailable: Set = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    // MARK: - Configuration
    private let numberMaxLenght = 10

    // MARK: - PAD Methode
    func numberHasBeenTapped(_ selection: String) {
        guard numberAvailable.contains(selection) else {
            delegate?.showAlert(title: "Erreur", desciption: "chiffre non reconnu")
            return
        }

        // check size on number
        guard expression.count < numberMaxLenght else {
            delegate?.showAlert(title: "Erreur", desciption: "vous ne pouvez pas dépaser 10 chiffres")
            return
        }

        // check number after point
        if hasPoint {
            guard indexOfPoint! < 3  else {
                delegate?.showAlert(title: "Limitation", desciption: "Deux nombres après la virgule Maximum")
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
            delegate?.showAlert(title: "Erreur", desciption: "Un point est deja présent")
            return
        }
        expression.append(".")
        updateDisplay()
    }

    func clearExpression(_ selection: String) {
        if selection == "AC" {
            expression = "0"
        } else if selection == "C" {
            expression.removeLast()
            delegate?.updateClearButton("AC")
        }
        updateDisplay()
    }

    // MARK: - Display
    private func updateDisplay() {

        guard let expressionNumber = Float(expression) else {return}
        let converted = expressionNumber * 5
        let convertedString = convertInString(converted)
        delegate?.updateDisplay(expression, converted: convertedString)
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
}
