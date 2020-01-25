//
//  NetworkService.swift
//  Networking
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

public final class NetworkService {
    
    private let session: URLSession
    
    
    // MARK: - Init
    
    public init(session: URLSession = .shared) {
        
        self.session = session
    }
    
    public func execute<Processor: ResponseProcessor>(_ request: URLRequest, processor: Processor, completion: @escaping (Processor.ProcessingResult) -> Void) {
        
        session.dataTask(with: request) { (d, r, e) in
            completion(processor.process((d, r, e)))
        }.resume()
    }
}
