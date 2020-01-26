//
//  VideoViewModelFactory.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

struct VideoViewModelFactory {
    
    static func createViewMode(from response: FetchResponse) -> VideoViewModel {
        
        VideoViewModel(name: response.title, thumbnail: response.thumbnail, streams: response.streams.map {
            VideoViewModel.Stream(url: $0.url, resolution: $0.formatNote + " " + $0.filesizePretty, extension: $0.streamExtension)
        })
    }
}
