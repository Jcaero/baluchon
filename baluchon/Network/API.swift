//
//  API.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

enum API {
    enum Types {
        enum EndPoint {
            case quote
            case image
            
            var url: URL {
                switch self{
                case .image:
                    return URL(string: "https://source.unsplash.com/random/1000x1000")!
                case .quote:
                    var componments = URLComponents()
                    componments.scheme = "https"
                    componments.host = "api.forismatic.com"
                    componments.path = "/api/1.0/"
                    componments.queryItems = [
                    URLQueryItem(name: "method", value: "getQuote"),
                    URLQueryItem(name: "format", value: "json"),
                    URLQueryItem(name: "lang", value: "en"),
                    ]
                    return componments.url!
                }
            }
        }
}
