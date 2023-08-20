//
//  HTTPClientTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 19/08/2023.
//

import XCTest
@testable import baluchon

final class HTTPClientTest: TestCase {

    var urlSession: URLSession!
    var httpClient: HttpClientProtocol!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        httpClient = HttpClient(urlsession: urlSession)
    }

    func test_GetRate_Succes() throws {
        let response = HTTPURLResponse(url: API.EndPoint.exchange.url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "testJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        httpClient.fetch(url: API.EndPoint.exchange.url) { (response: Result<API.JSONDataType.TestJSON, HttpError>) in
            switch response {
            case .success(let data):
                XCTAssertEqual(data.testAuthor, "julien")
                expectation.fulfill()
            case .failure:
                XCTFail("pas ici")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

    func test_GetRate_WhenDataNotGood_Failure() throws {
        let response = HTTPURLResponse(url: API.EndPoint.exchange.url,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "errorJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        httpClient.fetch(url: API.EndPoint.exchange.url) { (response: Result<API.JSONDataType.TestJSON, HttpError>) in
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

    func test_GetRate_WhenResponseIsGoodAndDataNotGood_Failure() throws {
        let response = HTTPURLResponse(url: API.EndPoint.exchange.url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "errorJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        httpClient.fetch(url: API.EndPoint.exchange.url) { (response: Result<API.JSONDataType.TestJSON, HttpError>) in
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
