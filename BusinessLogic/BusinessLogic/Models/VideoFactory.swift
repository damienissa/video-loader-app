//
//  VideoFactory.swift
//  Core
//
//  Created by Dima Virych on 26.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation

public protocol ResourceProvider {
    
    var url: String { get }
    var format: String { get }
    var filesizePretty: String { get }
    var streamExtension: String { get }
}

public protocol VideoProvider {
    
    var title: String { get }
    var id: String { get }
    var thumbnail: String { get }
    var resources: [ResourceProvider] { get }
}

public struct VideoFactory {
    
    public static func video(from response: VideoProvider) -> Video {
        
        let video = Video()
        video.name = response.title
        video.id = response.id
        video.thumbnail = response.thumbnail
        video.resources.append(objectsIn: response.resources.compactMap {
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
