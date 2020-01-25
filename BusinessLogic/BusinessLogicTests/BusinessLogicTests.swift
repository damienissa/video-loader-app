//
//  BusinessLogicTests.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import BusinessLogic

class BusinessLogicTests: XCTestCase {

    private func makeSUT() -> FetchService {
        FetchService()
    }
    
    func test_pobratski() {
        
        let urlForTest = URL(string: "https://www.youtube.com/watch?v=PUSJhSVcaJ8")!
        let exp = self.expectation(description: "test_pobratski")
        var channel: String?
        
        makeSUT().fetch(for: urlForTest) { result in
            
            switch result {
            case .success(let resp):
                channel = resp.uploaderURL
            case .failure(let error):
                print(error)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 30)
        XCTAssertEqual(channel, "http://www.youtube.com/channel/UCelUU2gmSw3A0KWo364vIJg")
    }
}
