//
//  API.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
// swiftlint:disable identifier_name

import Foundation

enum API {
    enum EndPoint {
        case exchange
        case translate([String: String])
        case weather([String: String])
        case geocoding([String: String])

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

            case .weather(let addQueryItems):
                var componments = URLComponents()
                componments.scheme = "https"
                componments.host = "api.openweathermap.org"
                componments.path = "/data/2.5/forecast"
                let queryItems = [
                    URLQueryItem(name: "appid", value: APIKey.openwheathermap.key),
                    URLQueryItem(name: "lat", value: addQueryItems["lat"]),
                    URLQueryItem(name: "lon", value: addQueryItems["lon"]),
                    URLQueryItem(name: "lang", value: "fr"),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "cnt", value: "10")
                ]
                componments.queryItems = queryItems
                return componments.url!

            case .geocoding(let addQueryItems):
                var componments = URLComponents()
                componments.scheme = "https"
                componments.host = "api.openweathermap.org"
                componments.path = "/geo/1.0/direct"
                let queryItems = [
                    URLQueryItem(name: "appid", value: APIKey.openwheathermap.key),
                    URLQueryItem(name: "q", value: addQueryItems["q"]),
                    URLQueryItem(name: "limit", value: "5")
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

        // MARK: - Meteo
        struct WeatherResponse: Codable, Equatable {
            let cod: String
            let message, cnt: Int
            let list: [List]
            let city: City
        }

        // MARK: - Geocoding
        struct GeocodingResponse: Codable, Equatable {
            let name: String
            let lat, lon: Double
            let country: String
            let local_names: [String: String]?
        }
    }
}

// MARK: - Translate
struct DataClass: Codable, Equatable {
    let translations: [Translation]
}

struct Translation: Codable, Equatable {
    let translatedText, detectedSourceLanguage: String
}

// MARK: - Weather
struct City: Codable, Equatable {
    let name: String
    let coord: Coord
    let country: String
    let sunrise, sunset: Int?
}

struct Coord: Codable, Equatable {
    let lat, lon: Double
}

struct List: Codable, Equatable {
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let visibility: Int
    let dt_txt: String
}

struct Main: Codable, Equatable {
    let temp, feels_like, temp_min, temp_max: Double
    let pressure, humidity: Int
}

struct Weather: Codable, Equatable {
    let id: Int
    let main, description, icon: String
}

struct Wind: Codable, Equatable {
    let speed: Double
    let deg: Int
    let gust: Double
}
