//
//  APITest.swift
//  baluchonTests
//
//  Created by pierrick viret on 17/08/2023.
//

import XCTest
@testable import baluchon

final class APITest: XCTestCase {

    func testWhenBuildFixerURl_ResultIsCorrect() {
        let fixerURL = API.EndPoint.exchange.url.absoluteString
        let expectedUrl = "http://data.fixer.io/api/latest?access_key=24f22fb918d5b796d6f753c597de0a0d"

        XCTAssertEqual(fixerURL, expectedUrl)
    }
}
