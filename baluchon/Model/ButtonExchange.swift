//
//  Button.swift
//  baluchon
//
//  Created by pierrick viret on 05/08/2023.
//

import UIKit

extension UIButton {

    func setupExchangeNumberButton(_ name: String) {
        self.setTitle(name, for: .normal)
        self.setTitleColor(.navy, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        self.backgroundColor = .pearlGrey

        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true

        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2
    }

    func setupCurrencyBoutton(name: String) {
        self.setTitle(name, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.setTitleColor(.navy, for: .normal)
    }

}
