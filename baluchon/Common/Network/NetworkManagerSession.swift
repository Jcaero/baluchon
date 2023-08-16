//
//  NetworkSession.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

// MARK: - Protocol
protocol NetworkSession {
    func loadData(from endPoint: API.EndPoint,
                  completionHandler: @escaping (Result<Data, API.ErrorNetwork>) -> Void)
}

extension URLSession: NetworkSession {

    func loadData(from endpoint: API.EndPoint, completionHandler: @escaping (Result<Data, API.ErrorNetwork>) -> Void) {
        let task = dataTask(with: endpoint.url) { (data, _, error) in
            guard let data else {
                completionHandler(.failure(.noData))
                return
            }
            completionHandler(.success(data))
        }
        task.resume()
    }
}

// MARK: - NetworkManager
class NetworkManager {
    private let session: NetworkSession

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func loadData(from endpoint: API.EndPoint,
                  completionHandler: @escaping (Result<Data, API.ErrorNetwork>) -> Void) {
        session.loadData(from: endpoint) { result in
            completionHandler(result)
        }
    }

    func decodeJSON<T: Codable>(jsonData: Data, to type: T.Type) -> (Result<T, Error>) {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(T.self, from: jsonData)
            return .success(decodeData)
        } catch {
            return .failure(error)
        }
    }
}
