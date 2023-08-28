//
//  TranslateRepository.swift
//  baluchon
//
//  Created by pierrick viret on 22/08/2023.
//

import Foundation

class TranslateRepository {

    private var httpClient: HttpClient

    init(httpClient: HttpClient = HttpClient(urlsession: URLSession.shared)) {
        self.httpClient = httpClient
    }

    func getTraduction(of query: String, completionHandler: @escaping (Result<API.JSONDataType.TranslationResponse, HttpError>) -> Void) {

        let url = getTranslateURL(with: query)

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

    private func getTranslateURL( with query: String) -> URL {
        let queryItems: [String: String] = [ "q": query, "target": "en"]

        let url = API.EndPoint.translate(queryItems).url

        return url
    }
}
