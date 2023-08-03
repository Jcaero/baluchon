//
//  ExchangeController.swift
//  baluchon
//
//  Created by pierrick viret on 02/08/2023.
//

import UIKit

class ExchangeController: UIViewController {

    var buttonListe = [String: UIButton]()

    let localCurrencyLbl = UILabel()
    let convertedCurrencyLbl = UILabel()

    let localCurrencyBtn = UIButton()
    let convertedCurrencyBtn = UIButton()

    let buttonsName = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]

    private var calculate: Calculator!

    override func viewDidLoad() {
        super.viewDidLoad()
        calculate = Calculator(delegate: self)
        setupButtons()

    }

    func setupButtons() {
        buttonsName.forEach { name in
            let button = ConverterButton(name: name)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(tappedButton(_:)), for: .touchUpInside)
            self.buttonListe[name] = button
        }
    }

    @objc func tappedButton(_ sender: UIButton) {
        guard let titre = sender.currentTitle else {return}

        switch titre {
        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            calculate.numberHasBeenTapped(titre)
        case ".":
            calculate.pointHasBeenTapped()
        case "AC", "C":
            calculate.clearExpression(titre)
        default:
            print("chiffre non reconnu")
        }
    }

}

extension ExchangeController: CalculatorDelegate {
    func showAlert(title: String, desciption: String) {
        showSimpleAlerte(with: title, message: desciption)
    }

    func updateDisplay(_ expression: String) {
        convertedCurrencyLbl.text = expression
    }

    func updateClearButton(_ buttonName: String) {
        buttonListe["AC"]!.setTitle(buttonName, for: .normal)
    }

}
