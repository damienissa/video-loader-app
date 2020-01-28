//
//  DownloaderSpy.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

class DownloaderSpy: Downloader {

    var error: NSError?
    
    var responsedItems: [Downloadable] = []
    
    func download(item: Downloadable, to destenationURL: URL, progress: DownloadProgress? = nil, downloadingResult: @escaping (DownloadingResult) -> Void) {
        
        responsedItems.append(item)
        
        progress?(100)
        
        if let error = error {
            downloadingResult(.failure(error))
        } else {
            downloadingResult(.success(item))
        }
        
        
    }
}
