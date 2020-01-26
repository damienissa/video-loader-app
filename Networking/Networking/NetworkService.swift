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
    
    
    // MARK: - Init
    
    public init(session: URLSession = .shared) {
        
        self.session = session
    }
    
    public func execute<Processor: ResponseProcessor>(_ request: URLRequest, processor: Processor, completion: @escaping (Processor.ProcessingResult) -> Void) {
        
        session.dataTask(with: request) { (d, r, e) in
            completion(processor.process((d, r, e)))
        }.resume()
    }
    
    public func download(url: URL, destURL: URL?, completion: @escaping (URL?) -> Void) {
        
        session.downloadTask(with: url) { localURL, urlResponse, error in
        
            completion(localURL)
        }.resume()
        
//        Alamofire.download(url) { (<#URL#>, <#HTTPURLResponse#>) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//            <#code#>
//        }
    }
}

