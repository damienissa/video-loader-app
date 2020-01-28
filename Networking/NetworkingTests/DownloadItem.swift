//
//  DownloadItem.swift
//  NetworkingTests
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

struct DownloadItem: Downloadable, Equatable {
    
    var id: String
    var url: URL
    var destinationUrl: URL
    var downloaded: Bool
    
    static func ==(lhs: DownloadItem, rhs: DownloadItem) -> Bool {
        return lhs.id == rhs.id
    }
}
