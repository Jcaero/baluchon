//
//  ExchangeRepositoryMock.swift
//  baluchon
//
//  Created by pierrick viret on 18/08/2023.
//

import Foundation

class ExchangeRepositoryMock: ExchangeRepository {
    var data: API.JSONDataType.ExchangeRate?
    var error: Error?

    func getRates(completionHandler: @escaping (Result<API.JSONDataType.ExchangeRate, API.ErrorNetwork>) -> Void) {
        if let data = data {
            completionHandler(.success(data))
        } else {
            completionHandler(.failure(.noData))
        }
    }
}
