//
//  Error.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

extension API {
    enum ErrorNetwork: Error {
        case noData(reason: String)
        case parseData(reason: String)
        
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
            case .noData(let reason):
                return "pas de data : \(reason)"
            case .parseData(let reason):
                return "data not decodable \(reason)"
            }
        }
    }
}
