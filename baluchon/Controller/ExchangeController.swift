//
//  ExchangeController.swift
//  baluchon
//
//  Created by pierrick viret on 02/08/2023.
//

import UIKit

class ExchangeController: UIViewController {

    private var calculate: Calculator!

    var buttonsListe = [String: ConverterButton]()
    let buttonsName = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "AC"]

    let localCurrencyLbl = UILabel()
    let convertedCurrencyLbl = UILabel()

    let localCurrencyView = UIView()
    let convertedCurrencyView = UIView()

    let localCurrencyBtn = UIButton()
    let convertedCurrencyBtn = UIButton()

    let switchConverterBtn = UIButton()

    let stackViewMain = UIStackView()
    let stackViewVertical1 = UIStackView()
    let stackViewVertical2 = UIStackView()
    let stackViewVertical3 = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        calculate = Calculator(delegate: self)

        view.backgroundColor = .white

        setupButtons()
        setupButtonLayout()

       setupDisplay()
       setupDisplayLayout()
    }
    override func viewDidAppear(_ animated: Bool) {
        for ( _, button ) in buttonsListe {
            button.layer.cornerRadius = button.frame.height / 2
        }

        let halfWidthView = view.frame.width / 2
        let widthBoutton = buttonsListe["8"]!.frame.width / 2
        let spacing = (halfWidthView - ( widthBoutton * 3 ) ) / 2
        stackViewMain.spacing = spacing
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
            buttonsListe["8"]!.widthAnchor.constraint(equalTo: buttonsListe["8"]!.heightAnchor),
            stackViewMain.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            stackViewMain.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewMain.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 2 )
        ])
    }

    private func setupDisplay() {
        convertedCurrencyBtn.setTitle("USD", for: .normal)
        convertedCurrencyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        convertedCurrencyBtn.setTitleColor(.navy, for: .normal)

        localCurrencyBtn.setTitle("EUR", for: .normal)
        localCurrencyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        localCurrencyBtn.setTitleColor(.navy, for: .normal)

        let blackImage = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        switchConverterBtn.setImage(blackImage, for: .normal)
        switchConverterBtn.backgroundColor = .green
        switchConverterBtn.tintColor = .black

        setupCurrencyLabelName(localCurrencyLbl)
        setupCurrencyLabelName(convertedCurrencyLbl)
    }

    private func setupCurrencyLabelName(_ name: UILabel) {
        name.text = "0"
        name.textAlignment = .right
        name.numberOfLines = 0
        name.adjustsFontSizeToFitWidth = true
        name.font = UIFont.systemFont(ofSize: 60)
    }

    private func setupDisplayLayout() {
        [localCurrencyBtn, localCurrencyLbl, switchConverterBtn, convertedCurrencyBtn, convertedCurrencyLbl, localCurrencyView, convertedCurrencyView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // local currency setup
        localCurrencyView.addSubview(localCurrencyBtn)
        localCurrencyView.addSubview(localCurrencyLbl)
        localCurrencyView.backgroundColor = .red

        // converted currency setup
        convertedCurrencyView.addSubview(convertedCurrencyBtn)
        convertedCurrencyView.addSubview(convertedCurrencyLbl)
        convertedCurrencyView.backgroundColor = .red

        let YReferenceLigne = view.frame.height / 8

        // localCurrencyLayout
        setupViewNamed(localCurrencyView, with: localCurrencyBtn, and: localCurrencyLbl)
        NSLayoutConstraint.activate([
            localCurrencyView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            localCurrencyView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            localCurrencyView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: YReferenceLigne)
        ])

        // cnvertedCurrencyView
        setupViewNamed(convertedCurrencyView, with: convertedCurrencyBtn, and: convertedCurrencyLbl)
        NSLayoutConstraint.activate([
            convertedCurrencyView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            convertedCurrencyView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            convertedCurrencyView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: YReferenceLigne * 3)
        ])

        // switch BTN
        view.addSubview(switchConverterBtn)
        NSLayoutConstraint.activate([
            switchConverterBtn.heightAnchor.constraint(equalTo: switchConverterBtn.widthAnchor),
            switchConverterBtn.widthAnchor.constraint(equalTo: localCurrencyView.heightAnchor),
            switchConverterBtn.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: YReferenceLigne * 2),
            switchConverterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupViewNamed(_ nameView: UIView, with nameButton: UIButton, and nameLabel: UILabel) {
        view.addSubview(nameView)
        NSLayoutConstraint.activate([
            nameButton.leftAnchor.constraint(equalTo: nameView.leftAnchor),
            nameButton.bottomAnchor.constraint(equalTo: nameView.bottomAnchor),
            nameButton.topAnchor.constraint(equalTo: nameView.topAnchor),
            nameButton.heightAnchor.constraint(equalTo: nameButton.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: nameButton.rightAnchor, constant: 30),
            nameLabel.bottomAnchor.constraint(equalTo: nameView.bottomAnchor),
            nameLabel.topAnchor.constraint(equalTo: nameView.topAnchor),
            nameLabel.rightAnchor.constraint(equalTo: nameView.rightAnchor)
        ])
    }

    private func setupStackView(_ stackView: UIStackView, axis: NSLayoutConstraint.Axis) {
        stackView.axis = axis
        stackView.spacing = 10
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
        localCurrencyLbl.text = expression
        guard let expressionNumber = Float(expression) else {return}
        convertedCurrencyLbl.text = "\(expressionNumber * 5)"
    }

    func updateClearButton(_ buttonName: String) {
        buttonsListe["AC"]!.setTitle(buttonName, for: .normal)
    }

}
