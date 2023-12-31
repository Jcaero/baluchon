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

    func getWheather(of coord: Coord, completionHandler: @escaping (Result<API.JSONDataType.WeatherResponse, HttpError>) -> Void) {

        let url = getWeatherURL(of: coord)

        DispatchQueue.main.async {
            self.httpClient.fetch(url: url) { (response: Result<API.JSONDataType.WeatherResponse, HttpError>) in
                switch response {
                case .success(let weather):
                    completionHandler(.success(weather))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    private func getWeatherURL(of coord: Coord) -> URL {
        let latitude = String(coord.lat)
        let longitude = String(coord.lon)

        let queryItems: [String: String] = [ "lat": latitude, "lon": longitude]

        let url = API.EndPoint.weather(queryItems).url

        return url
    }
}
