//
//  DownloadManager.swift
//  Networking
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation
import Alamofire

public enum DownloadSessionResult {
    case progress(Int) // from 0 to 100
    case result(Swift.Result<URL, Error>)
}

public protocol DownloadSession {
    
    func startDownload(item: URL, to destinationURL: URL, completion: @escaping (DownloadSessionResult) -> Void)
}

public class DownloadManager: Downloader {
    
    private let session: DownloadSession
    
    public init(session: DownloadSession) {
        
        self.session = session
    }
    
    public func download(item: Downloadable, to destinationURL: URL, progress: DownloadProgress? = nil, downloadingResult: @escaping (DownloadingResult) -> Void) {
        
        session.startDownload(item: item.url, to: destinationURL) { sessionResult in
            
            switch sessionResult {
            case let .result(result):
                switch result {
                case .failure(let error):
                    downloadingResult(.failure(error))
                case .success:
                    downloadingResult(.success(item))
                }
            
            case .progress(let prog):
                progress?(prog)
            }
        }
    }
}
