//
//  Parser.swift
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

public class Parser<Object>: ResponseProcessor where Object: Decodable {
    
    public typealias ProcessingResult = Result<Object, Error>
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
            return .success(try JSONDecoder().decode(Object.self, from: data))
        } catch {
            return .failure(ProcessingError.default(error))
        }
    }
}
