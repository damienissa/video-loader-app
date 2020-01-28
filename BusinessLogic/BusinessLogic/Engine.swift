//
//  Engine.swift
//  Core
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation
import Networking

public final class Engine {
    
    // MARK: - Dependencies
    
    fileprivate let service: FetchService<Parser<FetchResponse>>
    fileprivate let network: NetworkingService
    fileprivate let database: DatabaseManager
    
    init(_ networking: NetworkingService, database: DatabaseManager = .shared) {
        
        self.network = networking
        self.database = database
        self.service = FetchService(service: network, processor: Parser())
    }
}


// MARK: - EngineInterface

public typealias EngineFetchResult = Result<Video, Error>
public typealias EngineFetchResultBlock = (EngineFetchResult) -> Void
public typealias EngineDownloadResult = Result<Resource, Error>
public typealias EngineDownloadResultBlock = (Result<Resource, Error>) -> Void

public protocol EngineInterface {
    
    func fetchInfo(for url: URL, completion: @escaping EngineFetchResultBlock)
    func videos() -> [Video]
    func download(item: Resource, completion: @escaping EngineDownloadResultBlock)
}

extension Engine: EngineInterface {
    
    public func fetchInfo(for url: URL, completion: @escaping EngineFetchResultBlock) {
        
        service.fetch(for: url) { [weak self] result in
            
            guard let strSelf = self else {
                return completion(.failure(Unknown.error))
            }
            
            do {
                let response = try result.get()
                let video = VideoFactory.video(from: response)
                strSelf.saveResponse(video)
                completion(.success(video))
            } catch {
                return completion(.failure(error))
            }
        }
    }
    
    public func videos() -> [Video] {
        
        database.objects(Video.self).array
    }
    
    public func download(item: Resource, completion: @escaping EngineDownloadResultBlock) {
        
        network.download(item: item, to: item.destinationUrl, with: nil) { result in
            
            switch result {
            case .success(let item as Resource):
                completion(.success(item))
            case .failure(let error):
                completion(.failure(error))
            default:
                completion(.failure(Unknown.error))
            }
        }
    }
    
    public func set(destenation: String, for resource: Resource) {
        
        database.change {
            
            resource.destinationUrlStr = destenation
        }
    }
}

// MARK: - Helpers

fileprivate extension Engine {
    
    func saveResponse(_ video: Video) {
                
        database.add(video)
    }
}

extension Stream: ResourceProvider {
    
}

extension FetchResponse: VideoProvider {
    public var resources: [ResourceProvider] {
        streams
    }
}
