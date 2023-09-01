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
    let inputLanguage = UIButton()
    let outputLanguage = UIButton()

    let switchBtn = UIButton()

    var typingTimer: Timer?

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
        outputText.layer.cornerRadius = 25
        outputText.layer.masksToBounds = true

        [inputText, wrappedOutputText, inputLanguage, outputLanguage].forEach {
            $0.layer.cornerRadius = 25
            $0.layer.masksToBounds = false
        }
        setupShadowOf(inputText, radius: 1, opacity: 0.5)
        setupShadowOf(outputLanguage, radius: 1, opacity: 0.5)
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

        // MARK: - Setup Language Button
        [inputLanguage, outputLanguage].forEach {
            $0.backgroundColor = .whiteSmoke
            $0.setTitleColor(.darkGray, for: .normal)
            $0.setTitle("", for: .normal)
            $0.titleLabel?.textAlignment = .center
        }

        outputLanguage.setTitle("Anglais", for: .normal)
        outputLanguage.addTarget(self, action: #selector(showSelectLanguageControlleur), for: .touchUpInside)
        outputLanguage.addTarget(self, action: #selector(holdDown), for: .touchDown)

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
        inputText.tintColor = .lightGray
    }

    // MARK: - SetupLayout
    private func setupLayouts() {
        [inputText, inputLanguage, outputText, outputLanguage, switchBtn, wrappedOutputText].forEach {
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
        view.addSubview(inputLanguage)
        NSLayoutConstraint.activate([
            inputLanguage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            inputLanguage.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            inputLanguage.rightAnchor.constraint(equalTo: switchBtn.leftAnchor, constant: -10),
            inputLanguage.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.addSubview(inputText)
        NSLayoutConstraint.activate([
            inputText.bottomAnchor.constraint(equalTo: switchBtn.topAnchor, constant: -20),
            inputText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            inputText.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            inputText.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15)
        ])

        // MARK: - Output Layout
        view.addSubview(outputLanguage)
        NSLayoutConstraint.activate([
            outputLanguage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            outputLanguage.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            outputLanguage.leftAnchor.constraint(equalTo: switchBtn.rightAnchor, constant: 10),
            outputLanguage.heightAnchor.constraint(equalToConstant: 50)
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
        switchBtn.addTarget(self, action: #selector(switchTraduction), for: .touchUpInside)
    }

    @objc func switchTraduction() {
        UIView.animate(withDuration: 0.5, animations: {
            self.switchBtn.transform = self.switchBtn.transform.rotated(by: .pi)
                })

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.switchLanguage()
            self.switchText()
            self.inputText.resignFirstResponder()
        }
    }

    private func switchText() {
        let oldInput = inputText.text == placeholderTextInput ? "" : inputText.text
        let oldOutput = outputText.text == "" ? placeholderTextInput : outputText.text

        outputText.text = oldInput
        inputText.text = oldOutput
    }

    private func switchLanguage() {
        let oldInput = inputLanguage.titleLabel?.text ?? "Anglais"
        let oldOutput = outputLanguage.titleLabel?.text ?? ""

        inputLanguage.setTitle(oldOutput, for: .normal)
        outputLanguage.setTitle(oldInput, for: .normal)
    }

    // MARK: - select Language
    @objc func showSelectLanguageControlleur() {
        outputLanguage.layer.shadowOpacity = 0.5
        outputLanguage.transform = .identity
        NotificationCenter.default.addObserver(self, selector: #selector(changeOutputLanguage(_:)), name: NSNotification.Name("language"), object: nil)

        let myViewController = SelectLanguageController()
        present(myViewController, animated: true, completion: nil)
    }

    @objc func holdDown() {
        outputLanguage.layer.shadowOpacity = 0
        outputLanguage.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
    }

    @objc func changeOutputLanguage(_ notification: Notification) {
        guard let language = notification.object as? String else { return }
        outputLanguage.setTitle(language, for: .normal)
        showTranslate()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .language, object: nil)
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
        switchBtn.isEnabled = false
        if inputText.text == placeholderTextInput {
            inputText.text = nil
            inputText.textColor = UIColor.black
            inputText.textAlignment = .left
        }
        inputText.layer.shadowOpacity = 0
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        switchBtn.isEnabled = true
        if inputText.text.isEmpty {
            inputText.text = "Inserer le texte à Traduire"
            inputText.textColor = UIColor.lightGray
            inputText.textAlignment = .center
        }
        inputText.layer.shadowOpacity = 0.5
    }

    func textViewDidChange(_ textView: UITextView) {
        typingTimer?.invalidate()

        typingTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                    self.showTranslate()
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
        typingTimer?.invalidate()

        let repository = TranslateRepository()

        guard let text = self.inputText.text,
                text != placeholderTextInput else {return}

        repository.getTraduction(of: self.inputText.text, language: outputLanguage.titleLabel!.text!) { result in
            switch result {
            case .success(let response):
                var text = response.data.translations[0].translatedText
                if let decodedText = text.removingPercentEncoding {
                    text = decodedText
                }
                self.outputText.text = response.data.translations[0].translatedText

                let input = response.data.translations[0].detectedSourceLanguage
                let title = GoogleLanguage.language(input).complete
                self.inputLanguage.setTitle(title, for: .normal)

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
