//
//  ResponseProcessor.swift
//  Networking
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

public typealias Response = (data: Data?, reponse: URLResponse?, error: Error?)
public protocol ResponseProcessor {
    
    associatedtype ProcessingResult
    
    func process(_ response: Response) -> ProcessingResult
}
