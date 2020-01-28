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
    
    func download(item: Downloadable, to destenationURL: URL, downloadingResult: @escaping (DownloadingResult) -> Void) {
        
        responsedItems.append(item)
        if let error = error {
            downloadingResult(.failure(error))
        } else {
            downloadingResult(.success(item))
        }
    }
    
    var responsedItems: [Downloadable] = []
}
