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

        if newExpression {
            expression.removeLast()
        }

        expression.append(selection)
        updateDisplay()
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
    func updateDisplay() {
        
        guard let expressionNumber = Float(expression) else {return}
        let converted = "\(expressionNumber * 5)"
        delegate?.updateDisplay(expression, converted: converted)
    }
}
