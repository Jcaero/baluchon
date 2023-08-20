//
//  Error.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData

    var title: String {
        switch self {
        case .badURL, .errorDecodingData:
            return "Erreur Réseau"
        case .badResponse:
            return "Erreur Réseau"
        }

        var description: String {
            switch self {
            case .badResponse, .badURL:
                return "probleme serveur"
            case .errorDecodingData:
                return "impossible de décoder les données"
            }
        }
    }
}

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
