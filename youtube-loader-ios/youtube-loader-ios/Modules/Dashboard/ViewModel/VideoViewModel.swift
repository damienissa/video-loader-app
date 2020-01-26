//
//  VideoViewModel.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

struct VideoViewModel {
    
    struct Stream {
        
        let url: String
        let resolution: String
        let `extension`: String
    }
    
    let name: String
    let thumbnail: String
    let streams: [Stream]
}
