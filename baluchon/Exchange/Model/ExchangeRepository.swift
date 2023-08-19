//
//  ExchangeRepository.swift
//  baluchon
//
//  Created by pierrick viret on 16/08/2023.
//

import Foundation

class ExchangeRepository {

    private var httpClient: HttpClient

    init(httpClient: HttpClient = HttpClient(urlsession: URLSession.shared)) {
        self.httpClient = httpClient
    }

    func getRates(completionHandler: @escaping (Result<API.JSONDataType.ExchangeRate, Error>) -> Void) {
        httpClient.fetch(url: API.EndPoint.exchange.url) { (response: Result<API.JSONDataType.ExchangeRate, Error>)in
            switch response {
            case .success(let rate):
                completionHandler(.success(rate))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
