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
        case weather([String: String])

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
                componments.path = "data/2.5/forecast"
                let queryItems = [
                    URLQueryItem(name: "appid", value: APIKey.openwheathermap.key),
                    URLQueryItem(name: "lat", value: addQueryItems["lat"]),
                    URLQueryItem(name: "long", value: addQueryItems["long"]),
                    URLQueryItem(name: "lang", value: "fr"),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "cnt", value: "3")
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
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct Coord: Codable, Equatable {
    let lat, lon: Double
}

struct List: Codable, Equatable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain: Rain?
}

struct Clouds: Codable, Equatable {
    let all: Int
}

struct Main: Codable, Equatable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
}

struct Rain: Codable, Equatable {
    let the3H: Double
}

struct Sys: Codable, Equatable {
    let pod: String
}

struct Weather: Codable, Equatable {
    let id: Int
    let main, weatherDescription, icon: String
}

struct Wind: Codable, Equatable {
    let speed: Double
    let deg: Int
    let gust: Double
}

