//
//  FetchService.swift
//  BusinessLogic
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

public final class FetchService<Processor: ResponseProcessor> {
    
    private let processor: Processor
    private let service: NetworkingService
    
    public init(service: NetworkingService, processor: Processor) {
        
        self.service = service
        self.processor = processor
    }
    
    public func fetch(for url: URL,
                      completion: @escaping (Processor.ProcessingResult) -> Void) {
        
        service.execute(createRequest(with: url), processor: processor, completion: completion)
    }
    
    private func createRequest(with url: URL) -> URLRequest {
        
        var requst = URLRequest(url: URL(string: "https://getvideo.p.rapidapi.com/?url=\(url.absoluteString)")!)
        requst.allHTTPHeaderFields = [
            "x-rapidapi-host": "getvideo.p.rapidapi.com",
            "x-rapidapi-key": "XVUjZNU8ctmshJX55lqaZaN943fkp1oPusejsn9S4lZa198c3Q"
        ]
        
        requst.cachePolicy = .reloadIgnoringLocalCacheData
        
        return requst
    }
}
