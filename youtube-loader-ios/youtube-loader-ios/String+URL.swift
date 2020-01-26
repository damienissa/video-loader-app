//
//  String+URL.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

extension String {
    
    var url: URL? {
        URL(string: self)
    }
}
