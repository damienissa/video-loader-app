//
//  VideoFactory.swift
//  Core
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

struct VideoFactory {
    
    static func video(from response: FetchResponse) -> Video {
        
        let video = Video()
        video.name = response.title
        video.id = response.id
        video.thumbnail = response.thumbnail
        video.resources.append(objectsIn: response.streams.compactMap {
            let resource = Resource()
            resource.id = ($0.url as NSString).lastPathComponent
            resource.urlStr = $0.url
            resource.format = $0.format
            resource.filesize = $0.filesizePretty
            resource.resourceExtension = $0.streamExtension
                        
            return resource
        })
        
        return video
    }
}
