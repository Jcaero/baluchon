//
//  ExchangeRepositoryTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 16/08/2023.
//

import XCTest
@testable import baluchon

final class ExchangeRepositoryTest: XCTestCase {

    var session: NetworkManagerMock!
    var manager: NetworkManager!
    var repository: ForeignExchangeRatesAPI!

    var data: Data!

    override func setUp() {
        super.setUp()
        session = NetworkManagerMock()
        manager = NetworkManager(session: session)
        repository = ForeignExchangeRatesAPI(APIManager: manager)
        data = self.getData(fromJson: "RatesJSON")!
    }

    override func tearDown() {
        super.tearDown()
        session = nil
        manager = nil
        repository = nil
        data = nil
    }

    func getData(fromJson file: String) -> Data? {
        // get bundle of class
        let bundle = Bundle(for: NetworkTest.self)
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

    func testWhenCall_DataIsCorrect() {
        let expectedData = getData(fromJson: "RatesJSON")!
        self.session.data = expectedData

        self.repository.getRates { result in
            switch result {
            case .success(let decode):
                XCTAssertEqual(decode.date, "2023-08-16")
                XCTAssertEqual(decode.rates["USD"], 1.092759)

            case .failure:
                XCTFail("testSuccessFulResponse should have data")
            }
        }
    }

    func testWhenCall_DataIsNotCorrect() {
        let incorrectData = "Erreur".data(using: .utf8)
        self.session.data = incorrectData

        self.repository.getRates { result in
            switch result {
            case .success:
                XCTFail("testSuccessFulResponse should not success")

            case .failure(let error):
                XCTAssertEqual(error.title, "Erreur Réseau")
                print("Erreur de decode: \(error.description)")

            }
        }
    }

    func testNoDataLoaded_ShowError() {
        self.session.data = nil

        self.repository.getRates { result in
            switch result {
            case .success:
                XCTFail("testSuccessFulResponse should not success")

            case .failure(let error):
                XCTAssert(true)
                XCTAssertEqual(error.title, "Erreur Réseau")
                print("Erreur de chargement: \(error.description)")
            }
        }
    }
}
