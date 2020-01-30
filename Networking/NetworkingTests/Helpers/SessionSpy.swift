//
//  SessionSpy.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

class SessionSpy: DownloadSession {
    
    static let destinationURL = URL(string: "http://a-url.com")!
    
    var error: NSError?
    var completion: ((DownloadSessionResult) -> Void)?
    
    func startDownload(item: URL, to destinationURL: URL, completion: @escaping (DownloadSessionResult) -> Void) {
        
        downloadingItems.append(item)
        self.completion = completion
    }
    
    func finished(with result: DownloadSessionResult) {
        
        completion?(result)
    }
    
    var downloadingItems: [URL] = []
}
