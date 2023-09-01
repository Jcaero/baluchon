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

    func getTraduction(of query: String, language: String, completionHandler: @escaping (Result<API.JSONDataType.TranslationResponse, HttpError>) -> Void) {

        let target = GoogleLanguage.language(language).code
        let url = getTranslateURL(with: query, target: target)

        DispatchQueue.main.async {
            self.httpClient.fetch(url: url) { (response: Result<API.JSONDataType.TranslationResponse, HttpError>) in
                switch response {
                case .success(let translate):
                    completionHandler(.success(translate))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }

    private func getTranslateURL( with query: String, target: String) -> URL {
        let queryItems: [String: String] = [ "q": query, "target": target]

        let url = API.EndPoint.translate(queryItems).url

        return url
    }
}
