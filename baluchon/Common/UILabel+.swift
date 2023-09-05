//
//  UILabel+.swift
//  baluchon
//
//  Created by pierrick viret on 05/09/2023.
//

import Foundation
import UIKit

extension UILabel {
    func setup(with color: UIColor, alignment: NSTextAlignment, font: UIFont) {
        self.textColor = color
        self.textAlignment = alignment
        self.font = font
        self.adjustsFontSizeToFitWidth = true
    }
}
