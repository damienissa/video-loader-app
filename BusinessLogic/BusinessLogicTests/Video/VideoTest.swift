//
//  VideoTest.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Core

class VideoTest: XCTestCase {

    func test_factory() {
        
        let response = VProvider()
        let sut = makeSUT(with: response)
        
        XCTAssertEqual(sut.id, response.id)
    }
    
    func makeSUT(with response: VideoProvider) -> Video {
        VideoFactory.video(from: response)
    }
    
    struct VProvider: VideoProvider {
        
        var title: String = "1"
        
        var id: String = "1"
        
        var thumbnail: String = "1"
        
        var resources: [ResourceProvider] = []
    }
}
