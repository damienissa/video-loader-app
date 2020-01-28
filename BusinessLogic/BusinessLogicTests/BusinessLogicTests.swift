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

    private func makeSUT() -> FetchService<Parser<FetchResponse>> {
        FetchService(service: NetworkService(), processor: Core.Parser())
    }
    
    func test_pobratski() {
        
        let urlForTest = URL(string: "https://www.youtube.com/watch?v=PUSJhSVcaJ8")!
        let exp = self.expectation(description: "test_pobratski")
        
        makeSUT().fetch(for: urlForTest) { result in
            
            switch result {
            case .success(let resp):
                XCTAssertEqual(resp.uploaderURL, "http://www.youtube.com/channel/UCelUU2gmSw3A0KWo364vIJg")
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 30)
    }
}
