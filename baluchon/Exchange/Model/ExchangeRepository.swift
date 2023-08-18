//
//  ExchangeRepository.swift
//  baluchon
//
//  Created by pierrick viret on 16/08/2023.
//

import Foundation

protocol ExchangeRepository {
    func getRates(completionHandler: @escaping (Result<API.JSONDataType.ExchangeRate, API.ErrorNetwork>) -> Void)
}

class ForeignExchangeRatesAPI: ExchangeRepository {

    let APIManager: NetworkManager

    init(APIManager: NetworkManager = NetworkManager()) {
        self.APIManager = APIManager
    }

    func getRates(completionHandler: @escaping (Result<API.JSONDataType.ExchangeRate, API.ErrorNetwork>) -> Void) {
        APIManager.loadData(from: .exchange) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let resultDecode = self.APIManager.decodeJSON(jsonData: data, to: API.JSONDataType.ExchangeRate.self)
                    switch resultDecode {
                    case .success(let decode):
                        completionHandler(.success(decode))
                    case .failure:
                        completionHandler(.failure(.parseData))
                    }
                case .failure:
                    return completionHandler(.failure(.noData))
                }
            }
        }
    }
}
