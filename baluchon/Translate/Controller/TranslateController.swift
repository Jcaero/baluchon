//
//  TranslateController.swift
//  baluchon
//
//  Created by pierrick viret on 24/08/2023.
//

import UIKit

class TranslateController: UIViewController {
    // MARK: - Properties

    let inputText = UITextField()
    let outputText = UILabel()
    let wrappedOutputText = UIView()

    let switchText = UIButton()

    let inputLanguage = UILabel()
    let outputLanguage = UILabel()

    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupViews()
        setupLayouts()
    }

    override func viewWillLayoutSubviews() {
        [inputLanguage, outputLanguage].forEach {
            $0.layer.cornerRadius = $0.frame.height * 0.5
            $0.layer.masksToBounds = false

            setupShadowOf($0, radius: 1, opacity: 0.5)
        }
        
        outputText.layer.cornerRadius = 30
        outputText.layer.masksToBounds = true

        [inputText, wrappedOutputText].forEach {
            $0.layer.cornerRadius = 30
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
        inputText.placeholder = "Tapez le texte à traduire"
    }

    // MARK: - SetupLayout
    private func setupLayouts() {
        [inputText, inputLanguage, outputText, outputLanguage, switchText, wrappedOutputText].forEach {  $0.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(inputLanguage)
        NSLayoutConstraint.activate([
            inputLanguage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputLanguage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            inputLanguage.rightAnchor.constraint(equalTo: switchText.leftAnchor, constant: -10),
            inputLanguage.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(inputText)
        NSLayoutConstraint.activate([
            inputText.bottomAnchor.constraint(equalTo: switchText.topAnchor, constant: -20),
            inputText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            inputText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            inputText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15)
        ])

        // MARK: - Output Layout
        view.addSubview(outputLanguage)
        NSLayoutConstraint.activate([
            outputLanguage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            outputLanguage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            outputLanguage.leftAnchor.constraint(equalTo: switchText.rightAnchor, constant: 10),
            outputLanguage.heightAnchor.constraint(equalToConstant: 50)
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
}
