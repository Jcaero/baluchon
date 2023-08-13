//
//  OverLayerPopUP.swift
//  baluchon
//
//  Created by pierrick viret on 12/08/2023.
//
import UIKit

class OverLayerPopUP: UIViewController {
    var backView = UIView()
    var contentView = UIView()

    let stackView = UIStackView()

    let imageView = UIImageView()
    let titleLbl = UILabel()
    let descriptionLbl = UILabel()
    let doneBtn = UIButton()

    init(_ name: String, description: String) {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        titleLbl.text = name
        descriptionLbl.text = description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        setupViewsLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        contentView.layer.cornerRadius = 10
        imageView.layer.cornerRadius = 5
        doneBtn.layer.cornerRadius = 5
    }

    private func configViews() {
        view.backgroundColor = .clear
        backView.backgroundColor = .black.withAlphaComponent(0.6)
        contentView.backgroundColor = .whiteSmoke
        backView.alpha = 0
        contentView.alpha = 0

        imageView.image = UIImage(named: "oops")
        imageView.layer.masksToBounds = true

        setupButton()
        setupLabel()
    }

    private func setupViewsLayout() {
        [backView, contentView, imageView, titleLbl, descriptionLbl, doneBtn, stackView ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(backView)
        NSLayoutConstraint.activate([
            backView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 350),
            contentView.widthAnchor.constraint(equalToConstant: 240)
        ])

        setupStackView()
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        addInStackView(views: [imageView, titleLbl, descriptionLbl, doneBtn])
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        NSLayoutConstraint.activate([
            doneBtn.heightAnchor.constraint(equalToConstant: 50),
            doneBtn.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            doneBtn.rightAnchor.constraint(equalTo: stackView.rightAnchor)
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
    }

    private func addInStackView ( views: [UIView]) {
        views.forEach {
            stackView.addArrangedSubview($0)
        }
    }

    private func setupButton() {
        doneBtn.layer.cornerRadius = 4
        doneBtn.backgroundColor = .red
        doneBtn.setTitleColor(.white, for: .normal)
        doneBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        doneBtn.setTitle("OK", for: .normal)
        doneBtn.tintColor = .white
    }

    private func setupLabel() {
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.systemFont(ofSize: 30, weight: .ultraLight)

        descriptionLbl.textAlignment = .center

    }

    // MARK: - Action

    func appear( sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }

    private func show() {
        UIView.animate(withDuration: 1, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    @objc private func hide() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: {_ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }

}
