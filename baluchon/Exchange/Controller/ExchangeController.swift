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

    let displayArea = UIView()
    let localCurrencyView = UIView()
    let convertedCurrencyView = UIView()
    var displayPosition = Position.origin

    enum Position {
        case origin
        case switched
    }

    let warningLimitation = UILabel()

    let localCurrencyLbl = UILabel()
    let convertedCurrencyLbl = UILabel()

    let localCurrencyBtn = UIButton()
    let convertedCurrencyBtn = UIButton()

    let switchConverter = UIImageView()
    var canUseButton: Bool = true

    var dateUpdateRate: Date?

    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        exchange = Exchange(delegate: self)

        view.backgroundColor = .white

        setupButtons()
        setupButtonLayout()

        setupDisplay()
        setupDisplayLayout()
        setupWarningLimitation()

        setupGestureRecogniser()
    }

    override func viewDidAppear(_ animated: Bool) {
        for ( _, button ) in buttonsListe {
            button.layer.cornerRadius = button.frame.height*0.2
            button.layer.masksToBounds = false

            setupShadowOf(button, radius: 1, opacity: 0.5)
        }

        setupShadowOf(localCurrencyView, radius: 1, opacity: 0.5)
        setupShadowOf(convertedCurrencyView, radius: 1, opacity: 0.5)

        let localButtonLabel = localCurrencyBtn.currentTitle!
        let convertedButtonLabel = convertedCurrencyBtn.currentTitle!

        switch displayPosition {
        case .origin:
            exchange.setCurrencyISOCode(local: localButtonLabel, converted: convertedButtonLabel)
        case .switched:
            exchange.setCurrencyISOCode(local: convertedButtonLabel, converted: localButtonLabel)
        }
        #warning("a enlever en prod")
        // checkRates()
    }

    private func setupShadowOf(_ view: UIView, radius: CGFloat, opacity: Float ) {
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.lightGray.cgColor
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
            button.addTarget(self, action: #selector(holdDown), for: .touchDown)

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
        sender.transform = .identity
        sender.layer.shadowOpacity = 0.5

        guard canUseButton == true else {return}

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

    @objc func holdDown(sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        sender.layer.shadowOpacity = 0
    }

    // MARK: - DISPLAY
    private func setupDisplay() {
        convertedCurrencyBtn.setupCurrencyBoutton(name: "USD")
        localCurrencyBtn.setupCurrencyBoutton(name: "EUR")

        let configurationImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .ultraLight)
        switchConverter.image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: configurationImage)
        switchConverter.tintColor = .darkGray

        setupCurrencyLabelName(localCurrencyLbl)
        setupCurrencyLabelName(convertedCurrencyLbl)
    }

    private func setupCurrencyLabelName(_ name: UILabel) {
        name.text = "0"
        name.textAlignment = .right
        name.numberOfLines = 0
        name.adjustsFontSizeToFitWidth = true
        name.font = UIFont.systemFont(ofSize: 60, weight: .ultraLight)
    }

    private func setupDisplayLayout() {
        [localCurrencyBtn, localCurrencyLbl, switchConverter, convertedCurrencyBtn, convertedCurrencyLbl, localCurrencyView, convertedCurrencyView, displayArea].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(displayArea)
        NSLayoutConstraint.activate([
            displayArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            displayArea.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            displayArea.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            displayArea.bottomAnchor.constraint(equalTo: stackViewMain.topAnchor, constant: -20)
        ])

        setupViewNamed(localCurrencyView, with: localCurrencyBtn, and: localCurrencyLbl)
        setupViewNamed(convertedCurrencyView, with: convertedCurrencyBtn, and: convertedCurrencyLbl)

        // switch BTN
        displayArea.addSubview(switchConverter)
        NSLayoutConstraint.activate([
            switchConverter.centerYAnchor.constraint(equalTo: displayArea.centerYAnchor),
            switchConverter.centerXAnchor.constraint(equalTo: displayArea.centerXAnchor)
        ])

        // localCurrencyLayout
        NSLayoutConstraint.activate([
            localCurrencyView.leftAnchor.constraint(equalTo: displayArea.leftAnchor),
            localCurrencyView.rightAnchor.constraint(equalTo: displayArea.rightAnchor),
            localCurrencyView.bottomAnchor.constraint(equalTo: switchConverter.topAnchor, constant: -35),
            localCurrencyView.heightAnchor.constraint(equalToConstant: 71)
        ])

        // cnvertedCurrencyView
        NSLayoutConstraint.activate([
            convertedCurrencyView.leftAnchor.constraint(equalTo: displayArea.leftAnchor),
            convertedCurrencyView.rightAnchor.constraint(equalTo: displayArea.rightAnchor),
            convertedCurrencyView.topAnchor.constraint(equalTo: switchConverter.bottomAnchor, constant: 25),
            convertedCurrencyView.heightAnchor.constraint(equalToConstant: 71)
        ])
    }

    private func setupViewNamed(_ nameView: UIView, with nameButton: UIButton, and nameLabel: UILabel) {
        nameView.addSubview(nameButton)
        nameView.addSubview(nameLabel)
        nameView.backgroundColor = .whiteSmoke
        nameView.layer.cornerRadius = 30

        nameView.layer.masksToBounds = false

        displayArea.addSubview(nameView)
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

    private func setupWarningLimitation() {
        warningLimitation.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        warningLimitation.textColor = .red
        displayArea.addSubview(warningLimitation)
        warningLimitation.textAlignment = .center
        warningLimitation.isHidden = true
        warningLimitation.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            warningLimitation.widthAnchor.constraint(equalTo: localCurrencyView.widthAnchor),
            warningLimitation.centerXAnchor.constraint(equalTo: localCurrencyView.centerXAnchor),
            warningLimitation.bottomAnchor.constraint(equalTo: switchConverter.topAnchor, constant: -12)
        ])
    }

    // MARK: - Switch
    @objc func tappedSwitch() {
        canUseButton = false

        let localButtonLabel = localCurrencyBtn.currentTitle!
        let convertedButtonLabel = convertedCurrencyBtn.currentTitle!

        var transformLocal: CGAffineTransform
        var transformConverted: CGAffineTransform

        switch displayPosition {
        case .origin:
            let originTop = localCurrencyView.frame.origin.y
            let originBottom = convertedCurrencyView.frame.origin.y
            let translationY = originBottom - originTop
            transformLocal = CGAffineTransform(translationX: 0, y: translationY)
            transformConverted = CGAffineTransform(translationX: 0, y: -translationY)

            exchange.setCurrencyISOCode(local: convertedButtonLabel, converted: localButtonLabel)
            displayPosition = .switched

        case .switched:
            transformLocal = .identity
            transformConverted = .identity

            displayPosition = .origin
            exchange.setCurrencyISOCode(local: localButtonLabel, converted: convertedButtonLabel)
        }

        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       animations: {
                                    self.localCurrencyView.transform = transformLocal
                                    self.convertedCurrencyView.transform = transformConverted
                                    },
                       completion: { [weak self] _ in
                                    self?.canUseButton = true
        })

        exchange.switchHasBeenTapped()
    }

    private func setupGestureRecogniser() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedSwitch))
        tap.numberOfTouchesRequired = 1
        displayArea.addGestureRecognizer(tap)
    }

    // MARK: - Rates
    private func checkRates () {
        guard let yesterday = getYesterday() else {return}

        guard dateUpdateRate == nil || dateUpdateRate! <= yesterday else {return}

        downloadRates()
    }

    private func convertInDate( date: String) -> Date? {
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let newDate = dateFormatter.date(from: dateString) {
            return newDate
        } else {
            return nil
        }
    }

    private func downloadRates() {
        canUseButton = false
        let repository = ExchangeRepository()
        repository.getRates { [weak self] response in
                guard let self = self else {return}

                switch response {
                case .success(let data):
                    guard let date = self.convertInDate(date: data.date),
                          let rates = data.rates as? [String: Float] else {
                        self.showAlert(title: "erreur", description: "Probleme de donnée, rechager le taux de change")
                        self.canUseButton = true
                        return
                    }
                    self.dateUpdateRate = date
                    self.exchange.setupRates(with: rates)
                    self.canUseButton = true

                    let overlayer = OverLayerPopUP(.ratesUpdate)
                    self.present(overlayer, animated: false)

                case .failure(let error):
                    self.showAlert(title: error.title, description: error.description)
                    self.canUseButton = true
                }
            }
    }

    func getYesterday() -> Date? {
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
        return yesterday ?? nil
    }
}

// MARK: - Delegate

extension ExchangeController: ExchangeDelegate {
    func updateDisplay(_ expression: String, converted: String) {
//        if expression == "666" {
//            let overLayer = OverLayerPopUP("Oops !", description: "Test de Julien")
//            overLayer.appear(sender: self)
//        }
        switch displayPosition {
        case .origin:
            localCurrencyLbl.text = expression
            convertedCurrencyLbl.text = converted
        case .switched:
            localCurrencyLbl.text = converted
            convertedCurrencyLbl.text = expression
        }
    }

    func showAlert(title: String, description: String) {
        if title == "Limitation" {
            let text = title + ": " + description
            warningLimitation.text = text
            warningLimitation.isHidden = false

            // call after 5s to hidde
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                self?.warningLimitation.isHidden = true
                   }
        } else {
            showSimpleAlerte(with: title, message: description)
        }
    }

    func updateClearButton(_ buttonName: String) {
        buttonsListe["AC"]!.setTitle(buttonName, for: .normal)
    }
}
