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
        case translate([String: String])

        var url: URL {
            switch self {
            case .exchange:
                var componments = URLComponents()
                componments.scheme = "http"
                componments.host = "data.fixer.io"
                componments.path = "/api/latest"
                componments.queryItems = [
                    URLQueryItem(name: "access_key", value: APIKey.fixer.key)
                ]
                return componments.url!

            case .translate(let addQueryItems):
                var componments = URLComponents()
                componments.scheme = "https"
                componments.host = "translation.googleapis.com"
                componments.path = "/language/translate/v2"
                let queryItems = [
                    URLQueryItem(name: "key", value: APIKey.googleTranslate.key),
                    URLQueryItem(name: "q", value: addQueryItems["q"]),
                    URLQueryItem(name: "target", value: addQueryItems["target"])
                ]
                componments.queryItems = queryItems
                return componments.url!
            }
        }
    }

    enum JSONDataType {
        struct TestJSON: Codable, Equatable {
            var testText: String
            var testAuthor: String
        }

        // MARK: - Rate
        struct ExchangeRate: Codable, Equatable {
            var date: String
            var rates: [String: Float]
        }

        // MARK: - Translation
        struct TranslationResponse: Codable, Equatable {
            let data: DataClass
        }

        struct DataClass: Codable, Equatable {
            let translations: [Translation]
        }

        struct Translation: Codable, Equatable {
            let translatedText, detectedSourceLanguage: String
        }

    }
}
