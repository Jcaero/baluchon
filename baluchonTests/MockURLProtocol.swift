//
//  MockURLProtocol.swift
//  baluchonTests
//
//  Created by pierrick viret on 19/08/2023.
//

import Foundation
import XCTest

class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    // protocol active or not
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // return the request
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    // start the request, put the mock
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("No handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    // cancel or finish request
    override func stopLoading() {}
}
