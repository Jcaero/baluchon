//
//  NetworkTest.swift
//  baluchonTests
//
//  Created by pierrick viret on 08/08/2023.
//

import XCTest
@testable import baluchon

final class NetworkTest: XCTestCase {

    var session: NetworkSessionMock!
    var manager: NetworkManager!

    var data: Data!

    override func setUp() {
        super.setUp()
         session = NetworkSessionMock()
        manager = NetworkManager(session: session)
        data = self.getData(fromJson: "testJSON")!
    }

    override func tearDown() {
        super.tearDown()
        session = nil
        manager = nil
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

    func testSuccessFulResponse() {
        let expectedData = getData(fromJson: "testJSON")!
        self.session.data = expectedData

        self.manager.loadData(from: API.EndPoint.exchange) { response in
            switch response {
            case .success(let data):
                XCTAssertEqual(data, expectedData)
            case .failure:
                XCTFail("testSuccessFulResponse should have data")
            }
        }
    }

}
