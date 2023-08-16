//
//  Error.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

extension API {
    enum ErrorNetwork: Error {
        case noData
        case parseData

        var title: String {
            switch self {
            case .noData:
                return "Erreur Réseau"
            case .parseData:
                return "Erreur Réseau"
            }
        }

        var description: String {
            switch self {
            case .noData:
                return "pas de data chargée"
            case .parseData:
                return "impossible de décoder les données"
            }
        }
    }
}
