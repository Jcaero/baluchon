//
//  GeocodingRepositoryTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 02/09/2023.
//

import XCTest
@testable import baluchon

final class GeocodingRepositoryTest: TestCase {

    var urlSession: URLSession!
    var repository: GeocodingRepository!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        repository = GeocodingRepository(httpClient: HttpClient(urlsession: urlSession))
    }

    override func tearDown() {
        repository = nil
        urlSession = nil
        
        super.tearDown()
    }

    func test_RepositoryGetCoordinate_Succes() throws {

        let response = HTTPURLResponse(url: API.EndPoint.geocoding(["q": "annecy"]).url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "geocodingJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        repository.getCoordinate(of: "annecy") { response in
            switch response {
            case .success(let city):
                XCTAssertEqual(city[0].name, "Annecy")
                XCTAssertEqual(city[0].country, "FR")
                XCTAssertEqual(city[0].lat, 45.8992348)
                XCTAssertEqual(city[0].lon, 6.1288847)
                XCTAssertEqual(city[0].local_names!["ru"], "Анси")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("pas ici, \(error.description)")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

    func test_RepositoryGetCoordinate_WhenDataNotGood_Failure() throws {

        let response = HTTPURLResponse(url: API.EndPoint.geocoding(["q": "annecy"]).url,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "geocodingErrorJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        repository.getCoordinate(of: "annecy") { response in
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
