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
    let placeholderTextInput = "Inserer le texte à Traduire"

    // MARK: - Language
    let leftLanguage = UILabel()
    let rightLanguage = UILabel()
    let wrappedOutputLanguage = UIView()
    let wrappedinputLanguage = UIView()

    let switchBtn = UIButton()
    var displayPosition = Position.origin

    enum Position {
        case origin
        case switched
    }

    var inputLanguage: String? {
        get {
            return displayPosition == .origin ? leftLanguage.text : rightLanguage.text
        }
        set(newSourceLanguage) {
            switch displayPosition {
            case .origin:
                leftLanguage.text = newSourceLanguage
            case .switched:
                rightLanguage.text = newSourceLanguage
            }
        }
    }

    var outputLanguage: String? {
        get {
            return displayPosition == .origin ? rightLanguage.text : leftLanguage.text
        }
        set(newSourceLanguage) {
            switch displayPosition {
            case .origin:
                rightLanguage.text = newSourceLanguage
            case .switched:
                leftLanguage.text = newSourceLanguage
            }
        }
    }

    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupViews()
        setupLayouts()

        setupSwitchButton()
        setupTextView()
        setupGestureRecogniser()
    }

    override func viewWillLayoutSubviews() {
        [ leftLanguage, rightLanguage, outputText ].forEach {
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
        switchBtn.setImage(UIImage(systemName: "arrow.left.arrow.right", withConfiguration: configurationImage), for: .normal)
        switchBtn.tintColor = .navy

        // MARK: - Setup Language label
        [leftLanguage, rightLanguage].forEach {
            $0.backgroundColor = .whiteSmoke
            $0.textColor = .darkGray
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.text = ""
        }
        rightLanguage.text = "Anglais"

        // MARK: - Setup Texte
        [outputText].forEach {
            $0.backgroundColor = .whiteSmoke
            $0.textColor = .darkGray
            $0.textAlignment = .center
            $0.numberOfLines = 6
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
        [inputText, leftLanguage, outputText, rightLanguage, switchBtn, wrappedOutputText, wrappedinputLanguage, wrappedOutputLanguage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // MARK: - SwitchText Layout
        view.addSubview(switchBtn)
        NSLayoutConstraint.activate([
            switchBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switchBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            switchBtn.heightAnchor.constraint(equalTo: switchBtn.widthAnchor),
            switchBtn.heightAnchor.constraint(equalToConstant: 50)
        ])

        // MARK: - Input Layout
        view.addSubview(wrappedinputLanguage)
        NSLayoutConstraint.activate([
            wrappedinputLanguage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            wrappedinputLanguage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            wrappedinputLanguage.rightAnchor.constraint(equalTo: switchBtn.leftAnchor, constant: -10),
            wrappedinputLanguage.heightAnchor.constraint(equalToConstant: 50)
        ])

        wrappedinputLanguage.addSubview(leftLanguage)
        NSLayoutConstraint.activate([
            leftLanguage.topAnchor.constraint(equalTo: wrappedinputLanguage.topAnchor),
            leftLanguage.bottomAnchor.constraint(equalTo: wrappedinputLanguage.bottomAnchor),
            leftLanguage.leftAnchor.constraint(equalTo: wrappedinputLanguage.leftAnchor),
            leftLanguage.rightAnchor.constraint(equalTo: wrappedinputLanguage.rightAnchor)
        ])

        view.addSubview(inputText)
        NSLayoutConstraint.activate([
            inputText.bottomAnchor.constraint(equalTo: switchBtn.topAnchor, constant: -20),
            inputText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            inputText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            inputText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15)
        ])

        // MARK: - Output Layout
        view.addSubview(wrappedOutputLanguage)
        NSLayoutConstraint.activate([
            wrappedOutputLanguage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            wrappedOutputLanguage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            wrappedOutputLanguage.leftAnchor.constraint(equalTo: switchBtn.rightAnchor, constant: 10),
            wrappedOutputLanguage.heightAnchor.constraint(equalToConstant: 50)
        ])

        wrappedOutputLanguage.addSubview(rightLanguage)
        NSLayoutConstraint.activate([
            rightLanguage.topAnchor.constraint(equalTo: wrappedOutputLanguage.topAnchor),
            rightLanguage.bottomAnchor.constraint(equalTo: wrappedOutputLanguage.bottomAnchor),
            rightLanguage.leftAnchor.constraint(equalTo: wrappedOutputLanguage.leftAnchor),
            rightLanguage.rightAnchor.constraint(equalTo: wrappedOutputLanguage.rightAnchor)
        ])

        view.addSubview(wrappedOutputText)
        NSLayoutConstraint.activate([
            wrappedOutputText.topAnchor.constraint(equalTo: switchBtn.bottomAnchor, constant: 20),
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
        switchBtn.addTarget(self, action: #selector(switchLanguage), for: .touchUpInside)
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
        switchText()
    }

    private func switchText() {
        let oldInput = inputText.text == placeholderTextInput ? "" : inputText.text
        let oldOutput = outputText.text == "" ? placeholderTextInput : outputText.text

        outputText.text = oldInput
        inputText.text = oldOutput
    }
}
// MARK: - TextView
extension TranslateController: UITextViewDelegate {

    private func setupTextView() {
        inputText.delegate = self
        inputText.text = placeholderTextInput
        inputText.textColor = UIColor.lightGray
        inputText.textAlignment = .center
        inputText.adjustsFontForContentSizeCategory = true
        // screen under iphone 7
        if UIScreen.main.bounds.size.height < 800 {
            inputText.font = UIFont.systemFont(ofSize: 30)
        } else {
            inputText.font = UIFont.systemFont(ofSize: 40)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if inputText.textColor == UIColor.lightGray {
            inputText.text = nil
            inputText.textColor = UIColor.black
            inputText.textAlignment = .left
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if inputText.text.isEmpty {
            inputText.text = "Inserer le texte à Traduire"
            inputText.textColor = UIColor.lightGray
            inputText.textAlignment = .center
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                showTranslate()
                self.inputText.resignFirstResponder()
                return false
            }

            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            if numberOfChars > 80 {
                return false
            }

            if text == " " {
                showTranslate()
            }
            return true
    }

    private func showTranslate() {
        let repository = TranslateRepository()

        guard let targetLanguage = outputLanguage,
                let text = self.inputText.text,
                text != placeholderTextInput else {return}

        if targetLanguage == "" { outputLanguage = "Anglais" }

        repository.getTraduction(of: self.inputText.text, language: targetLanguage) { result in
            switch result {
            case .success(let response):
                var text = response.data.translations[0].translatedText
                if let decodedText = text.removingPercentEncoding {
                    text = decodedText
                }
                self.outputText.text = response.data.translations[0].translatedText

                let input = response.data.translations[0].detectedSourceLanguage
                self.inputLanguage = GoogleLanguage.language(input).complete

            case .failure(let error):
                self.showSimpleAlerte(with: error.title, message: error.description)
            }
        }
    }

    private func setupGestureRecogniser() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        inputText.resignFirstResponder()
        showTranslate()
    }
}
