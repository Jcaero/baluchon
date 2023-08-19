//
//  HTTPClientTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 19/08/2023.
//

import XCTest
@testable import baluchon

final class HTTPClientTest: XCTestCase {

    var urlSession: URLSession!
    var httpClient: HttpClientProtocol!

    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        httpClient = HttpClient(urlsession: urlSession)
    }

    func getData(fromJson file: String) -> Data? {
        // get bundle of class
        let bundle = Bundle(for: HTTPClientTest.self)
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

        httpClient.fetch(url: API.EndPoint.exchange.url) { (response: Result<API.JSONDataType.TestJSON, Error>) in
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

}
