//
//  NetworkSession.swift
//  baluchon
//
//  Created by pierrick viret on 08/08/2023.
//

import Foundation

protocol NetworkSession {
    func loadData(from endPoint: API.Types.EndPoint,
                  completionHandler: @escaping (Result<Data, API.ErrorNetwork>) -> Void)
}

extension URLSession: NetworkSession {

    func loadData(from endpoint: API.Types.EndPoint, completionHandler: @escaping (Result<Data, API.ErrorNetwork>) -> Void) {
        let task = dataTask(with: endpoint.url) { (data, _, error) in
            guard let data else {
                completionHandler(.failure(API.ErrorNetwork.noData(reason: "\(String(describing: error?.localizedDescription))")))
                return
            }
            completionHandler(.success(data))
        }
        task.resume()
    }
}

class NetworkManager {
    private let session: NetworkSession
    static var shared = NetworkManager()

    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    func loadData(from endpoint: API.Types.EndPoint,
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
            return .failure(API.ErrorNetwork.parseData(reason: "Erreur lors du decodage : \(error)"))
        }
    }
}
