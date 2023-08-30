//
//  WeatherRepository.swift
//  baluchon
//
//  Created by pierrick viret on 30/08/2023.
//

import Foundation

class WeatherRepository {

    private var httpClient: HttpClient

    init(httpClient: HttpClient = HttpClient(urlsession: URLSession.shared)) {
        self.httpClient = httpClient
    }

    func getWheather(of city: City, completionHandler: @escaping (Result<API.JSONDataType.TranslationResponse, HttpError>) -> Void) {

        let url = getTranslateURL(for: city)

        DispatchQueue.main.async {
            self.httpClient.fetch(url: url) { (response: Result<API.JSONDataType.TranslationResponse, HttpError>) in
                switch response {
                case .success(let rate):
                    completionHandler(.success(rate))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    private func getTranslateURL(for city: City) -> URL {
        let latitude = String(city.coord.lat)
        let longitude = String(city.coord.lon)

        let queryItems: [String: String] = [ "lat": latitude, "long": longitude]

        let url = API.EndPoint.translate(queryItems).url

        return url
    }
}
