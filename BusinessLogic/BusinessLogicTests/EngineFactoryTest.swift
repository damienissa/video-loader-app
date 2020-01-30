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
        
        do {
            _ = try EngineFactory.createEngine(store: DatabaseManager.realm(inMemory: true))
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
