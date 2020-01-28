//
//  Downloader.swift
//  Networking
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

public protocol Downloadable {
    
    var id: String { get }
    var url: URL { get }
    var destinationUrl: URL { get }
    var downloaded: Bool { get }
}

public protocol Downloader {
    
    func download(items: [Downloadable])
    
    func cancel(items: [Downloadable])
    
    func removeDownloaded(items: [Downloadable])
    
    func removeDownloaded(item: Downloadable)
    
    func isDownloading(item: Downloadable) -> Bool
    
    func downloadingProgress(forItem item: Downloadable) -> Double
}
