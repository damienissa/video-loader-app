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
        isValid(code: (self as? HTTPURLResponse)?.statusCode)
    }
    
    private func isValid(code: Int?) -> Bool {
        
        guard let code = code else {
            return false
        }
        
        return 200 ... 299 ~= code
    }
}
