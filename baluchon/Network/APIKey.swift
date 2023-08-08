//
//  APIKey.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation
extension API {
    enum APIKey {
        case exchange
        case test
        
        var user: String {
            return "test"
        }
    }
}
