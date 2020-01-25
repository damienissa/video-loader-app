//
//  NetworkingTests.swift
//  NetworkingTests
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Networking

class NetworkingTests: XCTestCase {

    func test_simpleRequest() {
        
        var result: Data?
        let exp = self.expectation(description: "test_simpleRequest")
        makeSUT().execute(makeRequest(), processor: ProcessorSPY()) { res in
            
            result = res
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 10)
        XCTAssertNotNil(result)
    }
    
    // MARK: - Helper
    
    private func makeSUT() -> NetworkService {
        NetworkService()
    }
    
    private func makeRequest() -> URLRequest {
        URLRequest(url: URL(string: "https://google.com")!)
    }
    
    struct ProcessorSPY: ResponseProcessor {
        
        struct D: Encodable {
            let name: String
        }
        enum Err: Error {
            case unknown
        }

        func process(_ response: Response) -> Data? {
            
            response.data
        }
    }
}
