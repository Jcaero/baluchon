//
//  WeatherRepositoryTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 01/09/2023.
//

import XCTest
@testable import baluchon

final class WeatherRepositoryTest: TestCase {

    var urlSession: URLSession!
    var repository: WeatherRepository!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        repository = WeatherRepository(httpClient: HttpClient(urlsession: urlSession))
    }

    override func tearDown() {
            repository = nil
            urlSession = nil

            super.tearDown()
        }

    func test_RepositoryGetWeather_Succes() throws {
        let coord = Coord(lat: 45.8992348, lon: 6.1288847)
        let annecy = City(name: "Annecy",
                          coord: coord,
                          country: "FR",
                          sunrise: 1693371206,
                          sunset: 1693419571)

        let response = HTTPURLResponse(url: API.EndPoint.weather(["lat": String(coord.lat), "lon": String(coord.lon)]).url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "weatherJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        repository.getWheather(of: annecy.coord) { response in
            switch response {
            case .success(let weather):
                XCTAssertEqual(weather.city.name, "Annecy")
                XCTAssertEqual(weather.list[0].main.temp, 9.15)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("pas ici, \(error.description)")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

    func test_RepositoryGetWeather_WhenDataNotGood_Failure() throws {
        let coord = Coord(lat: 45.8992348, lon: 6.1288847)
        let annecy = City(name: "Annecy",
                          coord: coord,
                          country: "FR",
                          sunrise: 1693371206,
                          sunset: 1693419571)

        let response = HTTPURLResponse(url: API.EndPoint.weather(["lat": String(coord.lat), "lon": String(coord.lon)]).url,
                                       statusCode: 401,
                                       httpVersion: nil,
                                       headerFields: nil)!

        let mockData = self.getData(fromJson: "weatherErrorJSON")!

        MockURLProtocol.requestHandler = { _ in
            return (response, mockData)
        }

        let expectation = XCTestExpectation(description: "response")

        repository.getWheather(of: annecy.coord)  { response in
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
