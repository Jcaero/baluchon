//
//  Calculator.swift
//  baluchon
//
//  Created by pierrick viret on 02/08/2023.
//

import Foundation

protocol CalculatorDelegate: AnyObject {
    func showAlert(title: String, desciption: String)
    func updateDisplay(_ expression: String)
    func updateClearButton(_ buttonName: String)
}

class Calculator {
// delegate
    private weak var delegate: CalculatorDelegate?

    init(delegate: CalculatorDelegate?) {
        self.delegate = delegate
        expression = "0"
    }

    // expression
     var expression: String

    private  var newExpression: Bool {
        return expression == "0"
    }

    private let numberAvailable: Set = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    // configuration
    private let numberMaxLenght = 10

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

        if newExpression {
            expression.removeLast()
        }

        expression.append(selection)
        delegate?.updateDisplay(expression)
        delegate?.updateClearButton("C")
    }

    private var hasPoint: Bool {
        return !expression.contains(".")
    }

    func pointHasBeenTapped() {

        guard hasPoint else {
            delegate?.showAlert(title: "Erreur", desciption: "Un point est deja présent")
            return
        }
        expression.append(".")
        delegate?.updateDisplay(expression)
    }

    func clearExpression(_ selection: String) {
        if selection == "AC" {
            expression = "0"
        } else if selection == "C" {
            expression.removeLast()
            delegate?.updateClearButton("AC")
        }
        delegate?.updateDisplay(expression)
    }
}
