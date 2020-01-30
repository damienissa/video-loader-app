//
//  EngineFactory.swift
//  Core
//
//  Created by Dima Virych on 27.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

public struct EngineFactory {
    
    public static func createEngine(network: NetworkingService = NetworkService(), store: Storage) -> Engine {
        
        Engine(network, database: store)
    }
}
