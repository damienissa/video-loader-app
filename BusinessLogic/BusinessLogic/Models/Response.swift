//
//  Response.swift
//  BusinessLogic
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

public struct DefaultResponse: Codable {
    
    public let status: Bool
    public let message: String
}

public struct FetchResponse: Codable {
   
    public let status: Bool
    public let message, responseDescription, uploader: String
    public let url: String
    public let id: String
    public let isPlaylist: Bool
    public let site, title: String
    public let likeCount, dislikeCount, viewCount, duration: Int
    public let uploadDate: String
    public let tags: [String]
    public let uploaderURL: String
    public let thumbnail: String
    public let streams: [Stream]

    public enum CodingKeys: String, CodingKey {
        case status, message
        case responseDescription = "description"
        case uploader, url, id
        case isPlaylist = "is_playlist"
        case site, title
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
        case viewCount = "view_count"
        case duration
        case uploadDate = "upload_date"
        case tags
        case uploaderURL = "uploader_url"
        case thumbnail, streams
    }
}
