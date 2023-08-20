//
//  ExchangeRepositoryNew.swift
//  baluchonTests
//
//  Created by pierrick viret on 19/08/2023.
//

import XCTest
@testable import baluchon

final class ExchangeRepositoryTest: TestCase {

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

    func test_RepositoryGetRate_WhenDataNotGood_Failure() throws {
        let response = HTTPURLResponse(url: API.EndPoint.exchange.url,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "errorJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        repository.getRates { response in
            switch response {
            case .success:
                XCTFail("pas ici")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2)
    }
}
