//
//  NetworkService.swift
//  Networking
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Alamofire

public final class NetworkService: NetworkingService {
    
    private let session: URLSession
    private let manager = DownloadManager()
    
    
    // MARK: - Init
    
    public init(session: URLSession = .shared) {
        
        self.session = session
    }
    
    public func execute<Processor: ResponseProcessor>(_ request: URLRequest, processor: Processor, completion: @escaping (Processor.ProcessingResult) -> Void) {
        
        session.dataTask(with: request) { (d, r, e) in
            completion(processor.process((d, r, e)))
        }.resume()
    }
    
    public func download(item: Downloadable, completion: @escaping (Downloadable, Error?) -> Void) {
        
        item.didFinishDownloading = completion
        manager.download(items: [item])
    }
}

