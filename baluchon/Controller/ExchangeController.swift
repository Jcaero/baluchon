//
//  ExchangeController.swift
//  baluchon
//
//  Created by pierrick viret on 02/08/2023.
//

import UIKit

class ExchangeController: UIViewController {

    // MARK: - Properties
    private var exchange: Exchange!

    var buttonsListe = [String: UIButton]()
    let buttonsName = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "AC"]

    let stackViewMain = UIStackView()
    let stackViewVertical1 = UIStackView()
    let stackViewVertical2 = UIStackView()
    let stackViewVertical3 = UIStackView()

    let display = UIView()
    let localCurrencyView = UIView()
    let convertedCurrencyView = UIView()
    var displayPosition = Position.origin

    enum Position {
        case origin
        case switched
    }

    let localCurrencyLbl = UILabel()
    let convertedCurrencyLbl = UILabel()

    let localCurrencyBtn = UIButton()
    let convertedCurrencyBtn = UIButton()

    let switchConverterBtn = UIButton()

    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        exchange = Exchange(delegate: self)

        view.backgroundColor = .white

        setupButtons()
        setupButtonLayout()

       setupDisplay()
       setupDisplayLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        for ( _, button ) in buttonsListe {
            button.layer.cornerRadius = button.frame.height*0.4
            button.layer.masksToBounds = false
            #warning("pourquoi fonctionne ici et pas dans class boutton ????")

            setupShadowOf(button, radius: 2, opacity: 0.5)

            [localCurrencyView, convertedCurrencyView].forEach {
                setupContactShadowOf($0, distance: 20, size: -15)
            }
        }
    }

    private func setupContactShadowOf(_ view: UIView, distance: CGFloat, size: CGFloat) {
        let rect = CGRect(
            x: -size,
            y: view.frame.height - (size * 0.4) + distance,
            width: view.frame.width + size * 2,
            height: size
        )

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.5
        view.layer.shadowPath = UIBezierPath(ovalIn: rect).cgPath
    }

    private func setupShadowOf(_ view: UIView, radius: CGFloat, opacity: Float ) {
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
    }

    // MARK: - ButtonPad
    private func setupButtons() {
        // pad Button
        buttonsName.forEach { name in
            let button = UIButton()
            button.setupExchangeNumberButton(name)
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
            stackViewMain.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            stackViewMain.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewMain.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.45),
            stackViewMain.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.90)
        ])
    }

    private func setupStackView(_ stackView: UIStackView, axis: NSLayoutConstraint.Axis) {
        stackView.axis = axis
        stackView.spacing = 16
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
            exchange.numberHasBeenTapped(titre)
        case ".":
            exchange.pointHasBeenTapped()
        case "AC", "C":
            exchange.clearExpression(titre)
        default:
            print("chiffre non reconnu")
        }
    }

    // MARK: - DISPLAY
    private func setupDisplay() {
        convertedCurrencyBtn.setupCurrencyBoutton(name: "USD")
        localCurrencyBtn.setupCurrencyBoutton(name: "EUR")

        let configurationImage = UIImage.SymbolConfiguration(pointSize: 30)
        let blackImage = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: configurationImage)
        switchConverterBtn.setImage(blackImage, for: .normal)
        switchConverterBtn.tintColor = .black
        switchConverterBtn.addTarget(self, action: #selector(tappedSwitch(_:)), for: .touchUpInside)

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
        [localCurrencyBtn, localCurrencyLbl, switchConverterBtn, convertedCurrencyBtn, convertedCurrencyLbl, localCurrencyView, convertedCurrencyView, display].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(display)
        NSLayoutConstraint.activate([
            display.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            display.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            display.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            display.bottomAnchor.constraint(equalTo: stackViewMain.topAnchor, constant: -20)
        ])

        setupViewNamed(localCurrencyView, with: localCurrencyBtn, and: localCurrencyLbl)
        setupViewNamed(convertedCurrencyView, with: convertedCurrencyBtn, and: convertedCurrencyLbl)

        // switch BTN
        display.addSubview(switchConverterBtn)
        NSLayoutConstraint.activate([
            switchConverterBtn.centerYAnchor.constraint(equalTo: display.centerYAnchor),
            switchConverterBtn.centerXAnchor.constraint(equalTo: display.centerXAnchor)
        ])

        // localCurrencyLayout
        NSLayoutConstraint.activate([
            localCurrencyView.leftAnchor.constraint(equalTo: display.leftAnchor),
            localCurrencyView.rightAnchor.constraint(equalTo: display.rightAnchor),
            localCurrencyView.bottomAnchor.constraint(equalTo: switchConverterBtn.topAnchor, constant: -35)
        ])

        // cnvertedCurrencyView
        NSLayoutConstraint.activate([
            convertedCurrencyView.leftAnchor.constraint(equalTo: display.leftAnchor),
            convertedCurrencyView.rightAnchor.constraint(equalTo: display.rightAnchor),
            convertedCurrencyView.topAnchor.constraint(equalTo: switchConverterBtn.bottomAnchor, constant: 25)
        ])
    }

    private func setupViewNamed(_ nameView: UIView, with nameButton: UIButton, and nameLabel: UILabel) {
        nameView.addSubview(nameButton)
        nameView.addSubview(nameLabel)
        nameView.backgroundColor = .pearlGrey
        nameView.layer.cornerRadius = 30

        nameView.layer.masksToBounds = false

        display.addSubview(nameView)
        NSLayoutConstraint.activate([
            nameButton.leftAnchor.constraint(equalTo: nameView.leftAnchor, constant: 5),
            nameButton.bottomAnchor.constraint(equalTo: nameView.bottomAnchor),
            nameButton.topAnchor.constraint(equalTo: nameView.topAnchor),
            nameButton.heightAnchor.constraint(equalTo: nameButton.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: nameButton.rightAnchor, constant: 30),
            nameLabel.bottomAnchor.constraint(equalTo: nameView.bottomAnchor),
            nameLabel.topAnchor.constraint(equalTo: nameView.topAnchor),
            nameLabel.rightAnchor.constraint(equalTo: nameView.rightAnchor, constant: -10)
        ])
    }

    @objc func tappedSwitch(_ sender: UIButton) {
        switch displayPosition {
        case .origin:
            let originTop = localCurrencyView.frame.origin.y
            let originBottom = convertedCurrencyView.frame.origin.y
            let translationY = originBottom - originTop

            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                self.localCurrencyView.transform = CGAffineTransform(translationX: 0, y: translationY)
                self.convertedCurrencyView.transform = CGAffineTransform(translationX: 0, y: -translationY)
            }

            displayPosition = .switched
        case .switched:
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) {
                self.localCurrencyView.transform = .identity
                self.convertedCurrencyView.transform = .identity
            }
            displayPosition = .origin
        }
    }
}

extension ExchangeController: ExchangeDelegate {
    func updateDisplay(_ expression: String, converted: String) {
        localCurrencyLbl.text = expression
        convertedCurrencyLbl.text = converted
    }
    
    func showAlert(title: String, desciption: String) {
        showSimpleAlerte(with: title, message: desciption)
    }

    func updateClearButton(_ buttonName: String) {
        buttonsListe["AC"]!.setTitle(buttonName, for: .normal)
    }

}
