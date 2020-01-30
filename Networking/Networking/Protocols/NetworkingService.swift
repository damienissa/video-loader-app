//
//  NetworkingService.swift
//  Networking
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

public typealias DownloadingResult = Result<Downloadable, Error>
public typealias DownloadProgress = (Int) -> Void
public protocol NetworkingService {
   
    func execute<Processor: ResponseProcessor>(_ request: URLRequest,
                                               processor: Processor,
                                               completion: @escaping (Processor.ProcessingResult) -> Void)
    func download(item: Downloadable,
                  to destinationURL: URL,
                  with progress: DownloadProgress?,
                  completion: @escaping (DownloadingResult) -> Void)
}
