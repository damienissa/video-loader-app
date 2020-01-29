//
//  EngineFactoryTest.swift
//  BusinessLogicTests
//
//  Created by Dima Virych on 29.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import XCTest
import Core

class EngineFactoryTest: XCTestCase {
    
    func test_engineCreation() {
        
        XCTAssertNotNil(EngineFactory.createEngine())
    }
}
