//
//  ExchangeController.swift
//  baluchon
//
//  Created by pierrick viret on 02/08/2023.
//

import UIKit

class ExchangeController: UIViewController {

    private var calculate: Calculator!

    var buttonsListe = [String: UIButton]()
    let buttonsName = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "AC"]

    let localCurrencyLbl = UILabel()
    let convertedCurrencyLbl = UILabel()

    let localCurrencyBtn = UIButton()
    let convertedCurrencyBtn = UIButton()
    let switchConverterBtn = UIButton()

    let stackViewMain = UIStackView()
    let stackViewVertical1 = UIStackView()
    let stackViewVertical2 = UIStackView()
    let stackViewVertical3 = UIStackView()
    let spacingBetweenButton: CGFloat = 25

    override func viewDidLoad() {
        super.viewDidLoad()
        calculate = Calculator(delegate: self)

        view.backgroundColor = .white

        setupButtons()
        setupButtonLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        for ( _, button ) in buttonsListe {
            button.layer.cornerRadius = button.frame.width/2
        }
    }

    private func setupButtons() {
        // pad Button
        buttonsName.forEach { name in
            let button = ConverterButton(name: name)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(tappedButton(_:)), for: .touchUpInside)
            self.buttonsListe[name] = button
        }

        // switch button
        switchConverterBtn.layer.masksToBounds = true
        switchConverterBtn.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupButtonLayout() {
        setupStackView(stackViewMain, axis: .horizontal)
        [stackViewVertical1, stackViewVertical2, stackViewVertical3].forEach {
            setupStackView($0, axis: .vertical)
            stackViewMain.addArrangedSubview($0)
        }

        // setup stackview
        addButtonInStackView(stackViewVertical1, array: ["7", "4", "1", "AC"])
        addButtonInStackView(stackViewVertical2, array: ["8", "5", "2", "0"])
        addButtonInStackView(stackViewVertical3, array: ["9", "6", "3", "."])

        view.addSubview(stackViewMain)
        NSLayoutConstraint.activate([
            buttonsListe["7"]!.widthAnchor.constraint(equalTo: buttonsListe["7"]!.heightAnchor),
            stackViewMain.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -spacingBetweenButton),
            stackViewMain.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: spacingBetweenButton),
            stackViewMain.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -spacingBetweenButton)
        ])
    }

    private func setupStackView(_ stackView: UIStackView, axis: NSLayoutConstraint.Axis) {
        stackView.axis = axis
        stackView.spacing = spacingBetweenButton
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func addButtonInStackView(_ stackView: UIStackView, array: [String]) {
        for buttonName in array {
            if let button = buttonsListe[buttonName] {
                stackView.addArrangedSubview(button)
            }
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
        buttonsListe["AC"]!.setTitle(buttonName, for: .normal)
    }

}
