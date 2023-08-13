//
//  NetworkSessionMock.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

class NetworkManagerMock: NetworkSession {
    var data: Data?
    var error: Error?

    func loadData(from url: API.EndPoint, completionHandler: @escaping (Result<Data, API.ErrorNetwork>) -> Void) {
        if let data = data {
            completionHandler(.success(data))
        } else {
            completionHandler(.failure(API.ErrorNetwork.noData(reason: "no data load : \(String(describing: error?.localizedDescription))")))
        }
    }
}
