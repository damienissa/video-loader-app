//
//  UIVideoElement.swift
//  youtube-loader-ios
//
//  Created by Dima Virych on 27.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

import Foundation
import Core

public struct UIVideoElement {
    
    public struct Resource {
        
        public let id: String
        public let title: String
        public let `extension`: String
        public let url: String
        public let localID: String
        
        init(resource: Core.Resource) {
            
            id = resource.id
            title = resource.format + " " + resource.filesize
            `extension` = resource.resourceExtension
            url = resource.urlStr
            localID = resource.localID
        }
        
        var resource: Core.Resource? {
            try! DatabaseManager.realm(inMemory: false).objects(String(describing: Resource.self)).filter("id == %@", id).first as? Core.Resource
        }
        var destinationURL: URL? {
            resource?.destinationUrl
        }
    }
    
    public let id: String
    public let title: String
    public let thumbnail: String
    public let resources: [Resource]
    
    public init(video: Video) {
        
        id = video.id
        thumbnail = video.thumbnail
        title = video.name
        resources = video.resources.compactMap { (resource: Core.Resource) in
            Resource(resource: resource)
        }
    }
}
