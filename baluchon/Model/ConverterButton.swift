//
//  ConverterButton.swift
//  baluchon
//
//  Created by pierrick viret on 29/07/2023.
//

import UIKit

final class ConverterButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(name: String) {
        super.init(frame: .zero)
        self.setTitle(name, for: .normal)
        self.setTitleColor(.navy, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        self.backgroundColor = .pearlGrey
    }

    init(imageName: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: imageName), for: .normal)
        self.setTitleColor(.navy, for: .normal)
        self.backgroundColor = .pearlGrey
    }

    let numberButton = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    let returnButton = "delete.left"

}
