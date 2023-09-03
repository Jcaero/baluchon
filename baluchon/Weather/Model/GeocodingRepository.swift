//
//  GeocodingRepository.swift
//  baluchon
//
//  Created by pierrick viret on 02/09/2023.
//

import Foundation

class GeocodingRepository {

    private var httpClient: HttpClient

    init(httpClient: HttpClient = HttpClient(urlsession: URLSession.shared)) {
        self.httpClient = httpClient
    }

    func getCoordinate(of city: String, completionHandler: @escaping (Result<[API.JSONDataType.GeocodingResponse], HttpError>) -> Void) {

        let url = getGeocodeURL(of: city)

        DispatchQueue.main.async {
            self.httpClient.fetch(url: url) { (response: Result<[API.JSONDataType.GeocodingResponse], HttpError>) in
                switch response {
                case .success(let weather):
                    completionHandler(.success(weather))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    private func getGeocodeURL(of city: String) -> URL {
        let queryItems: [String: String] = [ "q": city]
        let url = API.EndPoint.geocoding(queryItems).url
        return url
    }
}
