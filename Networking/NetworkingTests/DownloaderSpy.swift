//
//  DownloaderSpy.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

class DownloaderSpy: Downloader {
    
    func cancel(items: [Downloadable]) {
        
        // May be improved
    }
    
    func removeDownloaded(items: [Downloadable]) {
        items.forEach { d in
            if responsedItems.contains(where: { item in
                d.id == item.id
            }) {
                
                responsedItems.removeAll(where: { $0.id == d.id })
            }
        }
    }
    
    func removeDownloaded(item: Downloadable) {
        // May be improved
    }
    
    func isDownloading(item: Downloadable) -> Bool {
        responsedItems.contains(where: { $0.id == item.id })
    }
    
    func downloadingProgress(forItem item: Downloadable) -> Double {
        // May be improved
        0
    }
    
    
    func download(items: [Downloadable]) {

        responsedItems.append(contentsOf: items)
    }
    
    
    var responsedItems: [Downloadable] = []
}
