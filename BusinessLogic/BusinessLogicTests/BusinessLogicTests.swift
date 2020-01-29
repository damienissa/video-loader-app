//
//  BusinessLogicTests.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Networking
import Core

class BusinessLogicTests: XCTestCase {
    

    // MARK: - Helper test
    
    func test_urlResponse() {
        
        [199, 300, 500, 400].forEach {
            let sut: URLResponse = HTTPURLResponse(url: URL(string: "http://a-url.com")!, statusCode: $0, httpVersion: nil, headerFields: nil)!
            
            XCTAssert(!sut.isSuccess, "\(sut)")
        }
        
        [200, 204, 250, 299].forEach {
            let sut: URLResponse = HTTPURLResponse(url: URL(string: "http://a-url.com")!, statusCode: $0, httpVersion: nil, headerFields: nil)!
            
            XCTAssert(sut.isSuccess, "\(sut)")
        }
        
        XCTAssert(!URLResponse().isSuccess)
    }
}
