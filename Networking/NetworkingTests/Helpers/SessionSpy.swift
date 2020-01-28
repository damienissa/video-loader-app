//
//  SessionSpy.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

class SessionSpy: DownloadSession {
    
    static let destenationURL = URL(string: "http://a-url.com")!
    
    var error: NSError?
    
    func startDownload(item: URL, to destenationURL: URL, completion: @escaping (DownloadSessionResult) -> Void) {
        
        downloadingItems.append(item)
        
        if let error = error {
            completion(.result(.failure(error)))
        } else {
            completion(.result(.success(SessionSpy.destenationURL)))
        }
    }
    
    var downloadingItems: [URL] = []
}
