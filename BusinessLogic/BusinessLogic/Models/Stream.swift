//
//  Stream.swift
//  BusinessLogic
//
//  Created by Dima Virych on 25.01.2020.
//  Copyright © 2020 Virych. All rights reserved.
//

public struct Stream: Codable {
    public let url: String
    public let format, formatNote: String
    public let streamExtension: String
    public let videoCodec: String
    public let audioCodec: AudioCodec
    public let height, width, fps: Int?
    public let fmtID: String
    public let filesize: Int?
    public let filesizePretty: String
    public let hasAudio, hasVideo, isHD: Bool

    public enum CodingKeys: String, CodingKey {
        case url, format
        case formatNote = "format_note"
        case streamExtension = "extension"
        case videoCodec = "video_codec"
        case audioCodec = "audio_codec"
        case height, width, fps
        case fmtID = "fmt_id"
        case filesize
        case filesizePretty = "filesize_pretty"
        case hasAudio = "has_audio"
        case hasVideo = "has_video"
        case isHD = "is_hd"
    }
}


public enum AudioCodec: String, Codable {
    case mp4A402 = "mp4a.40.2"
    case none = "none"
    case opus = "opus"
    case vorbis = "vorbis"
}
