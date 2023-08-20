//
//  Error.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

enum HttpError: Error {
    case badResponse, errorDecodingData
 
    var title: String {
        switch self {
        case .errorDecodingData:
            return "Erreur Data"
        case .badResponse:
            return "Erreur Réseau"
        }

        var description: String {
            switch self {
            case .badResponse:
                return "probleme serveur"
            case .errorDecodingData:
                return "impossible de décoder les données"
            }
        }
    }
}
