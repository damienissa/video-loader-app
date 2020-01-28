//
//  Parser.swift
//  BusinessLogic
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Networking

public enum ProcessingError: Error, Equatable {
    
    public static func == (lhs: ProcessingError, rhs: ProcessingError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
    
    
    case `default`(Error)
    case statusCode(Int?)
    case string(String)
    case unknown
    
    public var localizedDescription: String {
        
        switch self {
        case .default(let error):
            return error.localizedDescription
        case .statusCode(let status):
        return "\(status ?? -1)"
        case .string(let message):
        return message
        case .unknown:
        return "\(self)"
        
        }
    }
}

public class Parser<Object>: ResponseProcessor where Object: Decodable {
    
    public typealias ProcessingResult = Result<Object, Error>
    public init () { }
    
    public func process(_ response: Response) -> ProcessingResult {
        
        if !(response.reponse?.isSuccess ?? false) {
            return .failure(ProcessingError.statusCode((response.reponse as? HTTPURLResponse)?.statusCode))
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
