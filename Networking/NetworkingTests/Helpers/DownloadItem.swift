//
//  DownloadItem.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

class DownloadItem: Downloadable, Equatable {
  
    var id: String
    var url: URL
    var destinationUrl: URL
    var downloaded: Bool
    
    init(id: String, url: URL, destinationUrl: URL, downloaded: Bool) {
        
        self.id = id
        self.url = url
        self.destinationUrl = destinationUrl
        self.downloaded = downloaded
    }
    
    static func ==(lhs: DownloadItem, rhs: DownloadItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func set(destination url: URL) {
        
        destinationUrl = url
        downloaded = true
    }
}
