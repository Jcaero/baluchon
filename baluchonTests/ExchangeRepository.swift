//
//  ExchangeRepositoryNew.swift
//  baluchonTests
//
//  Created by pierrick viret on 19/08/2023.
//

import XCTest
@testable import baluchon

final class ExchangeRepositoryTest: XCTestCase {

    var urlSession: URLSession!
    var repository: ExchangeRepository!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        repository = ExchangeRepository(httpClient: HttpClient(urlsession: urlSession))
    }

    override func tearDown() {
            repository = nil
            urlSession = nil

            super.tearDown()
        }

    func getData(fromJson file: String) -> Data? {
        // get bundle of class
        let bundle = Bundle(for: ExchangeRepositoryTest.self)
        // get url of file and data
        if let url = bundle.url(forResource: file, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    return data
                } catch {
                    print("Error reading data: \(error)")
                    return nil
                }
            } else {
                print("File not found")
                return nil
            }
    }

    func test_RepositoryGetRate_Succes() throws {
        let response = HTTPURLResponse(url: API.EndPoint.exchange.url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "RatesJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        repository.getRates { response in
            switch response {
            case .success(let rates):
                XCTAssertEqual(rates.date, "2023-08-16")
                expectation.fulfill()
            case .failure:
                XCTFail("pas ici")
            }
        }
        wait(for: [expectation], timeout: 2)
    }
}

