//
//  API.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

enum API {
    enum EndPoint {
        case exchange

        var url: URL {
            switch self {
            case .exchange:
                var componments = URLComponents()
                componments.scheme = "http"
                componments.host = "data.fixer.io/api/"
                componments.path = "latest"
                componments.queryItems = [
                    URLQueryItem(name: "access_key", value: APIKey.fixer.key)
                ]
                return componments.url!
            }
        }
    }

    enum JSONDataType {
        struct TestJSON: Codable, Equatable {
            var testText: String
            var testAuthor: String
        }

        struct ExchangeRate: Codable, Equatable {
            var date: String
            var rates: [String: Float]
        }
    }
}
