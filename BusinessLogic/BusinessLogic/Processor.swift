//
//  Processor.swift
//  BusinessLogic
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

public enum ProcessingError: Error {
    
    case `default`(Error)
    case statusCode(Int?)
    case string(String)
    case unknown
}

public class Processor: ResponseProcessor {
    
    public typealias ProcessingResult = Result<FetchResponse, Error>
    public init () { }
    
    public func process(_ response: Response) -> ProcessingResult {
        
        if !(200 ... 299 ~= response.reponse?.status ?? -1) {
            return .failure(ProcessingError.statusCode(response.reponse?.status))
        }
        
        if let error = response.error {
            return .failure(ProcessingError.default(error))
        }
        
        guard let data = response.data else {
            return .failure(ProcessingError.unknown)
        }
        
        do {
            
            let `default` = try JSONDecoder().decode(DefaultResponse.self, from: data)
            
            guard `default`.status else {
                return .failure(ProcessingError.string(`default`.message))
            }
            
            return .success(try JSONDecoder().decode(FetchResponse.self, from: data))
        } catch {
            return .failure(ProcessingError.default(error))
        }
    }
}
