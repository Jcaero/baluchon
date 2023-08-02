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
    private var elements: [String] {
        return expression.split(separator: " ").map { "\($0)" }
    }

    private  var newExpression: Bool {
        return elements.count == 1 && elements.last == "0"
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
    }
}
