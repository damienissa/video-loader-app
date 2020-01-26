//
//  NetworkingService.swift
//  Networking
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

public protocol NetworkingService {
    func execute<Processor: ResponseProcessor>(_ request: URLRequest,
                                               processor: Processor,
                                               completion: @escaping (Processor.ProcessingResult) -> Void)
    func download(item: Downloadable, completion: @escaping (Downloadable, Error?) -> Void)
}
