//
//  TranslateRepositoryTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 23/08/2023.
//
import XCTest
@testable import baluchon

final class TranslateRepositoryTest: TestCase {

    var urlSession: URLSession!
    var repository: TranslateRepository!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        repository = TranslateRepository(httpClient: HttpClient(urlsession: urlSession))
    }

    override func tearDown() {
            repository = nil
            urlSession = nil

            super.tearDown()
        }

    func test_RepositoryGetTraduction_Succes() throws {
        let query = "je teste l'API"
        let result = "I test the API"

        let response = HTTPURLResponse(url: API.EndPoint.translate(["q": query, "target": "en"]).url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "TranslateJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        repository.getTraduction(of: query, language: "Anglais") { response in
            switch response {
            case .success(let translate):
                XCTAssertEqual(translate.data.translations[0].translatedText, result)
                XCTAssertEqual(translate.data.translations[0].detectedSourceLanguage, "fr")
                expectation.fulfill()
            case .failure:
                XCTFail("pas ici")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

    func test_RepositoryGetTraduction_WhenDataNotGood_Failure() throws {
        let query = ""
 
        let response = HTTPURLResponse(url: API.EndPoint.translate(["q": query, "target": "en"]).url,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "TranslateErrorJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        repository.getTraduction(of: query, language: "Anglais") { response in
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
