//
//  AlamofireSessionManager.swift
//  Networking
//
//  Created by Dima Virych on 28.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Alamofire

public class AlamofireSessionManager: SessionManager {

}

extension AlamofireSessionManager: DownloadSession {
    
    public func startDownload(item: URL, to destenationURL: URL, completion: @escaping (DownloadSessionResult) -> Void)  {
        
        let request = download(item) { _, _ -> ( destinationURL: URL, options: DownloadRequest.DownloadOptions ) in
            
            DispatchQueue.main.sync {
                
                return (destenationURL, [.createIntermediateDirectories])
            }
        }
        
        request.downloadProgress { progress in
            
            let percent = Int( Float(progress.completedUnitCount) / Float(progress.totalUnitCount) * 100)
            completion(.progress(percent))
        }
        
        request.response { response in
            
            if let error = response.error {
                return completion(.result(.failure(error)))
            }
            
            completion(.result(.success(destenationURL)))
        }
    }
}
