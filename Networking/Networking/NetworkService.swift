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
    private var completion: ((Downloadable, Error?) -> Void)?
    
    
    // MARK: - Init
    
    public init(session: URLSession = .shared) {
        
        self.session = session
        
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieve), name: Notification.Name(rawValue: kDownloadManagerDidFinishDownloadingNotification), object: nil)
    }
    
    public func execute<Processor: ResponseProcessor>(_ request: URLRequest, processor: Processor, completion: @escaping (Processor.ProcessingResult) -> Void) {
        
        session.dataTask(with: request) { (d, r, e) in
            completion(processor.process((d, r, e)))
        }.resume()
    }
    
    public func download(item: Downloadable, completion: @escaping (Downloadable, Error?) -> Void) {
        
        self.completion = completion
        manager.download(items: [item])
    }
    
    @objc private func didRecieve(_ notification: Notification) {
        
        if let obj = notification.object as? Downloadable {
            completion?(obj, notification.userInfo?["error"] as? Error)
        }
    }
}

