//
//  URLResponse+Status.swift
//  BusinessLogic
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

public extension URLResponse {
    
    var isSuccess: Bool {
        if let code = (self as? HTTPURLResponse)?.statusCode {
            return (200 ... 299 ~= code)
        } else {
            return false
        }
    }
}
