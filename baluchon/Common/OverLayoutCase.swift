//
//  OverLayoutCase.swift
//  baluchon
//
//  Created by pierrick viret on 22/08/2023.
//

import Foundation

enum OverLayoutCase {
    case ratesUpdate
    
    var title: String {
        switch self {
        case.ratesUpdate:
            return "Information"
        }
    }
    
    var description: String {
        switch self {
        case.ratesUpdate:
            return "Taux Actualisé"
        }
    }
    
    var imageName: String {
        switch self {
        case.ratesUpdate:
            return "ratesDownload"
        }
    }
    
}
