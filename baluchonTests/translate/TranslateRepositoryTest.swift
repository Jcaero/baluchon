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

    func test_RepositoryGetRate_Succes() throws {
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
}
