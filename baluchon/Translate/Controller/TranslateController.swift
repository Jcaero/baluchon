//
//  TranslateController.swift
//  baluchon
//
//  Created by pierrick viret on 24/08/2023.
//

import UIKit

class TranslateController: UIViewController {
    // MARK: - Properties

    let inputText = UITextView()
    let outputText = UILabel()
    let wrappedOutputText = UIView()

    let inputLanguage = UILabel()
    let outputLanguage = UILabel()
    let wrappedOutputLanguage = UIView()
    let wrappedinputLanguage = UIView()

    let switchText = UIButton()
    var displayPosition = Position.origin

    enum Position {
        case origin
        case switched
    }

    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupViews()
        setupLayouts()

        setupSwitchButton()
    }

    override func viewWillLayoutSubviews() {
        [ inputLanguage, outputLanguage, outputText ].forEach {
            $0.layer.cornerRadius = 25
            $0.layer.masksToBounds = true
        }

        [inputText, wrappedOutputText, wrappedOutputLanguage, wrappedinputLanguage].forEach {
            $0.layer.cornerRadius = 25
            $0.layer.masksToBounds = false

            setupShadowOf($0, radius: 1, opacity: 0.5)
        }
    }

    private func setupShadowOf(_ view: UIView, radius: CGFloat, opacity: Float ) {
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = radius
    }

    // MARK: - Setup Views
    private func setupViews() {
        // MARK: - Setup SwitchText
        let configurationImage = UIImage.SymbolConfiguration(pointSize: 30, weight: .ultraLight)
        switchText.setImage(UIImage(systemName: "arrow.left.arrow.right", withConfiguration: configurationImage), for: .normal)
        switchText.tintColor = .navy

        // MARK: - Setup Language label
        [inputLanguage, outputLanguage].forEach {
            $0.backgroundColor = .whiteSmoke
            $0.textColor = .darkGray
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.text = ""
        }
        outputLanguage.text = "Anglais"

        // MARK: - Setup Texte
        [outputText].forEach {
            $0.backgroundColor = .whiteSmoke
            $0.textAlignment = .right
            $0.adjustsFontSizeToFitWidth = true
            $0.text = ""
        }

        wrappedOutputText.backgroundColor = .whiteSmoke

        inputText.textAlignment = .center
        inputText.backgroundColor = .whiteSmoke
//        inputText.placeholder = "Tapez le texte à traduire"
    }

    // MARK: - SetupLayout
    private func setupLayouts() {
        [inputText, inputLanguage, outputText, outputLanguage, switchText, wrappedOutputText, wrappedinputLanguage, wrappedOutputLanguage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // MARK: - SwitchText Layout
        view.addSubview(switchText)
        NSLayoutConstraint.activate([
            switchText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switchText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            switchText.heightAnchor.constraint(equalTo: switchText.widthAnchor),
            switchText.heightAnchor.constraint(equalToConstant: 50)
        ])

        // MARK: - Input Layout
        view.addSubview(wrappedinputLanguage)
        NSLayoutConstraint.activate([
            wrappedinputLanguage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            wrappedinputLanguage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            wrappedinputLanguage.rightAnchor.constraint(equalTo: switchText.leftAnchor, constant: -10),
            wrappedinputLanguage.heightAnchor.constraint(equalToConstant: 50)
        ])

        wrappedinputLanguage.addSubview(inputLanguage)
        NSLayoutConstraint.activate([
            inputLanguage.topAnchor.constraint(equalTo: wrappedinputLanguage.topAnchor),
            inputLanguage.bottomAnchor.constraint(equalTo: wrappedinputLanguage.bottomAnchor),
            inputLanguage.leftAnchor.constraint(equalTo: wrappedinputLanguage.leftAnchor),
            inputLanguage.rightAnchor.constraint(equalTo: wrappedinputLanguage.rightAnchor)
        ])

        view.addSubview(inputText)
        NSLayoutConstraint.activate([
            inputText.bottomAnchor.constraint(equalTo: switchText.topAnchor, constant: -20),
            inputText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            inputText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            inputText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15)
        ])

        // MARK: - Output Layout
        view.addSubview(wrappedOutputLanguage)
        NSLayoutConstraint.activate([
            wrappedOutputLanguage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            wrappedOutputLanguage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            wrappedOutputLanguage.leftAnchor.constraint(equalTo: switchText.rightAnchor, constant: 10),
            wrappedOutputLanguage.heightAnchor.constraint(equalToConstant: 50)
        ])

        wrappedOutputLanguage.addSubview(outputLanguage)
        NSLayoutConstraint.activate([
            outputLanguage.topAnchor.constraint(equalTo: wrappedOutputLanguage.topAnchor),
            outputLanguage.bottomAnchor.constraint(equalTo: wrappedOutputLanguage.bottomAnchor),
            outputLanguage.leftAnchor.constraint(equalTo: wrappedOutputLanguage.leftAnchor),
            outputLanguage.rightAnchor.constraint(equalTo: wrappedOutputLanguage.rightAnchor)
        ])

        view.addSubview(wrappedOutputText)
        NSLayoutConstraint.activate([
            wrappedOutputText.topAnchor.constraint(equalTo: switchText.bottomAnchor, constant: 20),
            wrappedOutputText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            wrappedOutputText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            wrappedOutputText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15)
        ])

        wrappedOutputText.addSubview(outputText)
        NSLayoutConstraint.activate([
            outputText.topAnchor.constraint(equalTo: wrappedOutputText.topAnchor),
            outputText.bottomAnchor.constraint(equalTo: wrappedOutputText.bottomAnchor),
            outputText.leftAnchor.constraint(equalTo: wrappedOutputText.leftAnchor),
            outputText.rightAnchor.constraint(equalTo: wrappedOutputText.rightAnchor)
        ])
    }

    // MARK: - Switch
    private func setupSwitchButton() {
        switchText.addTarget(self, action: #selector(switchLanguage), for: .touchUpInside)
    }

    @objc func switchLanguage() {
        var transformInput: CGAffineTransform
        var transformOutput: CGAffineTransform

        switch displayPosition {
        case .origin:
            let originInput = wrappedinputLanguage.frame.origin.x
            let originOutput = wrappedOutputLanguage.frame.origin.x
            let translationX = originOutput - originInput
            transformInput = CGAffineTransform(translationX: translationX, y: 0)
            transformOutput = CGAffineTransform(translationX: -translationX, y: 0)

            displayPosition = .switched

        case .switched:
            transformInput = .identity
            transformOutput = .identity

            displayPosition = .origin
        }

        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       animations: {
                                    self.wrappedinputLanguage.transform = transformInput
                                    self.wrappedOutputLanguage.transform = transformOutput
                                    })
    }
}
