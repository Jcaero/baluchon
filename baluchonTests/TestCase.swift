//
//  File.swift
//  baluchonTests
//
//  Created by pierrick viret on 19/08/2023.
//

import Foundation
import XCTest

class TestCase: XCTestCase {

    func getData(fromJson file: String) -> Data? {
        // get bundle of class
        let bundle = Bundle(for: APITest.self)
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
}
