//
//  UIViewController+.swift
//  baluchon
//
//  Created by pierrick viret on 03/08/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showSimpleAlerte(with titre: String, message: String) {
        let alertVC = UIAlertController(title: titre, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return self.present(alertVC, animated: true, completion: nil)
    }
}
