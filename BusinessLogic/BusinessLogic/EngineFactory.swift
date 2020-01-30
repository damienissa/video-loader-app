//
//  EngineFactory.swift
//  Core
//
//  Created by Dima Virych on 27.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

public struct EngineFactory {
    
    public static func createEngine(network: NetworkingService = NetworkService(), store: Storage? = nil) throws -> Engine {
        
        if let stor = store {
            return Engine(network, database: stor)
        } else {
            return Engine(network, database: try DatabaseManager.realm())
        }
    }
}
