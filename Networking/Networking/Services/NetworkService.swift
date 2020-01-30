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
    private let manager: Downloader
    
    
    // MARK: - Init
    
    public init(session: URLSession = .shared, downloader: Downloader = DownloadManager(session: AlamofireSessionManager())) {
        
        self.manager = downloader
        self.session = session
    }
    
    public func execute<Processor: ResponseProcessor>(_ request: URLRequest,
                                                      processor: Processor,
                                                      completion: @escaping (Processor.ProcessingResult) -> Void) {
        
        session.dataTask(with: request) { (d, r, e) in
            completion(processor.process((d, r, e)))
        }.resume()
    }
    
    public func download(item: Downloadable,
                         to destinationURL: URL,
                         with progress: DownloadProgress? = nil,
                         completion: @escaping (DownloadingResult) -> Void) {
        
        manager.download(item: item, to: destinationURL, progress: progress, downloadingResult: completion)
    }
}

