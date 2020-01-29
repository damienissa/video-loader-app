//
//  Downloader.swift
//  Networking
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

public protocol Downloadable: class {
    
    var id: String { get }
    var url: URL { get }
    var destinationUrl: URL { get set }
    var downloaded: Bool { get }
}

public protocol Downloader {
    
    func download(item: Downloadable, to destenationURL: URL, progress: DownloadProgress?, downloadingResult: @escaping (DownloadingResult) -> Void)
}
