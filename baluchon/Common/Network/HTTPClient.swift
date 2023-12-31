//
//  HTTPClient.swift
//  baluchon
//
//  Created by pierrick viret on 19/08/2023.
//

import Foundation

protocol HttpClientProtocol {
    func fetch<T: Codable>(url: URL, completion: @escaping (Result<T, HttpError>) -> Void)
}

class HttpClient: HttpClientProtocol {

    private var urlSession: URLSession

    init(urlsession: URLSession = URLSession.shared) {
        self.urlSession = urlsession
    }

    func fetch<T: Codable>(url: URL, completion: @escaping (Result<T, HttpError>) -> Void) {
        self.urlSession.dataTask(with: url, completionHandler: { data, response, _ in

            DispatchQueue.main.async {
                guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                    completion(.failure(HttpError.badResponse))
                    return
                }
                guard let data = data,
                      let object = try? JSONDecoder().decode(T.self, from: data) else {
                    completion(.failure(HttpError.errorDecodingData))
                    return
                }
                completion(.success(object))
            }
        }).resume()
    }
}
