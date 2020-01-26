//
//  URLResponse+Status.swift
//  BusinessLogic
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

public extension URLResponse {
    
    var status: Int {
        (self as? HTTPURLResponse)?.statusCode ?? -1
    }
}
